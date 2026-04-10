import '../../core/controllers/base_controller.dart';
import '../../models/cadastro/filial_model.dart';
import '../../services/cadastro/filial/filial_service.dart';
import '../../services/cadastro/filial/request_filial.dart';
import '../../services/cadastro/filial/response_filial.dart';

class FilialController extends BaseController {
  FilialController(this._service, this._getBaseUrl);

  final FilialService _service;
  final String Function() _getBaseUrl;

  ResponseFilial _response = ResponseFilial.empty();
  RequestFilial _filtro = RequestFilial.empty(1);
  FilialModel _selecionado = FilialModel.empty();

  List<FilialModel> get itens => _response.itens;
  RequestFilial get filtro => _filtro;
  FilialModel get selecionado => _selecionado;

  Future<void> consultar(RequestFilial filtro) async {
    _filtro = filtro.copyWith(paginaAtual: '1');
    await runAsync(() async {
      _response = await _service.consultar(
        baseUrl: _getBaseUrl(),
        request: _filtro,
      );
    });
  }

  void selecionar(FilialModel filial) {
    _selecionado = filial;
    notifyListeners();
  }

  void limpar() {
    _filtro = RequestFilial.empty(0);
    _selecionado = FilialModel.empty();
    clearError();
  }
}
