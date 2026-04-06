import '../../core/controllers/base_controller.dart';
import '../../models/carregamento/carregamento_model.dart';

import '../../services/carregamento/carregamento_service.dart';
import '../../services/carregamento/request_carregamento.dart';
import '../../services/carregamento/response_carregamento.dart';

class CarregamentoController extends BaseController {
  CarregamentoController(this._service, this._getBaseUrl, this._getToken);

  final CarregamentoService _service;
  final String Function() _getBaseUrl;
  final String Function() _getToken;

  ResponseCarregamento _response = ResponseCarregamento.empty();
  RequestCarregamento _filtro = RequestCarregamento.empty();
  CarregamentoModel _selecionado = CarregamentoModel.empty();

  List<CarregamentoModel> get itens => _response.itens;
  ResponseCarregamento get response => _response;
  RequestCarregamento get filtro => _filtro;
  CarregamentoModel get selecionado => _selecionado;
  bool get temMaisPaginas => _response.paginaAtual < _response.qtdPaginas;

  void setFiltro(RequestCarregamento filtro) {
    _filtro = filtro;
    notifyListeners();
  }

  Future<void> buscar(RequestCarregamento filtro) async {
    _filtro = filtro.copyWith(paginaAtual: '1');
    _response = ResponseCarregamento.empty();
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
    _selecionado = CarregamentoModel.empty();
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
    _response = ResponseCarregamento.empty();
    _filtro = RequestCarregamento.empty();
    _selecionado = CarregamentoModel.empty();
    clearError();
  }
}
