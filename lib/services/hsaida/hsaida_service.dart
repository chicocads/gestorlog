import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/http/api_client.dart';
import '../../models/hsaida/hsaida_model.dart';
import 'request_hsaida.dart';
import 'request_hsaida_entrega.dart';
import 'response_hsaida.dart';

class HSaidaService {
  const HSaidaService(this._client);

  final ApiClient _client;

  Future<ResponseHSaida> buscar({
    required String baseUrl,
    required String token,
    required RequestHSaida request,
  }) async {
    final credentials = dotenv.env['AUTH_API_CADS1'] ?? '';
    final authToken = base64Encode(utf8.encode(credentials));

    final response = await _client.post(
      '$baseUrl/v1/hsaida/consultar',
      headers: {'Authorization': 'Basic $authToken'},
      body: request.toMap(),
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;

      final lista = data['lista'] as List<dynamic>? ?? [];
      final proximaPagina = data['proximaPagina'] as int? ?? 1;
      final qtdPaginas = data['qtdPaginas'] as int? ?? 1;
      final paginaAtual = int.tryParse(request.paginaAtual) ?? 1;

      return ResponseHSaida(
        itens: lista
            .map((e) => HSaidaModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        paginaAtual: paginaAtual,
        proximaPagina: proximaPagina,
        qtdPaginas: qtdPaginas,
      );
    }

    throw Exception('Erro ao buscar saídas (${response.statusCode})');
  }

  Future<HSaidaModel> buscarPorNumero({
    required String baseUrl,
    required String token,
    required int loja,
    required int numero,
  }) async {
    final credentials = dotenv.env['AUTH_API_CADS1'] ?? '';
    final authToken = base64Encode(utf8.encode(credentials));

    final response = await _client.get(
      '$baseUrl/v1/hsaida/$loja/$numero',
      headers: {'Authorization': 'Basic $authToken'},
    );

    if (response.statusCode == 200) {
      return HSaidaModel.fromMap(response.data as Map<String, dynamic>);
    }

    throw Exception('Saída não encontrada (${response.statusCode})');
  }

  Future<void> confirmarEntrega({
    required String baseUrl,
    required String token,
    required RequestHSaidaEntrega request,
  }) async {
    final credentials = dotenv.env['AUTH_API_CADS1'] ?? '';
    final authToken = base64Encode(utf8.encode(credentials));

    final response = await _client.put(
      '$baseUrl/v1/hsaida/entrega',
      headers: {'Authorization': 'Basic $authToken'},
      body: request.toMap(),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao confirmar entrega (${response.statusCode})');
    }
  }
}
