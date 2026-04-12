import '../../core/controllers/base_controller.dart';
import '../../models/hsaida/hsaida_model.dart';
import '../../services/carga/carga_service.dart';
import '../../services/hsaida/hsaida_service.dart';
import '../../services/hsaida/request_hsaida.dart';
import '../../services/carga/request_pv_carga.dart';
import '../../services/hsaida/response_hsaida.dart';

class HSaidaController extends BaseController {
  HSaidaController(this._service, this._carregamentoService, this._getBaseUrl);

  final HSaidaService _service;
  final CarregamentoService _carregamentoService;
  final String Function() _getBaseUrl;

  ResponseHSaida _response = ResponseHSaida.empty();
  RequestHSaida _filtro = RequestHSaida.empty();
  HSaidaModel _selecionado = HSaidaModel.empty();

  List<HSaidaModel> get itens => _response.itens;
  ResponseHSaida get response => _response;
  RequestHSaida get filtro => _filtro;
  HSaidaModel get selecionado => _selecionado;
  bool get temMaisPaginas => _response.paginaAtual < _response.qtdPaginas;

  void setFiltro(RequestHSaida filtro) {
    _filtro = filtro;
    notifyListeners();
  }

  void setSelecionado(HSaidaModel item) {
    _selecionado = item;
    notifyListeners();
  }

  Future<void> buscar(RequestHSaida filtro) async {
    _filtro = filtro.copyWith(paginaAtual: '1');
    _response = ResponseHSaida.empty();
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
    _selecionado = HSaidaModel.empty();
    await runAsync(() async {
      _selecionado = await _service.buscarPorNumero(
        baseUrl: _getBaseUrl(),
        loja: loja,
        numero: numero,
      );
    });
  }

  Future<void> confirmarEntrega(PvCargaRequest request) async {
    await runAsync(() async {
      await _carregamentoService.confirmarEntrega(
        baseUrl: _getBaseUrl(),
        request: request,
      );
      _response = _response.copyWith(
        itens: _response.itens
            .map(
              (e) =>
                  (e.idFilial == request.idfilial &&  
                      e.idPrevenda == request.idprevenda)
                  ? e.copyWith(
                      entregue: request.situacao,
                      dtEntrega: DateTime.now().toIso8601String(),
                    )
                  : e,
            )
            .toList(),
      );
      if (_selecionado.idFilial == request.idfilial &&  
          _selecionado.idPrevenda == request.idprevenda) {  
        _selecionado = _selecionado.copyWith(
          entregue: request.situacao,
          dtEntrega: DateTime.now().toIso8601String(),
        );
      }
    });
  }

  void limpar() {
    _response = ResponseHSaida.empty();
    _filtro = RequestHSaida.empty();
    _selecionado = HSaidaModel.empty();
    clearError();
  }
}
