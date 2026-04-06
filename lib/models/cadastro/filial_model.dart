class FilialModel {
  static const tblNome = 'filial';
  static const colCodigo = 'codigo';
  static const colNome = 'nome';
  static const colFantasia = 'fantasia';
  static const colEndereco = 'endereco';
  static const colBairro = 'bairro';
  static const colCidade = 'cidade';
  static const colUf = 'uf';
  static const colCep = 'cep';
  static const colFone = 'fone';
  static const colEmail = 'email';
  static const colCnpj = 'cnpj';
  static const colIe = 'ie';

  FilialModel({
    required this.codigo,
    required this.nome,
    required this.fantasia,
    required this.endereco,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.cep,
    required this.fone,
    required this.email,
    required this.cnpj,
    required this.ie,
  });

  final int codigo;
  final String nome;
  final String fantasia;
  final String endereco;
  final String bairro;
  final String cidade;
  final String uf;
  final String cep;
  final String fone;
  final String email;
  final String cnpj;
  final String ie;

  factory FilialModel.empty() => FilialModel(
    codigo: 0,
    nome: '',
    fantasia: '',
    endereco: '',
    bairro: '',
    cidade: '',
    uf: '',
    cep: '',
    fone: '',
    email: '',
    cnpj: '',
    ie: '',
  );

  FilialModel copyWith({
    int? codigo,
    String? nome,
    String? fantasia,
    String? endereco,
    String? bairro,
    String? cidade,
    String? uf,
    String? cep,
    String? fone,
    String? email,
    String? cnpj,
    String? ie,
  }) {
    return FilialModel(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      fantasia: fantasia ?? this.fantasia,
      endereco: endereco ?? this.endereco,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      uf: uf ?? this.uf,
      cep: cep ?? this.cep,
      fone: fone ?? this.fone,
      email: email ?? this.email,
      cnpj: cnpj ?? this.cnpj,
      ie: ie ?? this.ie,
    );
  }

  factory FilialModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return FilialModel.empty();
    return FilialModel(
      codigo: map[colCodigo] as int? ?? 0,
      nome: map[colNome] as String? ?? '',
      fantasia: map[colFantasia] as String? ?? '',
      endereco: map[colEndereco] as String? ?? '',
      bairro: map[colBairro] as String? ?? '',
      cidade: map[colCidade] as String? ?? '',
      uf: map[colUf] as String? ?? '',
      cep: map[colCep] as String? ?? '',
      fone: map[colFone] as String? ?? '',
      email: map[colEmail] as String? ?? '',
      cnpj: map[colCnpj] as String? ?? '',
      ie: map[colIe] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    colCodigo: codigo,
    colNome: nome,
    colFantasia: fantasia,
    colEndereco: endereco,
    colBairro: bairro,
    colCidade: cidade,
    colUf: uf,
    colCep: cep,
    colFone: fone,
    colEmail: email,
    colCnpj: cnpj,
    colIe: ie,
  };

  @override
  String toString() =>
      'FilialModel(codigo: $codigo, nome: $nome, cidade: $cidade, uf: $uf)';
}
