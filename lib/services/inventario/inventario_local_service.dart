import 'package:sqflite/sqflite.dart';

import '../../core/database/database_helper.dart';
import '../../models/cadastro/produto_model.dart';
import '../../models/inventario/inventario_model.dart';

class InventarioTotais {
  const InventarioTotais({required this.qtde, required this.pecas});

  final double qtde;
  final int pecas;
}

class InventarioResumo {
  const InventarioResumo({
    required this.itens,
    required this.qtde,
    required this.pecas,
  });

  final int itens;
  final double qtde;
  final int pecas;
}

class InventarioColetadoItem {
  const InventarioColetadoItem({
    required this.inventario,
    required this.nomeProduto,
    required this.produtoCadastrado,
  });

  final InventarioModel inventario;
  final String nomeProduto;
  final bool produtoCadastrado;
}

class InventarioLocalService {
  final _db = DatabaseHelper.instance;

  Future<InventarioResumo> buscarResumoGeral() async {
    final database = await _db.db;
    final rows = await database.rawQuery(
      '''
      SELECT
        COALESCE(SUM(${InventarioModel.colQtde}), 0) AS qtdeTotal,
        COALESCE(SUM(${InventarioModel.colPecas}), 0) AS pecasTotal,
        COUNT(*) AS itensTotal
      FROM ${InventarioModel.tblNome}
      ''',
    );

    if (rows.isEmpty) {
      return const InventarioResumo(itens: 0, qtde: 0, pecas: 0);
    }
    final row = rows.first;
    return InventarioResumo(
      itens: (row['itensTotal'] as num?)?.toInt() ?? 0,
      qtde: (row['qtdeTotal'] as num?)?.toDouble() ?? 0,
      pecas: (row['pecasTotal'] as num?)?.toInt() ?? 0,
    );
  }

  Future<void> excluirPorId(int id) async {
    final database = await _db.db;
    await database.delete(
      InventarioModel.tblNome,
      where: '${InventarioModel.colId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> gravarOuSomar(InventarioModel item) async {
    final database = await _db.db;
    final codigoBarra = item.codigoBarra.trim();
    final lote = item.lote.trim();
    final validade = item.validade.trim();
    final nomePro = item.nomePro.trim();

    final rows = await database.query(
      InventarioModel.tblNome,
      columns: [
        InventarioModel.colId,
        InventarioModel.colQtde,
        InventarioModel.colPecas,
      ],
      where:
          '${InventarioModel.colProduto} = ? AND ${InventarioModel.colBarra} = ? AND ${InventarioModel.colLote} = ? AND ${InventarioModel.colNomePro} = ?',
      whereArgs: [item.produto, codigoBarra, lote, nomePro],
      limit: 1,
    );

    if (rows.isEmpty) {
      final map = item
          .copyWith(
            codigoBarra: codigoBarra,
            lote: lote,
            validade: validade,
            nomePro: nomePro,
          )
          .toMap();
      map.remove(InventarioModel.colId);
      await database.insert(
        InventarioModel.tblNome,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return;
    }

    final id = rows.first[InventarioModel.colId] as int? ?? 0;
    final qtdeAtual =
        (rows.first[InventarioModel.colQtde] as num?)?.toDouble() ?? 0.0;
    final pecasAtual = rows.first[InventarioModel.colPecas] as int? ?? 0;
    final novaQtde = qtdeAtual + item.qtde;
    final novasPecas = pecasAtual + item.pecas;

    await database.update(
      InventarioModel.tblNome,
      {InventarioModel.colQtde: novaQtde, InventarioModel.colPecas: novasPecas},
      where: '${InventarioModel.colId} = ?',
      whereArgs: [id],
    );
  }

  Future<List<InventarioModel>> listar({int limit = 200}) async {
    final database = await _db.db;
    final rows = await database.query(
      InventarioModel.tblNome,
      orderBy: '${InventarioModel.colId} DESC',
      limit: limit,
    );
    return rows.map(InventarioModel.fromMap).toList();
  }

  Future<List<InventarioColetadoItem>> listarColetadosComNome({
    int limit = 500,
    int offset = 0,
  }) async {
    final database = await _db.db;
    final rows = await database.rawQuery(
      '''
      SELECT i.*, p.${ProdutoModel.colNome} AS nomeProdutoCadastro
      FROM ${InventarioModel.tblNome} i
      LEFT JOIN ${ProdutoModel.tblNome} p
        ON p.${ProdutoModel.colCodigo} = i.${InventarioModel.colProduto}
      ORDER BY i.${InventarioModel.colId} DESC
      LIMIT ?
      OFFSET ?
      ''',
      [limit, offset],
    );

    return rows.map((row) {
      final inventario = InventarioModel.fromMap(row);
      final nomeCadastro = (row['nomeProdutoCadastro'] ?? '').toString().trim();
      return InventarioColetadoItem(
        inventario: inventario,
        nomeProduto: nomeCadastro.isNotEmpty ? nomeCadastro : inventario.nomePro,
        produtoCadastrado: nomeCadastro.isNotEmpty,
      );
    }).toList();
  }

  Future<InventarioTotais> buscarTotaisPorProdutoELote({
    required int produto,
    required String lote,
  }) async {
    final database = await _db.db;
    final loteLimpo = lote.trim();
    final rows = await database.rawQuery(
      '''
      SELECT
        COALESCE(SUM(${InventarioModel.colQtde}), 0) AS qtdeTotal,
        COALESCE(SUM(${InventarioModel.colPecas}), 0) AS pecasTotal
      FROM ${InventarioModel.tblNome}
      WHERE ${InventarioModel.colProduto} = ?
        AND ${InventarioModel.colLote} = ?
      ''',
      [produto, loteLimpo],
    );

    if (rows.isEmpty) {
      return const InventarioTotais(qtde: 0, pecas: 0);
    }
    final row = rows.first;
    return InventarioTotais(
      qtde: (row['qtdeTotal'] as num?)?.toDouble() ?? 0,
      pecas: (row['pecasTotal'] as num?)?.toInt() ?? 0,
    );
  }

  Future<void> limpar() async {
    final database = await _db.db;
    await database.delete(InventarioModel.tblNome);
  }
}
