import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Serviço para download de arquivos com cache local.
///
/// Usa Dio com streaming para não carregar o arquivo inteiro na memória,
/// garantindo bom desempenho mesmo com arquivos grandes.
class FileDownload {
  FileDownload._();
  static final FileDownload instance = FileDownload._();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
      responseType: ResponseType.bytes,
    ),
  );

  String? _cacheDir;

  Future<String> _getCacheDir() async {
    _cacheDir ??= (await getApplicationCacheDirectory()).path;
    return _cacheDir!;
  }

  /// Baixa o arquivo da [url] para o cache do app e retorna o [File].
  ///
  /// Se o arquivo já existir no cache e [forcar] for `false`, retorna o
  /// arquivo cacheado sem fazer nova requisicao.
  ///
  /// [onProgress] recebe o percentual de 0.0 a 1.0 durante o download.
  /// [receiveTimeout] permite customizar o timeout para arquivos grandes.
  ///
  /// Lanca [DioException] em caso de erro de rede e [HttpException] se
  /// o status HTTP for >= 400.
  Future<File> downloadFile(
    String url, {
    bool forcar = false,
    Map<String, String>? headers,
    void Function(double progress)? onProgress,
    Duration? receiveTimeout,
  }) async {
    final dir = await _getCacheDir();
    final file = File(p.join(dir, p.basename(Uri.parse(url).path)));

    if (!forcar && file.existsSync()) {
      return file;
    }

    final tmpFile = File('${file.path}.tmp');

    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
          receiveTimeout: receiveTimeout,
        ),
        onReceiveProgress: onProgress != null
            ? (received, total) {
                if (total > 0) onProgress(received / total);
              }
            : null,
      );

      if (response.statusCode != null && response.statusCode! >= 400) {
        throw HttpException(response.statusCode.toString());
      }

      await tmpFile.writeAsBytes(response.data!, flush: true);
      await tmpFile.rename(file.path);

      return file;
    } catch (_) {
      if (tmpFile.existsSync()) tmpFile.deleteSync();
      rethrow;
    }
  }

  /// Remove o arquivo cacheado referente a [url], se existir.
  Future<void> limparCache(String url) async {
    final dir = await _getCacheDir();
    final file = File(p.join(dir, p.basename(Uri.parse(url).path)));
    if (file.existsSync()) await file.delete();
  }
}
