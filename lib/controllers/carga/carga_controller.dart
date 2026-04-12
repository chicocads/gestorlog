import '../../core/controllers/base_controller.dart';
import '../../models/carga/carga_model.dart';

import '../../services/carga/carga_service.dart';
import '../../services/carga/request_carga.dart';
import '../../services/carga/response_carga.dart';

class CarregamentoController extends BaseController {
  CarregamentoController(this._service, this._getBaseUrl);

  final CarregamentoService _service;
  final String Function() _getBaseUrl;

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
      );
    });
  }

  Future<void> buscarPorNumero(int loja, int numero) async {
    _selecionado = CarregamentoModel.empty();
    await runAsync(() async {
      _selecionado = await _service.buscarPorNumero(
        baseUrl: _getBaseUrl(),
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
