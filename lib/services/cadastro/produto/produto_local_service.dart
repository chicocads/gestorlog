import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../../models/cadastro/produto_model.dart';

class ProdutoLocalService {
  final _db = DatabaseHelper.instance;

  Future<List<ProdutoModel>> listar({
    required int limit,
    required int offset,
    String termoCodigoBarra = '',
    String termoNome = '',
  }) async {
    final database = await _db.db;
    final termoCodigoBarraLimpo = termoCodigoBarra.trim();
    final termoNomeLimpo = termoNome.trim();
    final whereParts = <String>[];
    final whereArgs = <Object?>[];

    if (termoCodigoBarraLimpo.isNotEmpty) {
      final codigo = int.tryParse(termoCodigoBarraLimpo);
      final codigoOuBarraParts = <String>[
        '${ProdutoModel.colCodigoAlfa} LIKE ?',
        '${ProdutoModel.colDun14} LIKE ?',
      ];
      final likeTerm = '%$termoCodigoBarraLimpo%';
      final codigoOuBarraArgs = <Object?>[likeTerm, likeTerm];

      if (codigo != null) {
        codigoOuBarraParts.insert(0, '${ProdutoModel.colCodigo} = ?');
        codigoOuBarraArgs.insert(0, codigo);
      }

      whereParts.add('(${codigoOuBarraParts.join(' OR ')})');
      whereArgs.addAll(codigoOuBarraArgs);
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
