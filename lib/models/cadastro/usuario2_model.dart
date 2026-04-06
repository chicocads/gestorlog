class Usuario2Model {
  static const tblNome = 'usuario2';
  static const colIdSistema = 'idsistema';
  static const colIdUsuario = 'idusuario';
  static const colIdMenu = 'idmenu';
  static const colOrdem = 'ordem';
  static const colNivel = 'nivel';
  static const colMaster = 'master';
  static const colAcesso = 'acesso';
  static const colIncluir = 'incluir';
  static const colAlterar = 'alterar';
  static const colExcluir = 'excluir';
  static const colImprimir = 'imprimir';

  Usuario2Model({
    required this.idsistema,
    required this.idusuario,
    required this.idmenu,
    required this.ordem,
    required this.nivel,
    required this.master,
    required this.acesso,
    required this.incluir,
    required this.alterar,
    required this.excluir,
    required this.imprimir,
  });

  final int idsistema;
  final int idusuario;
  final int idmenu;
  final int ordem;
  final int nivel;
  final int master;
  final int acesso;
  final int incluir;
  final int alterar;
  final int excluir;
  final int imprimir;

  factory Usuario2Model.empty() => Usuario2Model(
    idsistema: 0,
    idusuario: 0,
    idmenu: 0,
    ordem: 0,
    nivel: 0,
    master: 0,
    acesso: 0,
    incluir: 0,
    alterar: 0,
    excluir: 0,
    imprimir: 0,
  );

  Usuario2Model copyWith({
    int? idsistema,
    int? idusuario,
    int? idmenu,
    int? ordem,
    int? nivel,
    int? master,
    int? acesso,
    int? incluir,
    int? alterar,
    int? excluir,
    int? imprimir,
  }) {
    return Usuario2Model(
      idsistema: idsistema ?? this.idsistema,
      idusuario: idusuario ?? this.idusuario,
      idmenu: idmenu ?? this.idmenu,
      ordem: ordem ?? this.ordem,
      nivel: nivel ?? this.nivel,
      master: master ?? this.master,
      acesso: acesso ?? this.acesso,
      incluir: incluir ?? this.incluir,
      alterar: alterar ?? this.alterar,
      excluir: excluir ?? this.excluir,
      imprimir: imprimir ?? this.imprimir,
    );
  }

  factory Usuario2Model.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return Usuario2Model.empty();
    return Usuario2Model(
      idsistema: map[colIdSistema] as int? ?? 0,
      idusuario: map[colIdUsuario] as int? ?? 0,
      idmenu: map[colIdMenu] as int? ?? 0,
      ordem: map[colOrdem] as int? ?? 0,
      nivel: map[colNivel] as int? ?? 0,
      master: map[colMaster] as int? ?? 0,
      acesso: map[colAcesso] as int? ?? 0,
      incluir: map[colIncluir] as int? ?? 0,
      alterar: map[colAlterar] as int? ?? 0,
      excluir: map[colExcluir] as int? ?? 0,
      imprimir: map[colImprimir] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colIdSistema: idsistema,
    colIdUsuario: idusuario,
    colIdMenu: idmenu,
    colOrdem: ordem,
    colNivel: nivel,
    colMaster: master,
    colAcesso: acesso,
    colIncluir: incluir,
    colAlterar: alterar,
    colExcluir: excluir,
    colImprimir: imprimir,
  };
}
