import '../../core/controllers/base_controller.dart';
import '../../models/Separacao/separacao_model.dart';
import '../../services/separacao/request_separacao.dart';
import '../../services/separacao/separacao_service.dart';

class PvSeparacaoController extends BaseController {
  PvSeparacaoController(this._service);

  final SeparacaoService _service;

  List<SeparacaoModel> _itens = [];
  SeparacaoModel? _selecionado;

  List<SeparacaoModel> get itens => _itens;
  SeparacaoModel? get selecionado => _selecionado;

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

  Future<void> finalizarSeparacao({
    required String baseUrl,
    required RequestSeparacao request,
  }) => runAsync(() async {
    await _service.gravarConferencia(baseUrl: baseUrl, request: request);
  });
}
