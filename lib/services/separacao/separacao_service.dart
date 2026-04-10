import 'package:sqflite/sqflite.dart';

import '../../core/database/database_helper.dart';
import '../../core/http/api_client.dart';
import '../../models/Separacao/separacao_model.dart';
import 'request_separacao.dart';

class SeparacaoService {
  SeparacaoService(this._client);

  final ApiClient _client;
  final _db = DatabaseHelper.instance;

  Future<SeparacaoModel?> get({
    required int loja,
    required int numero,
    required int ordem,
    required int idproduto,
  }) async {
    final database = await _db.db;
    final rows = await database.query(
      SeparacaoModel.tblNome,
      where:
          '${SeparacaoModel.colLoja} = ? AND ${SeparacaoModel.colNumero} = ? AND ${SeparacaoModel.colOrdem} = ? AND ${SeparacaoModel.colIdProduto} = ?',
      whereArgs: [loja, numero, ordem, idproduto],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return SeparacaoModel.fromMap(rows.first);
  }

  Future<List<SeparacaoModel>> listar({required int loja, int? numero}) async {
    final database = await _db.db;
    final rows = await database.query(
      SeparacaoModel.tblNome,
      where: numero == null
          ? '${SeparacaoModel.colLoja} = ?'
          : '${SeparacaoModel.colLoja} = ? AND ${SeparacaoModel.colNumero} = ?',
      whereArgs: numero == null ? [loja] : [loja, numero],
    );
    return rows.map(SeparacaoModel.fromMap).toList();
  }

  Future<void> gravar(SeparacaoModel conferencia) async {
    final database = await _db.db;
    await database.insert(
      SeparacaoModel.tblNome,
      conferencia.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletar({
    required int loja,
    required int numero,
    required int ordem,
    required int idproduto,
  }) async {
    final database = await _db.db;
    await database.delete(
      SeparacaoModel.tblNome,
      where:
          '${SeparacaoModel.colLoja} = ? AND ${SeparacaoModel.colNumero} = ? AND ${SeparacaoModel.colOrdem} = ? AND ${SeparacaoModel.colIdProduto} = ?',
      whereArgs: [loja, numero, ordem, idproduto],
    );
  }

  Future<void> limpar({required int loja, int? numero}) async {
    final database = await _db.db;
    await database.delete(
      SeparacaoModel.tblNome,
      where: numero == null
          ? '${SeparacaoModel.colLoja} = ?'
          : '${SeparacaoModel.colLoja} = ? AND ${SeparacaoModel.colNumero} = ?',
      whereArgs: numero == null ? [loja] : [loja, numero],
    );
  }

  Future<void> gravarConferencia({
    required String baseUrl,
    required RequestSeparacao request,
  }) async {
    final response = await _client.post(
      '$baseUrl/v1/prevenda/separacao',
      headers: AuthHeaders.basicCads1(),
      body: request.toMap(),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao gravar separação (${response.statusCode})');
    }
  }
}
