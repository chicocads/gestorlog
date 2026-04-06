import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class HttpApiClient extends ApiClient {
  const HttpApiClient({this.defaultHeaders = const {}});

  final Map<String, String> defaultHeaders;

  Map<String, String> _merged(Map<String, String>? headers) => {
        'Content-Type': 'application/json',
        ...defaultHeaders,
        if (headers != null) ...headers,
      };

  dynamic _decode(http.Response r) {
    if (r.body.isEmpty) return null;
    try {
      return jsonDecode(r.body);
    } catch (_) {
      return r.body;
    }
  }

  @override
  Future<ApiResponse> get(String url, {Map<String, String>? headers}) async {
    final r = await http.get(Uri.parse(url), headers: _merged(headers));
    return ApiResponse(statusCode: r.statusCode, data: _decode(r));
  }

  @override
  Future<ApiResponse> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final r = await http.post(
      Uri.parse(url),
      headers: _merged(headers),
      body: body != null ? jsonEncode(body) : null,
    );
    return ApiResponse(statusCode: r.statusCode, data: _decode(r));
  }

  @override
  Future<ApiResponse> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final r = await http.put(
      Uri.parse(url),
      headers: _merged(headers),
      body: body != null ? jsonEncode(body) : null,
    );
    return ApiResponse(statusCode: r.statusCode, data: _decode(r));
  }

  @override
  Future<ApiResponse> patch(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final r = await http.patch(
      Uri.parse(url),
      headers: _merged(headers),
      body: body != null ? jsonEncode(body) : null,
    );
    return ApiResponse(statusCode: r.statusCode, data: _decode(r));
  }

  @override
  Future<ApiResponse> delete(String url, {Map<String, String>? headers}) async {
    final r = await http.delete(Uri.parse(url), headers: _merged(headers));
    return ApiResponse(statusCode: r.statusCode, data: _decode(r));
  }
}
