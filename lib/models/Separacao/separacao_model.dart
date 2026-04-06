class SeparacaoModel {
  static const tblNome = 'Conferencia';
  static const colLoja = 'loja';
  static const colNumero = 'numero';
  static const colOrdem = 'ordem';
  static const colIdProduto = 'idproduto';
  static const colQtde = 'qtde';

  SeparacaoModel({
    required this.loja,
    required this.numero,
    required this.ordem,
    required this.idproduto,
    required this.qtde,
  });

  // chave primária
  final int loja;
  final int numero;
  final int ordem;
  final int idproduto;

  // dados
  final double qtde;

  factory SeparacaoModel.empty() =>
      SeparacaoModel(loja: 0, numero: 0, ordem: 0, idproduto: 0, qtde: 0);

  SeparacaoModel copyWith({
    int? loja,
    int? numero,
    int? ordem,
    int? idproduto,
    double? qtde,
  }) {
    return SeparacaoModel(
      loja: loja ?? this.loja,
      numero: numero ?? this.numero,
      ordem: ordem ?? this.ordem,
      idproduto: idproduto ?? this.idproduto,
      qtde: qtde ?? this.qtde,
    );
  }

  factory SeparacaoModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return SeparacaoModel.empty();
    return SeparacaoModel(
      loja: map[colLoja] ?? 0,
      numero: map[colNumero] ?? 0,
      ordem: map[colOrdem] ?? 0,
      idproduto: map[colIdProduto] ?? 0,
      qtde: (map[colQtde] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() => {
    colLoja: loja,
    colNumero: numero,
    colOrdem: ordem,
    colIdProduto: idproduto,
    colQtde: qtde,
  };

  @override
  String toString() =>
      'ConferenciaModel(loja: $loja, numero: $numero, idproduto: $idproduto, qtde: $qtde)';
}
