import '../../core/http/api_client.dart';
import '../../core/http/http_retry.dart';
import '../../models/carga/carga_despesas_model.dart';
import 'request_carga_despesa.dart';

class CargaDespesaService {
  const CargaDespesaService(this._client);

  final ApiClient _client;

  Future<List<CargaDespesaModel>> consultarPorCarga({
    required String baseUrl,
    required int idCarga,
  }) async {
    final response = await HttpRetry.run(
      () => _client.get(
        '$baseUrl/v1/cargadespesa/$idCarga',
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
          .map((e) => CargaDespesaModel.fromMap(e as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 404) {
      return const <CargaDespesaModel>[];
    }

    throw Exception('Erro ao consultar despesas da carga (${response.statusCode})');
  }

  Future<CargaDespesaModel> inserir({
    required String baseUrl,
    required CargaDespesaRequest request,
  }) async {
    final response = await HttpRetry.run(
      () => _client.post(
        '$baseUrl/v1/cargadespesa/inserir',
        headers: AuthHeaders.basicCads1(),
        body: request.toMap(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final id = (data['id'] as num?)?.toInt() ?? 0;
        if (id > 0) {
          return CargaDespesaModel(
            id: id,
            idFilial: request.idfilial,
            idCarga: request.idcarga,
            data: request.data,
            descricao: request.descricao,
            valor: request.valor,
          );
        }
        return CargaDespesaModel.fromMap(data);
      }
      return CargaDespesaModel.empty();
    }

    throw Exception('Erro ao inserir despesa (${response.statusCode})');
  }

  Future<CargaDespesaModel> alterar({
    required String baseUrl,
    required CargaDespesaRequest request,
  }) async {
    final response = await HttpRetry.run(
      () => _client.put(
        '$baseUrl/v1/cargadespesa/alterar',
        headers: AuthHeaders.basicCads1(),
        body: request.toMap(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return CargaDespesaModel.fromMap(data);
      }
      return CargaDespesaModel.empty();
    }

    throw Exception('Erro ao alterar despesa (${response.statusCode})');
  }

  Future<void> excluir({
    required String baseUrl,
    required int id,
  }) async {
    final response = await HttpRetry.run(
      () => _client.delete(
        '$baseUrl/v1/cargadespesa/$id',
        headers: AuthHeaders.basicCads1(),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw Exception('Erro ao excluir despesa (${response.statusCode})');
  }
}
