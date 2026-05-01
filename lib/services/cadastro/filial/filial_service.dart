import '../../../core/http/api_client.dart';
import '../../../core/http/http_retry.dart';
import '../../../models/cadastro/filial_model.dart';
import 'request_filial.dart';
import 'response_filial.dart';

class FilialService {
  const FilialService(this._client);

  final ApiClient _client;

  Future<ResponseFilial> consultar({
    required String baseUrl,
    required RequestFilial request,
  }) async {
    final response = await HttpRetry.run(
      () => _client.post(
        '$baseUrl/v1/empresas/consultar',
        headers: AuthHeaders.basicCads1(),
        body: request.toMap(),
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;

      final lista = data['lista'] as List<dynamic>? ?? [];
      final proximaPagina = data['proximaPagina'] as int? ?? 1;
      final qtdPaginas = data['qtdPaginas'] as int? ?? 1;
      final totalRegistros =
          data['totalRegistros'] as int? ?? data['total_registros'] as int? ?? 0;
      final paginaAtual = int.tryParse(request.paginaAtual) ?? 1;

      return ResponseFilial(
        itens: lista
            .map((e) => FilialModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        paginaAtual: paginaAtual,
        proximaPagina: proximaPagina,
        qtdPaginas: qtdPaginas,
        totalRegistros: totalRegistros,
      );
    }

    throw Exception('Erro ao consultar filiais (${response.statusCode})');
  }
}
