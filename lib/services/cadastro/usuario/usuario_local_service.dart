import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../../models/cadastro/usuario2_model.dart';
import '../../../models/cadastro/usuario_model.dart';

class UsuarioLocalService {
  final _db = DatabaseHelper.instance;

  Future<void> salvar(UsuarioModel usuario) async {
    if (usuario.id <= 0) return;

    final database = await _db.db;
    final usuarioMap = Map<String, dynamic>.from(usuario.toMap())
      ..remove('usuario2');

    await database.transaction((txn) async {
      await txn.insert(
        UsuarioModel.tblNome,
        usuarioMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await txn.delete(
        Usuario2Model.tblNome,
        where: '${Usuario2Model.colIdUsuario} = ?',
        whereArgs: [usuario.id],
      );

      if (usuario.usuario2.isEmpty) return;

      final batch = txn.batch();
      for (final permissao in usuario.usuario2) {
        batch.insert(
          Usuario2Model.tblNome,
          permissao.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<UsuarioModel?> buscarPorCredenciais({
    required String login,
    required String senha,
  }) async {
    final database = await _db.db;
    final rows = await database.query(
      UsuarioModel.tblNome,
      where: '${UsuarioModel.colLogin} = ? AND ${UsuarioModel.colSenha} = ?',
      whereArgs: [login.trim().toUpperCase(), senha.toUpperCase().trim()],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final usuario = UsuarioModel.fromMap(rows.first);
    final permissoes = await _listarPermissoes(usuario.id);
    return usuario.copyWith(usuario2: permissoes);
  }

  Future<List<Usuario2Model>> _listarPermissoes(int idUsuario) async {
    final database = await _db.db;
    final rows = await database.query(
      Usuario2Model.tblNome,
      where: '${Usuario2Model.colIdUsuario} = ?',
      whereArgs: [idUsuario],
      orderBy:
          '${Usuario2Model.colIdSistema}, ${Usuario2Model.colOrdem}, ${Usuario2Model.colIdMenu}',
    );
    return rows.map(Usuario2Model.fromMap).toList();
  }
}
