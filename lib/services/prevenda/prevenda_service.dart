import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/http/api_client.dart';
import '../../models/prevenda/prevenda_model.dart';
import 'request_prevenda.dart';
import 'response_prevenda.dart';

class PreVendaService {
  const PreVendaService(this._client);

  final ApiClient _client;

  Future<ResponsePreVenda> buscar({
    required String baseUrl,
    required String token,
    required RequestPreVenda request,
  }) async {
    final credentials = dotenv.env['AUTH_API_CADS1'] ?? '';
    final authToken = base64Encode(utf8.encode(credentials));

    final response = await _client.post(
      '$baseUrl/v1/prevenda/consultar',
      headers: {'Authorization': 'Basic $authToken'},
      body: request.toMap(),
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;

      final lista = data['lista'] as List<dynamic>? ?? [];
      final proximaPagina = data['proximaPagina'] as int? ?? 1;
      final qtdPaginas = data['qtdPaginas'] as int? ?? 1;
      final paginaAtual = int.tryParse(request.paginaAtual) ?? 1;

      return ResponsePreVenda(
        itens: lista
            .map((e) => PreVendaModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        paginaAtual: paginaAtual,
        proximaPagina: proximaPagina,
        qtdPaginas: qtdPaginas,
      );
    }

    throw Exception('Erro ao buscar pré-vendas (${response.statusCode})');
  }

  Future<PreVendaModel> buscarPorNumero({
    required String baseUrl,
    required String token,
    required int loja,
    required int numero,
  }) async {
    final response = await _client.get(
      '$baseUrl/v1/prevendas/$loja/$numero',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return PreVendaModel.fromMap(response.data as Map<String, dynamic>);
    }

    throw Exception('Pré-venda não encontrada (${response.statusCode})');
  }
}
