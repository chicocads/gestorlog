import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/http/api_client.dart';
import '../../../models/cadastro/usuario_model.dart';

class UsuarioService {
  const UsuarioService(this._client);

  final ApiClient _client;

  Future<UsuarioModel> login({
    required String baseUrl,
    required String login,
    required String senha,
  }) async {
    final credentials = dotenv.env['AUTH_API_CADS1'] ?? '';
    final token = base64Encode(utf8.encode(credentials));

    final response = await _client.get(
      '$baseUrl/v1/usuarios/login/$login/senha/$senha',
      headers: {'Authorization': 'Basic $token'},
    );

    if (response.statusCode == 200) {
      final usuario = UsuarioModel.fromMap(
        response.data as Map<String, dynamic>,
      );
      if (usuario.id > 0) {
        return usuario;
      }
      throw Exception('Senha inválida');
    }

    throw Exception('Login ou senha inválidos (${response.statusCode})');
  }
}
