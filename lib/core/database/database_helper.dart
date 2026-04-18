import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/Separacao/separacao_model.dart';
import '../../models/cadastro/produto_model.dart';
import '../../models/diversos/lote_saida_model.dart';
import '../../models/diversos/parametro_model.dart';

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
      version: 7,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${ParametroModel.tblNome} (
        ${ParametroModel.colId}           INTEGER PRIMARY KEY,
        ${ParametroModel.colIdCads}       INTEGER NOT NULL DEFAULT 1,
        ${ParametroModel.colIdFilial}     INTEGER NOT NULL DEFAULT 1,
        ${ParametroModel.colIdPda}        INTEGER NOT NULL DEFAULT 0,
        ${ParametroModel.colIdFrota}      INTEGER NOT NULL DEFAULT 0,
        ${ParametroModel.colIdInventario} INTEGER NOT NULL DEFAULT 0,
        ${ParametroModel.colUrl}          TEXT    NOT NULL DEFAULT '',
        ${ParametroModel.colDecPreco}     INTEGER NOT NULL DEFAULT 2,
        ${ParametroModel.colDecQtde}      INTEGER NOT NULL DEFAULT 0,
        ${ParametroModel.colControlePecas} INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await _createProdutoTable(db);
    await _createSeparacaoTable(db);
    await _createLoteSaidaTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE ${ParametroModel.tblNome}
        ADD COLUMN ${ParametroModel.colIdInventario} INTEGER NOT NULL DEFAULT 0
      ''');
      await db.execute('DROP TABLE IF EXISTS ${SeparacaoModel.tblNome}');
      await _createSeparacaoTable(db);
    }
    if (oldVersion < 3) {
      await _createLoteSaidaTable(db);
    }
    if (oldVersion < 4) {
      await db.execute('''
        ALTER TABLE ${ParametroModel.tblNome}
        ADD COLUMN ${ParametroModel.colIdFrota} INTEGER NOT NULL DEFAULT 0
      ''');
    }
    if (oldVersion < 5) {
      if (await _tableExists(db, 'Conferencia') &&
          !await _tableExists(db, SeparacaoModel.tblNome)) {
        await db.execute(
          'ALTER TABLE Conferencia RENAME TO ${SeparacaoModel.tblNome}',
        );
      }
      await _addColumnIfMissing(
        db,
        table: ParametroModel.tblNome,
        column: ParametroModel.colControlePecas,
        definition: 'INTEGER NOT NULL DEFAULT 0',
      );
      await _addColumnIfMissing(
        db,
        table: SeparacaoModel.tblNome,
        column: SeparacaoModel.colPecas,
        definition: 'INTEGER NOT NULL DEFAULT 0',
      );
    }
    if (oldVersion < 6) {
      if (!await _tableExists(db, SeparacaoModel.tblNome)) {
        await _createSeparacaoTable(db);
      }
      if (!await _tableExists(db, LoteSaidaModel.tblNome)) {
        await _createLoteSaidaTable(db);
      }
      await _addColumnIfMissing(
        db,
        table: ParametroModel.tblNome,
        column: ParametroModel.colControlePecas,
        definition: 'INTEGER NOT NULL DEFAULT 0',
      );
      await _addColumnIfMissing(
        db,
        table: SeparacaoModel.tblNome,
        column: SeparacaoModel.colPecas,
        definition: 'INTEGER NOT NULL DEFAULT 0',
      );
    }
    if (oldVersion < 7) {
      if (!await _tableExists(db, ProdutoModel.tblNome)) {
        await _createProdutoTable(db);
      }
    }
  }

  Future<void> _createProdutoTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${ProdutoModel.tblNome} (
        ${ProdutoModel.colCodigo}         INTEGER PRIMARY KEY,
        ${ProdutoModel.colCodigoAlfa}     TEXT    NOT NULL DEFAULT '',
        ${ProdutoModel.colDun14}          TEXT    NOT NULL DEFAULT '',
        ${ProdutoModel.colNome}           TEXT    NOT NULL DEFAULT '',
        ${ProdutoModel.colUnd}            TEXT    NOT NULL DEFAULT '',
        ${ProdutoModel.colLocaliza}       TEXT    NOT NULL DEFAULT '',
        ${ProdutoModel.colWmsmod}         INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colWmsrua}         INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colWmsblc}         INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colWmsniv}         INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colWmsapt}         INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colWmsgvt}         INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colSecao}          INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colGrupo}          INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colSgrupo}         INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colFornecedor}     INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colPrecoVenda}     REAL    NOT NULL DEFAULT 0,
        ${ProdutoModel.colPrecoVenda2}    REAL    NOT NULL DEFAULT 0,
        ${ProdutoModel.colPrecoVenda3}    REAL    NOT NULL DEFAULT 0,
        ${ProdutoModel.colPrecoVenda4}    REAL    NOT NULL DEFAULT 0,
        ${ProdutoModel.colPrecoVenda5}    REAL    NOT NULL DEFAULT 0,
        ${ProdutoModel.colPrecoVenda6}    REAL    NOT NULL DEFAULT 0,
        ${ProdutoModel.colPrecoVenda7}    REAL    NOT NULL DEFAULT 0,
        ${ProdutoModel.colDescv}          REAL    NOT NULL DEFAULT 0,
        ${ProdutoModel.colSaldo}          REAL    NOT NULL DEFAULT 0,
        ${ProdutoModel.colReserva}        REAL    NOT NULL DEFAULT 0,
        ${ProdutoModel.colFator}          REAL    NOT NULL DEFAULT 1,
        ${ProdutoModel.colQtEmbala}       INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colQtAtacado}      REAL    NOT NULL DEFAULT 0,
        ${ProdutoModel.colPesoVariavel}   INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colMarca}          TEXT    NOT NULL DEFAULT '',
        ${ProdutoModel.colRefer}          TEXT    NOT NULL DEFAULT '',
        ${ProdutoModel.colCaracter}       TEXT    NOT NULL DEFAULT '',
        ${ProdutoModel.colConsumo}        INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colSituacao}       INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colTabWeb}         INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colCst}            TEXT    NOT NULL DEFAULT '',
        ${ProdutoModel.colControleLote}   INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colImagem}         TEXT    NOT NULL DEFAULT ''
      )
    ''');
  }

  Future<void> _createSeparacaoTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${SeparacaoModel.tblNome} (
        ${SeparacaoModel.colLoja}      INTEGER NOT NULL DEFAULT 0,
        ${SeparacaoModel.colNumero}    INTEGER NOT NULL DEFAULT 0,
        ${SeparacaoModel.colOrdem}     INTEGER NOT NULL DEFAULT 0,
        ${SeparacaoModel.colIdProduto} INTEGER NOT NULL DEFAULT 0,
        ${SeparacaoModel.colQtde}      REAL    NOT NULL DEFAULT 0,
        ${SeparacaoModel.colPecas}     INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (
          ${SeparacaoModel.colLoja},
          ${SeparacaoModel.colNumero},
          ${SeparacaoModel.colOrdem},
          ${SeparacaoModel.colIdProduto}
        )
      )
    ''');
  }

  Future<void> _createLoteSaidaTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${LoteSaidaModel.tblNome} (
        ${LoteSaidaModel.colIdFilial}   INTEGER NOT NULL DEFAULT 0,
        ${LoteSaidaModel.colIdPrevenda} INTEGER NOT NULL DEFAULT 0,
        ${LoteSaidaModel.colIdProduto}  INTEGER NOT NULL DEFAULT 0,
        ${LoteSaidaModel.colLote}       TEXT    NOT NULL DEFAULT '',
        ${LoteSaidaModel.colValidade}   TEXT    NOT NULL DEFAULT '',
        ${LoteSaidaModel.colFabricacao} TEXT    NOT NULL DEFAULT '',
        ${LoteSaidaModel.colQtde}       REAL    NOT NULL DEFAULT 0,
        PRIMARY KEY (
          ${LoteSaidaModel.colIdFilial},
          ${LoteSaidaModel.colIdPrevenda},
          ${LoteSaidaModel.colIdProduto},
          ${LoteSaidaModel.colLote},
          ${LoteSaidaModel.colValidade}
        )
      )
    ''');
  }

  Future<void> _addColumnIfMissing(
    Database db, {
    required String table,
    required String column,
    required String definition,
  }) async {
    final columns = await db.rawQuery('PRAGMA table_info($table)');
    final exists = columns.any((col) => col['name'] == column);
    if (exists) return;
    await db.execute('ALTER TABLE $table ADD COLUMN $column $definition');
  }

  Future<bool> _tableExists(Database db, String table) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
      [table],
    );
    return result.isNotEmpty;
  }
}
