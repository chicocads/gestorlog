class LoteSaidaModel {
  static const tblNome = 'LoteSaida';

  static const colIdFilial = 'idfilial';
  static const colIdPrevenda = 'idprevenda';
  static const colIdProduto = 'idproduto';
  static const colLote = 'lote';
  static const colValidade = 'validade';
  static const colQtde = 'qtde';

  LoteSaidaModel({
    required this.idFilial,
    required this.idPrevenda,
    required this.idProduto,
    required this.lote,
    required this.validade,
    required this.qtde,
  });

  final int idFilial;
  final int idPrevenda;
  final int idProduto;
  final String lote;
  final String validade;
  final double qtde;

  factory LoteSaidaModel.empty() => LoteSaidaModel(
    idFilial: 0,
    idPrevenda: 0,
    idProduto: 0,
    lote: '',
    validade: '',
    qtde: 0,
  );

  LoteSaidaModel copyWith({
    int? idFilial,
    int? idPrevenda,
    int? idProduto,
    String? lote,
    String? validade,
    double? qtde,
  }) {
    return LoteSaidaModel(
      idFilial: idFilial ?? this.idFilial,
      idPrevenda: idPrevenda ?? this.idPrevenda,
      idProduto: idProduto ?? this.idProduto,
      lote: lote ?? this.lote,
      validade: validade ?? this.validade,
      qtde: qtde ?? this.qtde,
    );
  }

  factory LoteSaidaModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return LoteSaidaModel.empty();
    return LoteSaidaModel(
      idFilial: map[colIdFilial] ?? 0,
      idPrevenda: map[colIdPrevenda] ?? 0,
      idProduto: map[colIdProduto] ?? 0,
      lote: map[colLote] ?? '',
      validade: map[colValidade] != null
          ? map[colValidade].substring(0, 10)
          : '',
      qtde: (map[colQtde] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    colIdFilial: idFilial,
    colIdPrevenda: idPrevenda,
    colIdProduto: idProduto,
    colLote: lote,
    colValidade: validade,
    colQtde: qtde,
  };

  @override
  String toString() =>
      'LoteSaidaModel(loja: $idFilial, prevenda: $idPrevenda, produto: $idProduto, lote: $lote, qtde: $qtde)';
}
