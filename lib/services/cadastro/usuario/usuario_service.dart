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
    final response = await _client.get(
      '$baseUrl/v1/usuarios/login/$login/senha/$senha',
      headers: AuthHeaders.basicCads1(),
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
