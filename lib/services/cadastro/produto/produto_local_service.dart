import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../../models/cadastro/produto_model.dart';

class ProdutoLocalService {
  final _db = DatabaseHelper.instance;

  Future<ProdutoModel?> buscarPorCodigo(int codigo) async {
    final database = await _db.db;
    final rows = await database.query(
      ProdutoModel.tblNome,
      where: '${ProdutoModel.colCodigo} = ?',
      whereArgs: [codigo],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ProdutoModel.fromMap(rows.first);
  }

  Future<ProdutoModel?> buscarPorCodigoBarra(String codigoBarra) async {
    final termo = codigoBarra.trim();
    if (termo.isEmpty) return null;
    final database = await _db.db;
    final rows = await database.query(
      ProdutoModel.tblNome,
      where:
          '(${ProdutoModel.colCodigoAlfa} = ? OR ${ProdutoModel.colDun14} = ?)',
      whereArgs: [termo, termo],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ProdutoModel.fromMap(rows.first);
  }

  Future<List<ProdutoModel>> listar({
    required int limit,
    required int offset,
    int? codigo,
    String termoBarra = '',
    String termoNome = '',
  }) async {
    final database = await _db.db;
    final termoBarraLimpo = termoBarra.trim();
    final termoNomeLimpo = termoNome.trim();
    final whereParts = <String>[];
    final whereArgs = <Object?>[];

    if (codigo != null) {
      whereParts.add('${ProdutoModel.colCodigo} = ?');
      whereArgs.add(codigo);
    }

    if (termoBarraLimpo.isNotEmpty) {
      whereParts.add(
        '(${ProdutoModel.colDun14} LIKE ? OR ${ProdutoModel.colCodigoAlfa} LIKE ?)',
      );
      whereArgs
        ..add('%$termoBarraLimpo%')
        ..add('%$termoBarraLimpo%');
    }

    if (termoNomeLimpo.isNotEmpty) {
      whereParts.add('${ProdutoModel.colNome} LIKE ?');
      whereArgs.add('%$termoNomeLimpo%');
    }

    final rows = await database.query(
      ProdutoModel.tblNome,
      where: whereParts.isEmpty ? null : whereParts.join(' AND '),
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: '${ProdutoModel.colCodigo} ASC',
      limit: limit,
      offset: offset,
    );
    return rows.map(ProdutoModel.fromMap).toList();
  }

  Future<int> contar({
    int? codigo,
    String termoBarra = '',
    String termoNome = '',
  }) async {
    final database = await _db.db;
    final termoBarraLimpo = termoBarra.trim();
    final termoNomeLimpo = termoNome.trim();
    final whereParts = <String>[];
    final whereArgs = <Object?>[];

    if (codigo != null) {
      whereParts.add('${ProdutoModel.colCodigo} = ?');
      whereArgs.add(codigo);
    }

    if (termoBarraLimpo.isNotEmpty) {
      whereParts.add(
        '(${ProdutoModel.colDun14} LIKE ? OR ${ProdutoModel.colCodigoAlfa} LIKE ?)',
      );
      whereArgs
        ..add('%$termoBarraLimpo%')
        ..add('%$termoBarraLimpo%');
    }

    if (termoNomeLimpo.isNotEmpty) {
      whereParts.add('${ProdutoModel.colNome} LIKE ?');
      whereArgs.add('%$termoNomeLimpo%');
    }

    final whereSql =
        whereParts.isEmpty ? '' : 'WHERE ${whereParts.join(' AND ')}';

    final rows = await database.rawQuery(
      'SELECT COUNT(*) as total FROM ${ProdutoModel.tblNome} $whereSql',
      whereArgs,
    );
    return Sqflite.firstIntValue(rows) ?? 0;
  }

  Future<void> limpar() async {
    final database = await _db.db;
    await database.delete(ProdutoModel.tblNome);
  }

  Future<void> gravarTodos(List<ProdutoModel> produtos) async {
    if (produtos.isEmpty) return;

    final database = await _db.db;
    final batch = database.batch();

    for (final produto in produtos) {
      batch.insert(
        ProdutoModel.tblNome,
        produto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
