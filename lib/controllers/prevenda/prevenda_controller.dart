import '../../core/controllers/base_controller.dart';
import '../../models/prevenda/prevenda_model.dart';
import '../../services/prevenda/prevenda_service.dart';
import '../../services/prevenda/request_prevenda.dart';
import '../../services/prevenda/response_prevenda.dart';

class PreVendaController extends BaseController {
  PreVendaController(this._service, this._getBaseUrl);

  final PreVendaService _service;
  final String Function() _getBaseUrl;

  ResponsePreVenda _response = ResponsePreVenda.empty();
  RequestPreVenda _filtro = RequestPreVenda.empty();
  PreVendaModel _selecionado = PreVendaModel.empty();

  List<PreVendaModel> get itens => _response.itens;
  ResponsePreVenda get response => _response;
  RequestPreVenda get filtro => _filtro;
  PreVendaModel get selecionado => _selecionado;
  bool get temMaisPaginas => _response.paginaAtual < _response.qtdPaginas;
  int get totalRegistros => _response.totalRegistros;

  void setFiltro(RequestPreVenda filtro) {
    _filtro = filtro;
    notifyListeners();
  }

  Future<void> buscar(RequestPreVenda filtro) async {
    _filtro = filtro.copyWith(paginaAtual: '1');
    _response = ResponsePreVenda.empty();
    await runAsync(() async {
      _response = await _service.buscar(
        baseUrl: _getBaseUrl(),
        request: _filtro,
      );
    });
  }

  Future<void> buscarMais() async {
    if (!temMaisPaginas || isLoading) return;
    await runAsync(() async {
      final proximaPagina = _response.proximaPagina.toString();
      final novaResposta = await _service.buscar(
        baseUrl: _getBaseUrl(),
        request: _filtro.copyWith(paginaAtual: proximaPagina),
      );
      _filtro = _filtro.copyWith(paginaAtual: proximaPagina);
      _response = _response.copyWith(
        itens: [..._response.itens, ...novaResposta.itens],
        paginaAtual: novaResposta.paginaAtual,
        proximaPagina: novaResposta.proximaPagina,
        qtdPaginas: novaResposta.qtdPaginas,
        totalRegistros: novaResposta.totalRegistros,
      );
    });
  }

  Future<void> buscarPorNumero(int loja, int numero) async {
    _selecionado = PreVendaModel.empty();
    await runAsync(() async {
      _selecionado = await _service.buscarPorNumero(
        baseUrl: _getBaseUrl(),
        loja: loja,
        numero: numero,
      );
    });
  }

  void removerDaLista({
    required int loja,
    required int numero,
  }) {
    final atual = _response.itens;
    final atualizado = atual
        .where((e) => !(e.idFilial == loja && e.idPrevenda == numero))
        .toList();
    if (atualizado.length == atual.length) return;

    _response = _response.copyWith(itens: atualizado);
    if (_selecionado.idFilial == loja && _selecionado.idPrevenda == numero) {
      _selecionado = PreVendaModel.empty();
    }
    notifyListeners();
  }

  void limpar() {
    _response = ResponsePreVenda.empty();
    _filtro = RequestPreVenda.empty();
    _selecionado = PreVendaModel.empty();
    clearError();
  }
}
