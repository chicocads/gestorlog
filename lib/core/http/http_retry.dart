import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'api_client.dart';

class HttpRetryOptions {
  const HttpRetryOptions({
    this.maxAttempts = 3,
    this.initialBackoff = const Duration(milliseconds: 500),
  });

  final int maxAttempts;
  final Duration initialBackoff;
}

class HttpRetry {
  const HttpRetry._();

  static const defaultOptions = HttpRetryOptions();

  static Future<ApiResponse> run(
    Future<ApiResponse> Function() request, {
    HttpRetryOptions options = defaultOptions,
  }) async {
    var backoff = options.initialBackoff;

    for (var attempt = 1; attempt <= options.maxAttempts; attempt++) {
      try {
        final response = await request();
        if (!isRetryableStatus(response.statusCode) ||
            attempt == options.maxAttempts) {
          return response;
        }
      } on DioException catch (e) {
        if (!isRetryableDioException(e) || attempt == options.maxAttempts) {
          rethrow;
        }
      } on SocketException {
        if (attempt == options.maxAttempts) rethrow;
      } on TimeoutException {
        if (attempt == options.maxAttempts) rethrow;
      }

      await Future.delayed(backoff);
      backoff *= 2;
    }

    throw Exception(
      'Falha ao executar requisicao apos ${options.maxAttempts} tentativas.',
    );
  }

  static bool isRetryableStatus(int statusCode) =>
      statusCode == 408 ||
      statusCode == 425 ||
      statusCode == 429 ||
      (statusCode >= 500 && statusCode <= 599);

  static bool isRetryableDioException(DioException error) =>
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.unknown;
}
