import '../../core/controllers/base_controller.dart';
import '../../models/cadastro/usuario_model.dart';
import '../../services/cadastro/usuario/usuario_service.dart';

class UsuarioController extends BaseController {
  UsuarioController(this._service, this._getBaseUrl);

  final UsuarioService _service;
  final String Function() _getBaseUrl;

  UsuarioModel _usuario = UsuarioModel.empty();

  UsuarioModel get usuario => _usuario;
  bool get isLogado => _usuario.id != 0;

  Future<bool> login(String login, String senha) async {
    await runAsync(() async {
      _usuario = await _service.login(
        baseUrl: _getBaseUrl(),
        login: login,
        senha: senha,
      );
    });
    return error == null;
  }

  void logout() {
    _usuario = UsuarioModel.empty();
    notifyListeners();
  }
}
