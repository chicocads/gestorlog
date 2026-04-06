class ColaboradorModel {
  static const tblNome = 'colaborador';

  static const colId = 'codigo';
  static const colNome = 'nome';
  static const colFone = 'fone';
  static const colFone2 = 'fone2';
  static const colCelular = 'celular';
  static const colEmail = 'email';
  static const colSituacao = 'situacao';
  static const colTipo = 'tipo';
  static const colAdmis = 'adimissao';
  static const colNasc = 'nascimento';
  static const colEquipe = 'equipe';
  static const colIdForne = 'idfornecedor';
  static const colIdProduto = 'idproduto';
  static const colIdFrota = 'idfrota';

  ColaboradorModel({
    required this.codigo,
    required this.nome,
    required this.fone,
    required this.fone2,
    required this.celular,
    required this.email,
    required this.situacao,
    required this.tipo,
    required this.adimissao,
    required this.nascimento,
    required this.equipe,
    required this.idFornecedor,
    required this.idProduto,
    required this.idFrota,
  });

  // chave primária
  final int codigo;

  // dados cadastrais
  final String nome;
  final String fone;
  final String fone2;
  final String celular;
  final String email;
  final String adimissao;
  final String nascimento;

  // classificação
  final int situacao;
  final int tipo;
  final int equipe;

  // vínculos
  final int idFornecedor;
  final int idProduto;
  final int idFrota;

  factory ColaboradorModel.empty() => ColaboradorModel(
    codigo: 0,
    nome: '',
    fone: '',
    fone2: '',
    celular: '',
    email: '',
    situacao: 1,
    tipo: 0,
    adimissao: '',
    nascimento: '',
    equipe: 0,
    idFornecedor: 0,
    idProduto: 0,
    idFrota: 0,
  );

  ColaboradorModel copyWith({
    int? codigo,
    String? nome,
    String? fone,
    String? fone2,
    String? celular,
    String? email,
    int? situacao,
    int? tipo,
    String? adimissao,
    String? nascimento,
    int? equipe,
    int? idFornecedor,
    int? idProduto,
    int? idFrota,
  }) {
    return ColaboradorModel(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      fone: fone ?? this.fone,
      fone2: fone2 ?? this.fone2,
      celular: celular ?? this.celular,
      email: email ?? this.email,
      situacao: situacao ?? this.situacao,
      tipo: tipo ?? this.tipo,
      adimissao: adimissao ?? this.adimissao,
      nascimento: nascimento ?? this.nascimento,
      equipe: equipe ?? this.equipe,
      idFornecedor: idFornecedor ?? this.idFornecedor,
      idProduto: idProduto ?? this.idProduto,
      idFrota: idFrota ?? this.idFrota,
    );
  }

  factory ColaboradorModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ColaboradorModel.empty();
    return ColaboradorModel(
      codigo: map[colId] as int? ?? 0,
      nome: map[colNome] as String? ?? '',
      fone: map[colFone] as String? ?? '',
      fone2: map[colFone2] as String? ?? '',
      celular: map[colCelular] as String? ?? '',
      email: map[colEmail] as String? ?? '',
      situacao: map[colSituacao] as int? ?? 1,
      tipo: map[colTipo] as int? ?? 0,
      adimissao: map[colAdmis] as String? ?? '',
      nascimento: map[colNasc] as String? ?? '',
      equipe: map[colEquipe] as int? ?? 0,
      idFornecedor: map[colIdForne] as int? ?? 0,
      idProduto: map[colIdProduto] as int? ?? 0,
      idFrota: map[colIdFrota] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colId: codigo,
    colNome: nome,
    colFone: fone,
    colFone2: fone2,
    colCelular: celular,
    colEmail: email,
    colSituacao: situacao,
    colTipo: tipo,
    colAdmis: adimissao,
    colNasc: nascimento,
    colEquipe: equipe,
    colIdForne: idFornecedor,
    colIdProduto: idProduto,
    colIdFrota: idFrota,
  };

  @override
  String toString() =>
      'ColaboradorModel(codigo: $codigo, nome: $nome, situacao: $situacao)';
}
