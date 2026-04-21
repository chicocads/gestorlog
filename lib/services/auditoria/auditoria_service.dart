import '../../core/http/api_client.dart';
import '../../core/http/http_retry.dart';
import '../../models/diversos/auditoria_model.dart';
import 'request_alterar_barra_produto.dart';
import 'request_endereco_produto.dart';

class AuditoriaService {
  const AuditoriaService(this._client);

  final ApiClient _client;

  Future<AuditoriaLogisticaModel> consultarLogisticaPorCodigoBarras({
    required String baseUrl,
    required int idFilial,
    required String chave,
  }) async {
    final response = await HttpRetry.run(
      () => _client.get(
        '$baseUrl/v1/produtos/auditoriaLogisticaPorCodigoBarras/$idFilial/$chave',
        headers: AuthHeaders.basicCads1(),
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      return AuditoriaLogisticaModel.fromMap(data);
    }

    if (response.statusCode == 404) {
      throw Exception('Sr(a). Usuário, recurso não encontrado!');
    }

    throw Exception(
      'Erro ao consultar auditoria logística (${response.statusCode})',
    );
  }

  Future<bool> alterarEnderecoPorCodigo({
    required String baseUrl,
    required int idProduto,
    required RequestAlterarEnderecoProduto request,
  }) async {
    final response = await HttpRetry.run(
      () => _client.put(
        '$baseUrl/v1/produtos/alterarEnderecoPorCodigo/$idProduto',
        headers: AuthHeaders.basicCads1(),
        body: request.toMap(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }

    if (response.statusCode == 404) {
      throw Exception('Sr(a). Usuário, recurso não encontrado!');
    }

    throw Exception(
      'Erro ao alterar endereço do produto (${response.statusCode})',
    );
  }

  Future<bool> alterarCodigoBarraProduto({
    required String baseUrl,
    required RequestAlterarCodigoBarraProduto request,
  }) async {
    final response = await HttpRetry.run(
      () => _client.put(
        '$baseUrl/v1/produtos/alterarCodigoBarras',
        headers: AuthHeaders.basicCads1(),
        body: request.toMap(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }

    if (response.statusCode == 404) {
      throw Exception('Sr(a). Usuário, recurso não encontrado!');
    }

    throw Exception(response.statusCode);
  }
}
