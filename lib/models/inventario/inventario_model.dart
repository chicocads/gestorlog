class InventarioModel {
  static const tblNome = 'inventario';
  static const colId = 'id';
  static const colProduto = 'produto';
  static const colBarra = 'codigoBarra';
  static const colPecas = 'pecas';
  static const colQtde = 'qtde';
  static const colLote = 'lote';
  static const colValidade = 'validade';
  static const colNomePro = 'nomepro';

  InventarioModel({
    required this.id,
    required this.produto,
    required this.codigoBarra,
    required this.pecas,
    required this.qtde,
    required this.lote,
    required this.validade,
    required this.nomePro,
  });

  final int id;
  final int produto;
  final String codigoBarra;
  final int pecas;
  final double qtde;
  final String lote;
  final String validade;
  final String nomePro;

  factory InventarioModel.empty() => InventarioModel(
    id: 0,
    produto: 0,
    codigoBarra: '',
    pecas: 0,
    qtde: 0.0,
    lote: '',
    validade: '',
    nomePro: '',
  );

  InventarioModel copyWith({
    int? id,
    int? produto,
    String? codigoBarra,
    int? pecas,
    double? qtde,
    String? lote,
    String? validade,
    String? nomePro,
  }) {
    return InventarioModel(
      id: id ?? this.id,
      produto: produto ?? this.produto,
      codigoBarra: codigoBarra ?? this.codigoBarra,
      pecas: pecas ?? this.pecas,
      qtde: qtde ?? this.qtde,
      lote: lote ?? this.lote,
      validade: validade ?? this.validade,
      nomePro: nomePro ?? this.nomePro,
    );
  }

  factory InventarioModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return InventarioModel.empty();
    return InventarioModel(
      id: map[colId] as int? ?? 0,
      produto: map[colProduto] as int? ?? 0,
      codigoBarra: map[colBarra] as String? ?? '',
      pecas: map[colPecas] as int? ?? 0,
      qtde: (map[colQtde] as num?)?.toDouble() ?? 0.0,
      lote: map[colLote] as String? ?? '',
      validade: map[colValidade] as String? ?? '',
      nomePro: (map[colNomePro] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
    colId: id,
    colProduto: produto,
    colBarra: codigoBarra,
    colPecas: pecas,
    colQtde: qtde,
    colLote: lote,
    colValidade: validade,
    colNomePro: nomePro,
  };

  @override
  String toString() =>
      'InventarioModel(id: $id, produto: $produto, codigoBarra: $codigoBarra, pecas: $pecas, qtde: $qtde, lote: $lote, validade: $validade)';
}
