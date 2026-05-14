import '../../core/controllers/base_controller.dart';
import '../../models/carga/carga_model.dart';

import '../../services/carga/carga_service.dart';
import '../../services/carga/request_carga_consulta.dart';
import '../../services/carga/response_carga_consulta.dart';

class CarregamentoController extends BaseController {
  CarregamentoController(this._service, this._getBaseUrl);

  final CargaService _service;
  final String Function() _getBaseUrl;

  ResponseCargaConsulta _response = ResponseCargaConsulta.empty();
  RequestCargaConsulta _filtro = RequestCargaConsulta.empty();
  CargaModel _selecionado = CargaModel.empty();

  List<CargaModel> get itens => _response.itens;
  ResponseCargaConsulta get response => _response;
  RequestCargaConsulta get filtro => _filtro;
  CargaModel get selecionado => _selecionado;
  bool get temMaisPaginas => _response.paginaAtual < _response.qtdPaginas;
  int get totalRegistros => _response.totalRegistros;

  void setFiltro(RequestCargaConsulta filtro) {
    _filtro = filtro;
    notifyListeners();
  }

  Future<void> buscar(RequestCargaConsulta filtro) async {
    _filtro = filtro.copyWith(paginaAtual: '1');
    _response = ResponseCargaConsulta.empty();
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

  void atualizarKm({
    required int idFilial,
    required int idCarga,
    required double kmSaida,
    required double kmChegada,
  }) {
    final itensAtualizados = _response.itens.map((c) {
      if (c.idFilial == idFilial && c.idCarga == idCarga) {
        return c.copyWith(kmSaida: kmSaida, kmChegada: kmChegada);
      }
      return c;
    }).toList();
    _response = _response.copyWith(itens: itensAtualizados);
    notifyListeners();
  }

  void limpar() {
    _response = ResponseCargaConsulta.empty();
    _filtro = RequestCargaConsulta.empty();
    _selecionado = CargaModel.empty();
    clearError();
  }
}
