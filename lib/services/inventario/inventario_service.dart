import '../../core/http/api_client.dart';
import '../../core/http/http_retry.dart';
import 'inventario_local_service.dart';
import 'request_inventario.dart';

class InventarioService {
  InventarioService(this._client, {InventarioLocalService? localService})
    : _localService = localService ?? InventarioLocalService();

  final ApiClient _client;
  final InventarioLocalService _localService;

  static const int _batchSize = 500;

  String _dataAtualIso() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  Future<int> enviarItensColetados({
    required String baseUrl,
    required int idFilial,
    required int idInventario,
    required int idPda,
  }) async {
    final itens = await _localService.listar(limit: 100000);
    if (itens.isEmpty) return 0;

    var enviados = 0;

    for (var offset = 0; offset < itens.length; offset += _batchSize) {
      final end = (offset + _batchSize) > itens.length
          ? itens.length
          : offset + _batchSize;
      final batch = itens.sublist(offset, end);

      final requests = batch
          .map((item) {
            final validade = item.validade.trim().isEmpty
                ? _dataAtualIso()
                : item.validade.trim();

            return RequestInventario(
              id: item.id,
              idFilial: idFilial,
              produto: item.produto,
              codigoBarra: item.codigoBarra.trim(),
              qtde: item.qtde,
              pecas: item.pecas,
              lote: item.lote.trim(),
              validade: validade,
              nomePro: item.nomePro.trim(),
              idInventario: idInventario,
              idPda: idPda,
            );
          })
          .toList(growable: false);

      final response = await HttpRetry.run(
        () => _client.post(
          '$baseUrl/v1/inventario',
          headers: AuthHeaders.basicCads1(),
          body: requests.map((e) => e.toMap()).toList(),
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Erro ao enviar inventário (itens ${offset + 1}-$end) (${response.statusCode})',
        );
      }

      enviados += batch.length;
    }

    return enviados;
  }
}
