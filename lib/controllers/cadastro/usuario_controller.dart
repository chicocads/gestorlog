import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/controllers/base_controller.dart';
import '../../models/cadastro/usuario_model.dart';
import '../../services/cadastro/usuario/usuario_local_service.dart';
import '../../services/cadastro/usuario/usuario_service.dart';

class UsuarioController extends BaseController {
  UsuarioController(this._service, this._localService, this._getBaseUrl);

  final UsuarioService _service;
  final UsuarioLocalService _localService;
  final String Function() _getBaseUrl;

  UsuarioModel _usuario = UsuarioModel.empty();

  UsuarioModel get usuario => _usuario;
  bool get isLogado => _usuario.id != 0;

  Future<bool> login(String login, String senha) async {
    await runAsync(() async {
      try {
        _usuario = await _service.login(
          baseUrl: _getBaseUrl(),
          login: login,
          senha: senha,
        );
        // Salva com a senha digitada pelo usuário para funcionar o login offline
        await _localService.salvar(
          _usuario.copyWith(senha: senha.toUpperCase()),
        );
      } on SocketException {
        _usuario = await _buscarLocal(login, senha.toUpperCase());
      } on TimeoutException {
        _usuario = await _buscarLocal(login, senha.toUpperCase());
      } on DioException catch (e) {
        if (_isNetworkError(e)) {
          _usuario = await _buscarLocal(login, senha.toUpperCase());
        } else {
          rethrow;
        }
      }
    });
    return error == null;
  }

  bool _isNetworkError(DioException e) =>
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.unknown;

  Future<UsuarioModel> _buscarLocal(String login, String senha) async {
    final usuario = await _localService.buscarPorCredenciais(
      login: login,
      senha: senha,
    );
    if (usuario == null) throw Exception('Login ou senha inválidos (offline)');
    return usuario;
  }

  void logout() {
    _usuario = UsuarioModel.empty();
    notifyListeners();
  }
}
