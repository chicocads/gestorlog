import 'package:sqflite/sqflite.dart';

import '../../core/database/database_helper.dart';
import '../../models/Separacao/separacao_model.dart';
import '../../models/hsaida/lote_saida_model.dart';

class SeparacaoLocalService {
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

  Future<List<LoteSaidaModel>> listarLotes({
    required int loja,
    required int numero,
  }) async {
    final database = await _db.db;
    final rows = await database.query(
      LoteSaidaModel.tblNome,
      where:
          '${LoteSaidaModel.colIdFilial} = ? AND ${LoteSaidaModel.colIdPrevenda} = ? AND ${LoteSaidaModel.colLote} <> "" AND ${LoteSaidaModel.colQtde} > 0',
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

  Future<void> deletarLotesVaziosProduto({
    required int loja,
    required int numero,
    required int idProduto,
  }) async {
    final database = await _db.db;
    await database.delete(
      LoteSaidaModel.tblNome,
      where:
          '${LoteSaidaModel.colIdFilial} = ? AND ${LoteSaidaModel.colIdPrevenda} = ? AND ${LoteSaidaModel.colIdProduto} = ? AND ( ${LoteSaidaModel.colLote} = "" OR ${LoteSaidaModel.colQtde} <= 0 )',
      whereArgs: [loja, numero, idProduto],
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
