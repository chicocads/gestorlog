class RequestInventario {
  static const colId = 'id';
  static const colIdFilial = 'idFilial';
  static const colProduto = 'produto';
  static const colBarra = 'codigoBarra';
  static const colQtde = 'qtde';
  static const colPecas = 'pecas';
  static const colLote = 'lote';
  static const colValidade = 'validade';
  static const colNomePro = 'nomePro';
  static const colIdInventario = 'idInventario';
  static const colIdPda = 'idPda';

  RequestInventario({
    required this.id,
    required this.idFilial,
    required this.produto,
    required this.codigoBarra,
    required this.qtde,
    required this.pecas,
    required this.lote,
    required this.validade,
    required this.nomePro,
    required this.idInventario,
    required this.idPda,
  });

  final int id;
  final int idFilial;
  final int produto;
  final String codigoBarra;
  final double qtde;
  final int pecas;
  final String lote;
  final String validade;
  final String nomePro;
  final int idInventario;
  final int idPda;

  factory RequestInventario.empty() => RequestInventario(
    id: 0,
    idFilial: 0,
    produto: 0,
    codigoBarra: '',
    qtde: 0,
    pecas: 0,
    lote: '',
    validade: '',
    nomePro: '',
    idInventario: 0,
    idPda: 0,
  );

  RequestInventario copyWith({
    int? id,
    int? idFilial,
    int? produto,
    String? codigoBarra,
    double? qtde,
    int? pecas,
    String? lote,
    String? validade,
    String? nomePro,
    int? idInventario,
    int? idPda,
  }) {
    return RequestInventario(
      id: id ?? this.id,
      idFilial: idFilial ?? this.idFilial,
      produto: produto ?? this.produto,
      codigoBarra: codigoBarra ?? this.codigoBarra,
      qtde: qtde ?? this.qtde,
      pecas: pecas ?? this.pecas,
      lote: lote ?? this.lote,
      validade: validade ?? this.validade,
      nomePro: nomePro ?? this.nomePro,
      idInventario: idInventario ?? this.idInventario,
      idPda: idPda ?? this.idPda,
    );
  }

  factory RequestInventario.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestInventario.empty();
    return RequestInventario(
      id: map[colId] as int? ?? 0,
      idFilial: map[colIdFilial] as int? ?? 0,
      produto: map[colProduto] as int? ?? 0,
      codigoBarra: map[colBarra] as String? ?? '',
      qtde: (map[colQtde] as num?)?.toDouble() ?? 0,
      pecas: map[colPecas] as int? ?? 0,
      lote: map[colLote] as String? ?? '',
      validade: map[colValidade] as String? ?? '',
      nomePro: map[colNomePro] as String? ?? '',
      idInventario: map[colIdInventario] as int? ?? 0,
      idPda: map[colIdPda] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colId: id,
    colIdFilial: idFilial,
    colProduto: produto,
    colBarra: codigoBarra,
    colQtde: qtde,
    colPecas: pecas,
    colLote: lote,
    colValidade: validade,
    colNomePro: nomePro,
    colIdInventario: idInventario,
    colIdPda: idPda,
  };

  factory RequestInventario.fromJson(Map<String, dynamic> json) =>
      RequestInventario.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}
