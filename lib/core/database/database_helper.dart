import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/Separacao/separacao_model.dart';
import '../../models/parametro_model.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'gestorlog.db'),
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${ParametroModel.tblNome} (
        ${ParametroModel.colId}           INTEGER PRIMARY KEY,
        ${ParametroModel.colIdCads}       INTEGER NOT NULL DEFAULT 1,
        ${ParametroModel.colIdPda}        INTEGER NOT NULL DEFAULT 0,
        ${ParametroModel.colIdFilial}     INTEGER NOT NULL DEFAULT 1,
        ${ParametroModel.colIdInventario} INTEGER NOT NULL DEFAULT 0,
        ${ParametroModel.colUrl}          TEXT    NOT NULL DEFAULT '',
        ${ParametroModel.colDecPreco}     INTEGER NOT NULL DEFAULT 2,
        ${ParametroModel.colDecQtde}      INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await _createConferenciaTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE ${ParametroModel.tblNome}
        ADD COLUMN ${ParametroModel.colIdInventario} INTEGER NOT NULL DEFAULT 0
      ''');
      await db.execute('DROP TABLE IF EXISTS ${SeparacaoModel.tblNome}');
      await _createConferenciaTable(db);
    }
  }

  Future<void> _createConferenciaTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${SeparacaoModel.tblNome} (
        ${SeparacaoModel.colLoja}      INTEGER NOT NULL DEFAULT 0,
        ${SeparacaoModel.colNumero}    INTEGER NOT NULL DEFAULT 0,
        ${SeparacaoModel.colOrdem}     INTEGER NOT NULL DEFAULT 0,
        ${SeparacaoModel.colIdProduto} INTEGER NOT NULL DEFAULT 0,
        ${SeparacaoModel.colQtde}      REAL    NOT NULL DEFAULT 0,
        PRIMARY KEY (
          ${SeparacaoModel.colLoja},
          ${SeparacaoModel.colNumero},
          ${SeparacaoModel.colOrdem},
          ${SeparacaoModel.colIdProduto}
        )
      )
    ''');
  }
}
