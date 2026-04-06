import '../../core/controllers/base_controller.dart';
import '../../models/prevenda/prevenda_model.dart';
import '../../services/prevenda/prevenda_service.dart';
import '../../services/prevenda/request_prevenda.dart';
import '../../services/prevenda/response_prevenda.dart';

class PreVendaController extends BaseController {
  PreVendaController(this._service, this._getBaseUrl, this._getToken);

  final PreVendaService _service;
  final String Function() _getBaseUrl;
  final String Function() _getToken;

  ResponsePreVenda _response = ResponsePreVenda.empty();
  RequestPreVenda _filtro = RequestPreVenda.empty();
  PreVendaModel _selecionado = PreVendaModel.empty();

  List<PreVendaModel> get itens => _response.itens;
  ResponsePreVenda get response => _response;
  RequestPreVenda get filtro => _filtro;
  PreVendaModel get selecionado => _selecionado;
  bool get temMaisPaginas => _response.paginaAtual < _response.qtdPaginas;

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
        token: _getToken(),
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
        token: _getToken(),
        request: _filtro.copyWith(paginaAtual: proximaPagina),
      );
      _filtro = _filtro.copyWith(paginaAtual: proximaPagina);
      _response = _response.copyWith(
        itens: [..._response.itens, ...novaResposta.itens],
        paginaAtual: novaResposta.paginaAtual,
        proximaPagina: novaResposta.proximaPagina,
        qtdPaginas: novaResposta.qtdPaginas,
      );
    });
  }

  Future<void> buscarPorNumero(int loja, int numero) async {
    _selecionado = PreVendaModel.empty();
    await runAsync(() async {
      _selecionado = await _service.buscarPorNumero(
        baseUrl: _getBaseUrl(),
        token: _getToken(),
        loja: loja,
        numero: numero,
      );
    });
  }

  void limpar() {
    _response = ResponsePreVenda.empty();
    _filtro = RequestPreVenda.empty();
    _selecionado = PreVendaModel.empty();
    clearError();
  }
}
