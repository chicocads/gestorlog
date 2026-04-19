import '../../core/http/api_client.dart';
import '../../core/http/http_retry.dart';
import 'request_separacao.dart';

class SeparacaoRemoteService {
  SeparacaoRemoteService(this._client);

  final ApiClient _client;

  Future<void> gravarConferencia({
    required String baseUrl,
    required RequestSeparacao request,
  }) async {
    final response = await HttpRetry.run(
      () => _client.post(
        '$baseUrl/v1/prevenda/separacao',
        headers: AuthHeaders.basicCads1(),
        body: request.toMap(),
      ),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao gravar separação (${response.statusCode})');
    }
  }
}
