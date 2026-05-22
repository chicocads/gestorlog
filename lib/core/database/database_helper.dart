import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/Separacao/separacao_model.dart';
import '../../models/cadastro/produto_model.dart';
import '../../models/cadastro/usuario2_model.dart';
import '../../models/cadastro/usuario_model.dart';
import '../../models/hsaida/lote_saida_model.dart';
import '../../models/parametros/parametro_model.dart';
import '../../models/inventario/inventario_model.dart';

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
      version: 10,
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
    await _createUsuarioTable(db);
    await _createUsuario2Table(db);
    await _createProdutoTable(db);
    await _createInventarioTable(db);
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
    if (oldVersion < 8) {
      if (!await _tableExists(db, InventarioModel.tblNome)) {
        await _createInventarioTable(db);
      }
    }
    if (oldVersion < 9) {
      if (!await _tableExists(db, InventarioModel.tblNome)) {
        await _createInventarioTable(db);
      }
      await _addColumnIfMissing(
        db,
        table: InventarioModel.tblNome,
        column: InventarioModel.colPecas,
        definition: 'INTEGER NOT NULL DEFAULT 0',
      );
    }
    if (oldVersion < 10) {
      if (!await _tableExists(db, ProdutoModel.tblNome)) {
        await _createProdutoTable(db);
      }
      await _addColumnIfMissing(
        db,
        table: ProdutoModel.tblNome,
        column: ProdutoModel.colWmsmod2,
        definition: 'INTEGER NOT NULL DEFAULT 0',
      );
      await _addColumnIfMissing(
        db,
        table: ProdutoModel.tblNome,
        column: ProdutoModel.colWmsrua2,
        definition: 'INTEGER NOT NULL DEFAULT 0',
      );
      await _addColumnIfMissing(
        db,
        table: ProdutoModel.tblNome,
        column: ProdutoModel.colWmsblc2,
        definition: 'INTEGER NOT NULL DEFAULT 0',
      );
      await _addColumnIfMissing(
        db,
        table: ProdutoModel.tblNome,
        column: ProdutoModel.colWmsniv2,
        definition: 'INTEGER NOT NULL DEFAULT 0',
      );
      await _addColumnIfMissing(
        db,
        table: ProdutoModel.tblNome,
        column: ProdutoModel.colWmsapt2,
        definition: 'INTEGER NOT NULL DEFAULT 0',
      );
      await _addColumnIfMissing(
        db,
        table: ProdutoModel.tblNome,
        column: ProdutoModel.colWmsgvt2,
        definition: 'INTEGER NOT NULL DEFAULT 0',
      );
    }
  }

  Future<void> _createUsuarioTable(Database db) async {
    if (!await _tableExists(db, UsuarioModel.tblNome)) {
      await db.execute('''
      CREATE TABLE ${UsuarioModel.tblNome} (
        ${UsuarioModel.colId}          INTEGER PRIMARY KEY,
        ${UsuarioModel.colLogin}       TEXT    NOT NULL DEFAULT '',
        ${UsuarioModel.colSenha}       TEXT    NOT NULL DEFAULT '',
        ${UsuarioModel.colEmail}       TEXT    NOT NULL DEFAULT '',
        ${UsuarioModel.colTipo}        INTEGER NOT NULL DEFAULT 1,
        ${UsuarioModel.colAvatar}      TEXT    NOT NULL DEFAULT '',
        ${UsuarioModel.colValidade}    TEXT    NOT NULL DEFAULT '',
        ${UsuarioModel.colIdFilial}    INTEGER NOT NULL DEFAULT 0,
        ${UsuarioModel.colIdFuncion}   INTEGER NOT NULL DEFAULT 0,
        ${UsuarioModel.colDscMax}      REAL    NOT NULL DEFAULT 0,
        usu_flag01                     INTEGER NOT NULL DEFAULT 0,
        usu_flag02                     INTEGER NOT NULL DEFAULT 0,
        usu_flag03                     INTEGER NOT NULL DEFAULT 0,
        usu_flag04                     INTEGER NOT NULL DEFAULT 0,
        usu_flag05                     INTEGER NOT NULL DEFAULT 0,
        usu_flag06                     INTEGER NOT NULL DEFAULT 0,
        usu_flag07                     INTEGER NOT NULL DEFAULT 0,
        usu_flag08                     INTEGER NOT NULL DEFAULT 0,
        usu_flag09                     INTEGER NOT NULL DEFAULT 0,
        usu_flag10                     INTEGER NOT NULL DEFAULT 0,
        usu_flag11                     INTEGER NOT NULL DEFAULT 0,
        usu_flag12                     INTEGER NOT NULL DEFAULT 0,
        usu_flag13                     INTEGER NOT NULL DEFAULT 0,
        usu_flag14                     INTEGER NOT NULL DEFAULT 0,
        usu_flag15                     INTEGER NOT NULL DEFAULT 0,
        usu_flag16                     INTEGER NOT NULL DEFAULT 0,
        usu_flag17                     INTEGER NOT NULL DEFAULT 0,
        usu_flag18                     INTEGER NOT NULL DEFAULT 0,
        usu_flag19                     INTEGER NOT NULL DEFAULT 0,
        usu_flag20                     INTEGER NOT NULL DEFAULT 0,
        usu_flag21                     INTEGER NOT NULL DEFAULT 0,
        usu_flag22                     INTEGER NOT NULL DEFAULT 0,
        usu_flag23                     INTEGER NOT NULL DEFAULT 0,
        usu_flag24                     INTEGER NOT NULL DEFAULT 0,
        usu_flag25                     INTEGER NOT NULL DEFAULT 0,
        usu_flag26                     INTEGER NOT NULL DEFAULT 0,
        usu_flag27                     INTEGER NOT NULL DEFAULT 0,
        usu_flag28                     INTEGER NOT NULL DEFAULT 0,
        usu_flag29                     INTEGER NOT NULL DEFAULT 0,
        usu_flag30                     INTEGER NOT NULL DEFAULT 0
      )
    ''');
    }
  }

  Future<void> _createUsuario2Table(Database db) async {
    if (!await _tableExists(db, Usuario2Model.tblNome)) {
      await db.execute('''
      CREATE TABLE ${Usuario2Model.tblNome} (
        ${Usuario2Model.colIdSistema}    INTEGER NOT NULL DEFAULT 0,
        ${Usuario2Model.colIdUsuario}    INTEGER NOT NULL DEFAULT 0,
        ${Usuario2Model.colIdMenu}       INTEGER NOT NULL DEFAULT 0,
        ${Usuario2Model.colOrdem}        INTEGER NOT NULL DEFAULT 0,
        ${Usuario2Model.colNivel}        INTEGER NOT NULL DEFAULT 0,
        ${Usuario2Model.colMaster}       INTEGER NOT NULL DEFAULT 0,
        ${Usuario2Model.colAcesso}       INTEGER NOT NULL DEFAULT 0,
        ${Usuario2Model.colIncluir}      INTEGER NOT NULL DEFAULT 0,
        ${Usuario2Model.colAlterar}      INTEGER NOT NULL DEFAULT 0,
        ${Usuario2Model.colExcluir}      INTEGER NOT NULL DEFAULT 0,
        ${Usuario2Model.colImprimir}     INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (
          ${Usuario2Model.colIdSistema},
          ${Usuario2Model.colIdUsuario},
          ${Usuario2Model.colIdMenu}
        )
      )
    ''');
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
        ${ProdutoModel.colWmsmod2}        INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colWmsrua2}        INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colWmsblc2}        INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colWmsniv2}         INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colWmsapt2}        INTEGER NOT NULL DEFAULT 0,
        ${ProdutoModel.colWmsgvt2}        INTEGER NOT NULL DEFAULT 0,
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

  Future<void> _createInventarioTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${InventarioModel.tblNome} (
        ${InventarioModel.colId}       INTEGER PRIMARY KEY AUTOINCREMENT,
        ${InventarioModel.colProduto}  INTEGER NOT NULL DEFAULT 0,
        ${InventarioModel.colBarra}    TEXT    NOT NULL DEFAULT '',
        ${InventarioModel.colPecas}    INTEGER NOT NULL DEFAULT 0,
        ${InventarioModel.colQtde}     REAL    NOT NULL DEFAULT 0,
        ${InventarioModel.colLote}     TEXT    NOT NULL DEFAULT '',
        ${InventarioModel.colValidade} TEXT    NOT NULL DEFAULT '',
        ${InventarioModel.colNomePro}  TEXT    NOT NULL DEFAULT ''
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
