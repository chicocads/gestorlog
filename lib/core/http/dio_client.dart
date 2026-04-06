import 'package:dio/dio.dart';
import 'api_client.dart';

class DioApiClient extends ApiClient {
  DioApiClient({Map<String, String> defaultHeaders = const {}})
      : _dio = Dio(
          BaseOptions(
            headers: {
              'Content-Type': 'application/json',
              ...defaultHeaders,
            },
            validateStatus: (_) => true, // não lança exceção por status HTTP
          ),
        );

  final Dio _dio;

  Options _options(Map<String, String>? headers) =>
      headers != null ? Options(headers: headers) : Options();

  @override
  Future<ApiResponse> get(String url, {Map<String, String>? headers}) async {
    final r = await _dio.get(url, options: _options(headers));
    return ApiResponse(statusCode: r.statusCode ?? 0, data: r.data);
  }

  @override
  Future<ApiResponse> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final r = await _dio.post(url, data: body, options: _options(headers));
    return ApiResponse(statusCode: r.statusCode ?? 0, data: r.data);
  }

  @override
  Future<ApiResponse> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final r = await _dio.put(url, data: body, options: _options(headers));
    return ApiResponse(statusCode: r.statusCode ?? 0, data: r.data);
  }

  @override
  Future<ApiResponse> patch(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final r = await _dio.patch(url, data: body, options: _options(headers));
    return ApiResponse(statusCode: r.statusCode ?? 0, data: r.data);
  }

  @override
  Future<ApiResponse> delete(String url, {Map<String, String>? headers}) async {
    final r = await _dio.delete(url, options: _options(headers));
    return ApiResponse(statusCode: r.statusCode ?? 0, data: r.data);
  }
}
