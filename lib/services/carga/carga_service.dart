import '../../core/http/api_client.dart';
import '../../core/http/http_retry.dart';
import '../../models/carga/carga_model.dart';
import 'request_carga.dart';
import 'request_carga_pv.dart';
import 'response_carga.dart';

class CargaService {
  const CargaService(this._client);

  final ApiClient _client;

  Future<ResponseCarga> buscar({
    required String baseUrl,
    required RequestCarga request,
  }) async {
    final response = await HttpRetry.run(
      () => _client.post(
        '$baseUrl/v1/carga/consultar',
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
          data['totalRegistros'] as int? ??
          data['total_registros'] as int? ??
          0;
      final paginaAtual = int.tryParse(request.paginaAtual) ?? 1;

      return ResponseCarga(
        itens: lista
            .map((e) => CargaModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        paginaAtual: paginaAtual,
        proximaPagina: proximaPagina,
        qtdPaginas: qtdPaginas,
        totalRegistros: totalRegistros,
      );
    }

    throw Exception('Erro ao buscar carregamentos (${response.statusCode})');
  }

  Future<CargaModel> buscarPorNumero({
    required String baseUrl,
    required int loja,
    required int numero,
  }) async {
    final response = await HttpRetry.run(
      () => _client.get(
        '$baseUrl/v1/carga/$loja/$numero',
        headers: AuthHeaders.basicCads1(),
      ),
    );

    if (response.statusCode == 200) {
      return CargaModel.fromMap(response.data as Map<String, dynamic>);
    }

    throw Exception('Carga não encontrado (${response.statusCode})');
  }

  Future<void> confirmarEntrega({
    required String baseUrl,
    required CargaPvRequest request,
  }) async {
    final response = await HttpRetry.run(
      () => _client.put(
        '$baseUrl/v1/pvcarga/salvar',
        headers: AuthHeaders.basicCads1(),
        body: request.toMap(),
      ),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao confirmar entrega (${response.statusCode})');
    }
  }
}
