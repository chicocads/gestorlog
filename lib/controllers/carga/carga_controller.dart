import '../../core/controllers/base_controller.dart';
import '../../models/carga/carga_model.dart';

import '../../services/carga/carga_service.dart';
import '../../services/carga/request_carga.dart';
import '../../services/carga/response_carga.dart';

class CarregamentoController extends BaseController {
  CarregamentoController(this._service, this._getBaseUrl);

  final CargaService _service;
  final String Function() _getBaseUrl;

  ResponseCarga _response = ResponseCarga.empty();
  RequestCarga _filtro = RequestCarga.empty();
  CargaModel _selecionado = CargaModel.empty();

  List<CargaModel> get itens => _response.itens;
  ResponseCarga get response => _response;
  RequestCarga get filtro => _filtro;
  CargaModel get selecionado => _selecionado;
  bool get temMaisPaginas => _response.paginaAtual < _response.qtdPaginas;
  int get totalRegistros => _response.totalRegistros;

  void setFiltro(RequestCarga filtro) {
    _filtro = filtro;
    notifyListeners();
  }

  Future<void> buscar(RequestCarga filtro) async {
    _filtro = filtro.copyWith(paginaAtual: '1');
    _response = ResponseCarga.empty();
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
    _selecionado = CargaModel.empty();
    await runAsync(() async {
      _selecionado = await _service.buscarPorNumero(
        baseUrl: _getBaseUrl(),
        loja: loja,
        numero: numero,
      );
    });
  }

  void limpar() {
    _response = ResponseCarga.empty();
    _filtro = RequestCarga.empty();
    _selecionado = CargaModel.empty();
    clearError();
  }
}
