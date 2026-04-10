import '../../core/http/api_client.dart';
import '../../models/carregamento/carregamento_model.dart';
import 'request_carregamento.dart';
import 'response_carregamento.dart';

class CarregamentoService {
  const CarregamentoService(this._client);

  final ApiClient _client;

  Future<ResponseCarregamento> buscar({
    required String baseUrl,
    required RequestCarregamento request,
  }) async {
    final response = await _client.post(
      '$baseUrl/v1/carregamento/consultar',
      headers: AuthHeaders.basicCads1(),
      body: request.toMap(),
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;

      final lista = data['lista'] as List<dynamic>? ?? [];
      final proximaPagina = data['proximaPagina'] as int? ?? 1;
      final qtdPaginas = data['qtdPaginas'] as int? ?? 1;
      final paginaAtual = int.tryParse(request.paginaAtual) ?? 1;

      return ResponseCarregamento(
        itens: lista
            .map((e) => CarregamentoModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        paginaAtual: paginaAtual,
        proximaPagina: proximaPagina,
        qtdPaginas: qtdPaginas,
      );
    }

    throw Exception('Erro ao buscar carregamentos (${response.statusCode})');
  }

  Future<CarregamentoModel> buscarPorNumero({
    required String baseUrl,
    required int loja,
    required int numero,
  }) async {
    final response = await _client.get(
      '$baseUrl/v1/carregamento/$loja/$numero',
      headers: AuthHeaders.basicCads1(),
    );

    if (response.statusCode == 200) {
      return CarregamentoModel.fromMap(response.data as Map<String, dynamic>);
    }

    throw Exception('Carregamento não encontrado (${response.statusCode})');
  }
}
