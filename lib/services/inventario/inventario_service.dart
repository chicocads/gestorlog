import '../../core/http/api_client.dart';
import '../../core/http/http_retry.dart';
import 'inventario_local_service.dart';
import 'request_inventario.dart';

class InventarioService {
  InventarioService(
    this._client, {
    InventarioLocalService? localService,
  }) : _localService = localService ?? InventarioLocalService();

  final ApiClient _client;
  final InventarioLocalService _localService;

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

    for (final item in itens) {
      final validade = item.validade.trim().isEmpty
          ? _dataAtualIso()
          : item.validade.trim();

      final request = RequestInventario(
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

      final response = await HttpRetry.run(
        () => _client.post(
          '$baseUrl/v1/inventario',
          headers: AuthHeaders.basicCads1(),
          body: request.toMap(),
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Erro ao enviar item de inventário ${item.id} (${response.statusCode})',
        );
      }

      enviados++;
    }

    return enviados;
  }
}
