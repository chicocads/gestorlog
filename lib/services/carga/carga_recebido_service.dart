import '../../core/http/api_client.dart';
import '../../core/http/http_retry.dart';
import '../../models/carga/carga_recebido_model.dart';
import 'request_carga_recebido.dart';

class CargaRecebidoService {
  const CargaRecebidoService(this._client);

  final ApiClient _client;

  Future<List<CargaRecebidoModel>> consultarPorCarga({
    required String baseUrl,
    required int idCarga,
  }) async {
    final response = await HttpRetry.run(
      () => _client.get(
        '$baseUrl/v1/cargarecebido/$idCarga',
        headers: AuthHeaders.basicCads1(),
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final lista = switch (data) {
        final List<dynamic> v => v,
        final Map<String, dynamic> v when v['lista'] is List<dynamic> =>
          v['lista'] as List<dynamic>,
        final Map<String, dynamic> v when v['itens'] is List<dynamic> =>
          v['itens'] as List<dynamic>,
        _ => const <dynamic>[],
      };
      return lista
          .map((e) => CargaRecebidoModel.fromMap(e as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 404) {
      return const <CargaRecebidoModel>[];
    }

    throw Exception(
      'Erro ao consultar recebimentos da carga (${response.statusCode})',
    );
  }

  Future<CargaRecebidoModel> inserir({
    required String baseUrl,
    required CargaRecebidoRequest request,
  }) async {
    final response = await HttpRetry.run(
      () => _client.post(
        '$baseUrl/v1/cargarecebido/inserir',
        headers: AuthHeaders.basicCads1(),
        body: request.toMap(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final id = (data['id'] as num?)?.toInt() ?? 0;
        if (id > 0) {
          return CargaRecebidoModel(
            id: id,
            idFilial: request.idfilial,
            idCarga: request.idcarga,
            idPreVenda: request.idprevenda,
            idFPagamento: request.idfpagamento,
            valor: request.valor,
          );
        }
        return CargaRecebidoModel.fromMap(data);
      }
      return CargaRecebidoModel.empty();
    }

    throw Exception('Erro ao inserir recebimento (${response.statusCode})');
  }

  Future<CargaRecebidoModel> alterar({
    required String baseUrl,
    required CargaRecebidoRequest request,
  }) async {
    final response = await HttpRetry.run(
      () => _client.put(
        '$baseUrl/v1/cargarecebido/alterar',
        headers: AuthHeaders.basicCads1(),
        body: request.toMap(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return CargaRecebidoModel.fromMap(data);
      }
      return CargaRecebidoModel.empty();
    }

    throw Exception('Erro ao alterar recebimento (${response.statusCode})');
  }

  Future<void> excluir({
    required String baseUrl,
    required int id,
  }) async {
    final response = await HttpRetry.run(
      () => _client.delete(
        '$baseUrl/v1/cargarecebido/$id',
        headers: AuthHeaders.basicCads1(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw Exception('Erro ao excluir recebimento (${response.statusCode})');
  }
}
