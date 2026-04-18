import 'package:sqflite/sqflite.dart';
import '../core/database/database_helper.dart';
import '../models/diversos/parametro_model.dart';

class ParametroService {
  final _db = DatabaseHelper.instance;

  Future<ParametroModel> get() async {
    final database = await _db.db;
    final rows = await database.query(
      ParametroModel.tblNome,
      where: '${ParametroModel.colId} = ?',
      whereArgs: [1],
    );
    if (rows.isEmpty) return ParametroModel.empty();
    return ParametroModel.fromMap(rows.first);
  }

  Future<void> save(ParametroModel parametro) async {
    final database = await _db.db;
    await database.insert(
      ParametroModel.tblNome,
      parametro.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
