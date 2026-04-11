class LoteSaidaModel {
  static const tblNome = 'LoteSaida';

  static const colIdFilial = 'idfilial';
  static const colIdPrevenda = 'idprevenda';
  static const colIdProduto = 'idproduto';
  static const colLote = 'lote';
  static const colValidade = 'validade';
  static const colFabricacao = 'fabricacao';
  static const colQtde = 'qtde';

  LoteSaidaModel({
    required this.idFilial,
    required this.idPrevenda,
    required this.idProduto,
    required this.lote,
    required this.validade,
    required this.fabricacao,
    required this.qtde,
  });

  final int idFilial;
  final int idPrevenda;
  final int idProduto;
  final String lote;
  final String validade;
  final String fabricacao;
  final double qtde;

  factory LoteSaidaModel.empty() => LoteSaidaModel(
    idFilial: 0,
    idPrevenda: 0,
    idProduto: 0,
    lote: '',
    validade: '',
    fabricacao: DateTime.now()
        .subtract(const Duration(days: 365))
        .toIso8601String()
        .substring(0, 10),
    qtde: 0.0,
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
      fabricacao: fabricacao,
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
      validade: map[colValidade] ?? '01-01-2000',
      fabricacao: map[colFabricacao] ?? '01-01-2000',
      qtde: (map[colQtde] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() => {
    colIdFilial: idFilial,
    colIdPrevenda: idPrevenda,
    colIdProduto: idProduto,
    colLote: lote,
    colValidade: validade,
    colFabricacao: fabricacao,
    colQtde: qtde,
  };

  @override
  String toString() =>
      'LoteSaidaModel(idFilial: $idFilial, idPrevenda: $idPrevenda, idProduto: $idProduto, lote: $lote, validade: $validade, qtde: $qtde)';
}
