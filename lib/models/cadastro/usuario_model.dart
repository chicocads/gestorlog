import 'usuario2_model.dart';

class UsuarioModel {
  static const tblNome = 'usuario';
  static const colId = 'id';
  static const colLogin = 'login';
  static const colSenha = 'senha';
  static const colEmail = 'email';
  static const colTipo = 'tipo';
  static const colAvatar = 'avatar';
  static const colValidade = 'validade';
  static const colIdFilial = 'idfilial';
  static const colIdFuncion = 'idfuncionario';
  static const colDscMax = 'dscmax';

  UsuarioModel({
    required this.id,
    required this.login,
    required this.senha,
    required this.email,
    required this.tipo,
    required this.avatar,
    required this.validade,
    required this.idfilial,
    required this.idfuncionario,
    required this.dscmax,
    required this.flags,
    required this.usuario2,
  });

  final int id;
  final String login;
  final String senha;
  final String email;
  final int tipo;
  final String avatar;
  final String validade;
  final int idfilial;
  final int idfuncionario;
  final double dscmax;
  final List<int> flags;
  final List<Usuario2Model> usuario2;

  factory UsuarioModel.empty() => UsuarioModel(
    id: 0,
    login: '',
    senha: '',
    email: '',
    tipo: 1,
    avatar: '',
    validade: '',
    idfilial: 0,
    idfuncionario: 0,
    dscmax: 0,
    flags: List.filled(30, 0),
    usuario2: const [],
  );

  UsuarioModel copyWith({
    int? id,
    String? login,
    String? senha,
    String? email,
    int? tipo,
    String? avatar,
    String? validade,
    int? idfilial,
    int? idfuncionario,
    double? dscmax,
    List<int>? flags,
    List<Usuario2Model>? usuario2,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      login: login ?? this.login,
      senha: senha ?? this.senha,
      email: email ?? this.email,
      tipo: tipo ?? this.tipo,
      avatar: avatar ?? this.avatar,
      validade: validade ?? this.validade,
      idfilial: idfilial ?? this.idfilial,
      idfuncionario: idfuncionario ?? this.idfuncionario,
      dscmax: dscmax ?? this.dscmax,
      flags: flags ?? List.of(this.flags),
      usuario2: usuario2 ?? List.of(this.usuario2),
    );
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return UsuarioModel.empty();
    return UsuarioModel(
      id: map[colId] as int? ?? 0,
      login: map[colLogin] as String? ?? '',
      senha: map[colSenha] as String? ?? '',
      email: map[colEmail] as String? ?? '',
      tipo: map[colTipo] as int? ?? 1,
      avatar: map[colAvatar] as String? ?? '',
      validade: map[colValidade] as String? ?? '',
      idfilial: map[colIdFilial] as int? ?? 0,
      idfuncionario: map[colIdFuncion] as int? ?? 0,
      dscmax: (map[colDscMax] as num?)?.toDouble() ?? 0,
      flags: List.generate(30, (i) {
        final key = 'usu_flag${(i + 1).toString().padLeft(2, '0')}';
        return map[key] as int? ?? 0;
      }),
      usuario2: (map['usuario2'] as List<dynamic>? ?? [])
          .map((e) => Usuario2Model.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      colId: id,
      colLogin: login,
      colSenha: senha,
      colEmail: email,
      colTipo: tipo,
      colAvatar: avatar,
      colValidade: validade,
      colIdFilial: idfilial,
      colIdFuncion: idfuncionario,
      colDscMax: dscmax,
    };
    for (int i = 0; i < flags.length; i++) {
      final key = 'usu_flag${(i + 1).toString().padLeft(2, '0')}';
      map[key] = flags[i];
    }
    map['usuario2'] = usuario2.map((e) => e.toMap()).toList();
    return map;
  }

  @override
  String toString() =>
      'UsuarioModel(id: $id, login: $login, tipo: $tipo, idfilial: $idfilial)';
}
