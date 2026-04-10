import '../../core/controllers/base_controller.dart';
import '../../models/Separacao/separacao_model.dart';
import '../../models/lote_saida_model.dart';
import '../../services/separacao/request_separacao.dart';
import '../../services/separacao/separacao_service.dart';

class PvSeparacaoController extends BaseController {
  PvSeparacaoController(this._service);

  final SeparacaoService _service;

  List<SeparacaoModel> _itens = [];
  SeparacaoModel? _selecionado;
  Map<int, List<LoteSaidaModel>> _lotesPorProduto = {};

  List<SeparacaoModel> get itens => _itens;
  SeparacaoModel? get selecionado => _selecionado;
  Map<int, List<LoteSaidaModel>> get lotesPorProduto => _lotesPorProduto;

  List<LoteSaidaModel> lotesDoProduto(int idProduto) =>
      _lotesPorProduto[idProduto] ?? const [];

  Future<void> listar(int loja, {int? numero}) => runAsync(() async {
    _itens = await _service.listar(loja: loja, numero: numero);
  });

  Future<void> gravar(SeparacaoModel conferencia) => runAsync(() async {
    await _service.gravar(conferencia);
    _selecionado = conferencia;
    final idx = _itens.indexWhere(
      (e) =>
          e.loja == conferencia.loja &&
          e.numero == conferencia.numero &&
          e.ordem == conferencia.ordem &&
          e.idproduto == conferencia.idproduto,
    );
    if (idx >= 0) {
      _itens = [..._itens]..[idx] = conferencia;
    } else {
      _itens = [..._itens, conferencia];
    }
  });

  Future<SeparacaoModel?> buscar({
    required int loja,
    required int numero,
    required int ordem,
    required int idproduto,
  }) async {
    await runAsync(() async {
      _selecionado = await _service.get(
        loja: loja,
        numero: numero,
        ordem: ordem,
        idproduto: idproduto,
      );
    });
    return _selecionado;
  }

  Future<void> deletar({
    required int loja,
    required int numero,
    required int ordem,
    required int idproduto,
  }) => runAsync(() async {
    await _service.deletar(
      loja: loja,
      numero: numero,
      ordem: ordem,
      idproduto: idproduto,
    );
    _itens = _itens
        .where(
          (e) =>
              !(e.loja == loja &&
                  e.numero == numero &&
                  e.ordem == ordem &&
                  e.idproduto == idproduto),
        )
        .toList();
    if (_selecionado?.loja == loja &&
        _selecionado?.numero == numero &&
        _selecionado?.ordem == ordem &&
        _selecionado?.idproduto == idproduto) {
      _selecionado = null;
    }
  });

  Future<void> limpar(int loja, {int? numero}) => runAsync(() async {
    await _service.limpar(loja: loja, numero: numero);
    _itens = [];
    _selecionado = null;
  });

  Future<void> listarLotes(int loja, int numero) => runAsync(() async {
    final lotes = await _service.listarLotes(loja: loja, numero: numero);
    final grouped = <int, List<LoteSaidaModel>>{};
    for (final l in lotes) {
      (grouped[l.idProduto] ??= []).add(l);
    }
    _lotesPorProduto = grouped;
  });

  Future<void> gravarLote({
    required LoteSaidaModel lote,
    String? oldLote,
    String? oldValidade,
  }) =>
      runAsync(() async {
        await _service.gravarLote(lote);
        if (oldLote != null &&
            oldValidade != null &&
            (oldLote != lote.lote || oldValidade != lote.validade)) {
          await _service.deletarLote(
            loja: lote.idFilial,
            numero: lote.idPrevenda,
            idProduto: lote.idProduto,
            lote: oldLote,
            validade: oldValidade,
          );
        }

        final existing = _lotesPorProduto[lote.idProduto] ?? const [];
        final idx = existing.indexWhere(
          (e) => e.lote == lote.lote && e.validade == lote.validade,
        );
        if (idx >= 0) {
          final updated = [...existing]..[idx] = lote;
          _lotesPorProduto = {..._lotesPorProduto, lote.idProduto: updated};
        } else {
          _lotesPorProduto = {
            ..._lotesPorProduto,
            lote.idProduto: [...existing, lote],
          };
        }
      });

  Future<void> deletarLote(LoteSaidaModel lote) => runAsync(() async {
    await _service.deletarLote(
      loja: lote.idFilial,
      numero: lote.idPrevenda,
      idProduto: lote.idProduto,
      lote: lote.lote,
      validade: lote.validade,
    );
    final existing = _lotesPorProduto[lote.idProduto];
    if (existing == null) return;
    final updated = existing
        .where((e) => !(e.lote == lote.lote && e.validade == lote.validade))
        .toList();
    _lotesPorProduto = {..._lotesPorProduto, lote.idProduto: updated};
  });

  Future<void> finalizarSeparacao({
    required String baseUrl,
    required RequestSeparacao request,
  }) => runAsync(() async {
    await _service.gravarConferencia(baseUrl: baseUrl, request: request);
  });
}
