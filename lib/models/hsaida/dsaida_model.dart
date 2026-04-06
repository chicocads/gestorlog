class DSaidaModel {
  static const tblNome = 'dsaida';

  static const colIdFilial = 'idfilial';
  static const colIdPrevenda = 'idprevenda';
  static const colOrdem = 'ordem';
  static const colNfiscal = 'nfiscal';
  static const colIdProduto = 'idproduto';
  static const colNome = 'ds_nompro';
  static const colUndvenda = 'undvenda';
  static const colFatorvenda = 'fatorvenda';
  static const colLote = 'lote';
  static const colValidade = 'validade';
  static const colPecas = 'pecas';
  static const colQtde = 'qtde';
  static const colQtderet = 'qtderet';
  static const colPrecocusto = 'precocusto';
  static const colPrecovenda = 'precovenda';
  static const colDesconto = 'desconto';
  static const colTabela = 'tabela';
  static const colStatus = 'status';

  DSaidaModel({
    required this.idFilial,
    required this.idPrevenda,
    required this.ordem,
    required this.nfiscal,
    required this.idProduto,
    required this.nomeProduto,
    required this.undvenda,
    required this.fatorvenda,
    required this.lote,
    required this.validade,
    required this.pecas,
    required this.qtde,
    required this.qtderet,
    required this.precocusto,
    required this.precovenda,
    required this.desconto,
    required this.tabela,
    required this.status,
  });

  // chave primária
  final int idFilial;
  final int idPrevenda;
  final int ordem;
  final int nfiscal;

  // identificação do produto
  final int idProduto;
  final String nomeProduto;
  final String undvenda;
  final double fatorvenda;
  final String lote;
  final String validade;

  // quantidades
  final int pecas;
  final double qtde;
  final double qtderet;

  // preços e descontos
  final double precocusto;
  final double precovenda;
  final double desconto;

  // classificação
  final int tabela;
  final int status;

  factory DSaidaModel.empty() => DSaidaModel(
    idFilial: 0,
    idPrevenda: 0,
    ordem: 0,
    nfiscal: 0,
    idProduto: 0,
    nomeProduto: '',
    undvenda: '',
    fatorvenda: 0,
    lote: '',
    validade: '',
    pecas: 0,
    qtde: 0,
    qtderet: 0,
    precocusto: 0,
    precovenda: 0,
    desconto: 0,
    tabela: 0,
    status: 0,
  );

  DSaidaModel copyWith({
    int? idFilial,
    int? idPrevenda,
    int? ordem,
    int? nfiscal,
    int? idProduto,
    String? nomeProduto,
    String? undvenda,
    double? fatorvenda,
    String? lote,
    String? validade,
    int? pecas,
    double? qtde,
    double? qtderet,
    double? precocusto,
    double? precovenda,
    double? desconto,
    int? tabela,
    int? status,
  }) {
    return DSaidaModel(
      idFilial: idFilial ?? this.idFilial,
      idPrevenda: idPrevenda ?? this.idPrevenda,
      ordem: ordem ?? this.ordem,
      nfiscal: nfiscal ?? this.nfiscal,
      idProduto: idProduto ?? this.idProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      undvenda: undvenda ?? this.undvenda,
      fatorvenda: fatorvenda ?? this.fatorvenda,
      lote: lote ?? this.lote,
      validade: validade ?? this.validade,
      pecas: pecas ?? this.pecas,
      qtde: qtde ?? this.qtde,
      qtderet: qtderet ?? this.qtderet,
      precocusto: precocusto ?? this.precocusto,
      precovenda: precovenda ?? this.precovenda,
      desconto: desconto ?? this.desconto,
      tabela: tabela ?? this.tabela,
      status: status ?? this.status,
    );
  }

  factory DSaidaModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return DSaidaModel.empty();
    return DSaidaModel(
      idFilial: map[colIdFilial] ?? 0,
      idPrevenda: map[colIdPrevenda] ?? 0,
      ordem: map[colOrdem] ?? 0,
      nfiscal: map[colNfiscal] ?? 0,
      idProduto: map[colIdProduto] ?? 0,
      nomeProduto: map[colNome] ?? '',
      undvenda: map[colUndvenda] ?? '',
      fatorvenda: (map[colFatorvenda] ?? 0).toDouble(),
      lote: map[colLote] ?? '',
      validade: map[colValidade] ?? '',
      pecas: map[colPecas] ?? 0,
      qtde: (map[colQtde] ?? 0).toDouble(),
      qtderet: (map[colQtderet] ?? 0).toDouble(),
      precocusto: (map[colPrecocusto] ?? 0).toDouble(),
      precovenda: (map[colPrecovenda] ?? 0).toDouble(),
      desconto: (map[colDesconto] ?? 0).toDouble(),
      tabela: map[colTabela] ?? 0,
      status: map[colStatus] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colIdFilial: idFilial,
    colIdPrevenda: idPrevenda,
    colOrdem: ordem,
    colNfiscal: nfiscal,
    colIdProduto: idProduto,
    colNome: nomeProduto,
    colUndvenda: undvenda,
    colFatorvenda: fatorvenda,
    colLote: lote,
    colValidade: validade,
    colPecas: pecas,
    colQtde: qtde,
    colQtderet: qtderet,
    colPrecocusto: precocusto,
    colPrecovenda: precovenda,
    colDesconto: desconto,
    colTabela: tabela,
    colStatus: status,
  };

  @override
  String toString() =>
      'DSaidaModel(loja: $idFilial, prevenda: $idPrevenda, ordem: $ordem, produto: $idProduto, qtde: $qtde)';
}
