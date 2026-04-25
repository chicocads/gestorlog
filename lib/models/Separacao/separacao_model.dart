class SeparacaoModel {
  static const tblNome = 'Separacao';
  static const colLoja = 'idfilial';
  static const colNumero = 'idprevenda';
  static const colOrdem = 'ordem';
  static const colIdProduto = 'idproduto';
  static const colQtde = 'qtde';
  static const colPecas = 'pecas';

  SeparacaoModel({
    required this.idFilial,
    required this.idPrevenda,
    required this.ordem,
    required this.idProduto,
    required this.qtde,
    required this.pecas,
  });

  // chave primária
  final int idFilial;
  final int idPrevenda;
  final int ordem;
  final int idProduto;

  // dados
  final double qtde;
  final int pecas;

  factory SeparacaoModel.empty() => SeparacaoModel(
    idFilial: 0,
    idPrevenda: 0,
    ordem: 0,
    idProduto: 0,
    qtde: 0,
    pecas: 0,
  );

  SeparacaoModel copyWith({
    int? idFilial,
    int? idPrevenda,
    int? ordem,
    int? idProduto,
    double? qtde,
    int? pecas,
  }) {
    return SeparacaoModel(
      idFilial: idFilial ?? this.idFilial,
      idPrevenda: idPrevenda ?? this.idPrevenda,
      ordem: ordem ?? this.ordem,
      idProduto: idProduto ?? this.idProduto,
      qtde: qtde ?? this.qtde,
      pecas: pecas ?? this.pecas,
    );
  }

  factory SeparacaoModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return SeparacaoModel.empty();
    return SeparacaoModel(
      idFilial: map[colLoja] ?? 0,
      idPrevenda: map[colNumero] ?? 0,
      ordem: map[colOrdem] ?? 0,
      idProduto: map[colIdProduto] ?? 0,
      qtde: (map[colQtde] as num?)?.toDouble() ?? 0.0,
      pecas: map[colPecas] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colLoja: idFilial,
    colNumero: idPrevenda,
    colOrdem: ordem,
    colIdProduto: idProduto,
    colQtde: qtde,
    colPecas: pecas,
  };

  @override
  String toString() =>
      'SeparacaoModel(loja: $idFilial, numero: $idPrevenda, idproduto: $idProduto, qtde: $qtde, peca: $pecas)';
}
