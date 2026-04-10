import 'package:sqflite/sqflite.dart';

import '../../core/database/database_helper.dart';
import '../../core/http/api_client.dart';
import '../../models/Separacao/separacao_model.dart';
import '../../models/lote_saida_model.dart';
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

  Future<List<LoteSaidaModel>> listarLotes({
    required int loja,
    required int numero,
  }) async {
    final database = await _db.db;
    final rows = await database.query(
      LoteSaidaModel.tblNome,
      where:
          '${LoteSaidaModel.colIdFilial} = ? AND ${LoteSaidaModel.colIdPrevenda} = ?',
      whereArgs: [loja, numero],
    );
    return rows.map(LoteSaidaModel.fromMap).toList();
  }

  Future<void> gravarLote(LoteSaidaModel lote) async {
    final database = await _db.db;
    await database.insert(
      LoteSaidaModel.tblNome,
      lote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletarLote({
    required int loja,
    required int numero,
    required int idProduto,
    required String lote,
    required String validade,
  }) async {
    final database = await _db.db;
    await database.delete(
      LoteSaidaModel.tblNome,
      where:
          '${LoteSaidaModel.colIdFilial} = ? AND ${LoteSaidaModel.colIdPrevenda} = ? AND ${LoteSaidaModel.colIdProduto} = ? AND ${LoteSaidaModel.colLote} = ? AND ${LoteSaidaModel.colValidade} = ?',
      whereArgs: [loja, numero, idProduto, lote, validade],
    );
  }

  Future<void> limparLotes({required int loja, int? numero}) async {
    final database = await _db.db;
    await database.delete(
      LoteSaidaModel.tblNome,
      where: numero == null
          ? '${LoteSaidaModel.colIdFilial} = ?'
          : '${LoteSaidaModel.colIdFilial} = ? AND ${LoteSaidaModel.colIdPrevenda} = ?',
      whereArgs: numero == null ? [loja] : [loja, numero],
    );
  }
}
