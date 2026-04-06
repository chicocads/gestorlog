/// Resposta padronizada retornada por qualquer implementação de [ApiClient].
class ApiResponse {
  const ApiResponse({
    required this.statusCode,
    required this.data,
  });

  final int statusCode;

  /// Corpo da resposta já decodificado (Map, List ou String).
  final dynamic data;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  @override
  String toString() => 'ApiResponse(statusCode: $statusCode, data: $data)';
}

/// Contrato que todas as implementações HTTP devem seguir.
/// Troque a implementação em [AppRoutes] sem alterar nenhum service.
abstract class ApiClient {
  const ApiClient();

  Future<ApiResponse> get(
    String url, {
    Map<String, String>? headers,
  });

  Future<ApiResponse> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future<ApiResponse> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future<ApiResponse> patch(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future<ApiResponse> delete(
    String url, {
    Map<String, String>? headers,
  });
}
