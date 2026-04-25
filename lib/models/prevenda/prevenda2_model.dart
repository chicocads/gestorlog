import '../cadastro/produto_model.dart';
import '../hsaida/lote_saida_model.dart';

class PreVenda2Model {
  static const tblNome = 'PreVenda2';

  static const colLoja = 'idfilial';
  static const colNumero = 'idprevenda';
  static const colOrdem = 'ordem';
  static const colTipo = 'tipo';
  static const colIdProduto = 'idproduto';
  static const colLote = 'lote';
  static const colValidade = 'validade';
  static const colNomeProduto = 'nomeproduto';
  static const colUnd = 'und';
  static const colPecas = 'pecas';
  static const colQtde = 'qtde';
  static const colQtdeSep = 'qtdesep';
  static const colDesconto = 'desconto';
  static const colTabela = 'tabela';
  static const colPrecoTabela = 'precotabela';
  static const colPreco = 'preco';
  static const colTecnico = 'tecnico';
  static const colTipoComissao = 'tipocomissao';
  static const colComissao = 'comissao';
  static const colStatus = 'status';
  static const colRequis = 'requis';
  static const colAutUsuario = 'autusuario';
  static const colXPedNfe = 'xpednfe';
  static const colXIPedNfe = 'xipednfe';
  static const colFatorVenda = 'fatorvenda';
  static const colVlDesc = 'vl_desc';
  static const colQtdeCxs = 'qtde_cxs';
  static const colTaraCxs = 'tara_cxs';
  static const colPv2Ns = 'pv2_ns';
  static const colProduto = 'produto';
  static const colLotesaida = 'lotesaida';

  PreVenda2Model({
    required this.idFilial,
    required this.idPrevenda,
    required this.ordem,
    required this.tipo,
    required this.idProduto,
    required this.lote,
    required this.validade,
    required this.nomeProduto,
    required this.und,
    required this.pecas,
    required this.qtde,
    required this.qtdesep,
    required this.desconto,
    required this.tabela,
    required this.precoTabela,
    required this.preco,
    required this.tecnico,
    required this.tipoComissao,
    required this.comissao,
    required this.status,
    required this.requis,
    required this.autUsuario,
    required this.xPedNfe,
    required this.xIPedNfe,
    required this.fatorVenda,
    required this.vlDesc,
    required this.qtdeCxs,
    required this.taraCxs,
    required this.pv2Ns,
    required this.produto,
    required this.lotesaida,
  });

  // chave primária
  final int idFilial;
  final int idPrevenda;
  final int ordem;

  // identificação do produto
  final int idProduto;
  final String nomeProduto;
  final String und;
  final String lote;
  final String validade;

  // quantidades
  final int pecas;
  final double qtde;
  final double qtdesep;
  final int qtdeCxs;
  final double taraCxs;

  // preços e descontos
  final double preco;
  final double precoTabela;
  final double desconto;
  final double vlDesc;
  final double fatorVenda;

  // comissão
  final double comissao;
  final int tipoComissao;
  final int tecnico;

  // classificação
  final int tipo;
  final int tabela;
  final int status;
  final int requis;

  // referências NF-e / autorização
  final String autUsuario;
  final String xPedNfe;
  final String xIPedNfe;
  final String pv2Ns;

  final ProdutoModel produto;
  final List<LoteSaidaModel> lotesaida;

  factory PreVenda2Model.empty() => PreVenda2Model(
    idFilial: 0,
    idPrevenda: 0,
    ordem: 0,
    tipo: 0,
    idProduto: 0,
    lote: '',
    validade: '',
    nomeProduto: '',
    und: '',
    pecas: 0,
    qtde: 0.0,
    qtdesep: 0.0,
    desconto: 0.0,
    tabela: 0,
    precoTabela: 0.0,
    preco: 0.0,
    tecnico: 0,
    tipoComissao: 0,
    comissao: 0.0,
    status: 0,
    requis: 0,
    autUsuario: '',
    xPedNfe: '',
    xIPedNfe: '',
    fatorVenda: 0.0,
    vlDesc: 0.0,
    qtdeCxs: 0,
    taraCxs: 0.0,
    pv2Ns: '',
    produto: ProdutoModel.empty(),
    lotesaida: const [],
  );

  PreVenda2Model copyWith({
    int? idFilial,
    int? idPrevenda,
    int? ordem,
    int? tipo,
    int? idProduto,
    String? lote,
    String? validade,
    String? nomeProduto,
    String? und,
    int? pecas,
    double? qtde,
    double? qtdesep,
    double? desconto,
    int? tabela,
    double? precoTabela,
    double? preco,
    int? tecnico,
    int? tipoComissao,
    double? comissao,
    int? status,
    int? requis,
    String? autUsuario,
    String? xPedNfe,
    String? xIPedNfe,
    double? fatorVenda,
    double? vlDesc,
    int? qtdeCxs,
    double? taraCxs,
    String? pv2Ns,
    ProdutoModel? produto,
    List<LoteSaidaModel>? lotesaida,
  }) {
    return PreVenda2Model(
      idFilial: idFilial ?? this.idFilial,
      idPrevenda: idPrevenda ?? this.idPrevenda,
      ordem: ordem ?? this.ordem,
      tipo: tipo ?? this.tipo,
      idProduto: idProduto ?? this.idProduto,
      lote: lote ?? this.lote,
      validade: validade ?? this.validade,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      und: und ?? this.und,
      pecas: pecas ?? this.pecas,
      qtde: qtde ?? this.qtde,
      qtdesep: qtdesep ?? this.qtdesep,
      desconto: desconto ?? this.desconto,
      tabela: tabela ?? this.tabela,
      precoTabela: precoTabela ?? this.precoTabela,
      preco: preco ?? this.preco,
      tecnico: tecnico ?? this.tecnico,
      tipoComissao: tipoComissao ?? this.tipoComissao,
      comissao: comissao ?? this.comissao,
      status: status ?? this.status,
      requis: requis ?? this.requis,
      autUsuario: autUsuario ?? this.autUsuario,
      xPedNfe: xPedNfe ?? this.xPedNfe,
      xIPedNfe: xIPedNfe ?? this.xIPedNfe,
      fatorVenda: fatorVenda ?? this.fatorVenda,
      vlDesc: vlDesc ?? this.vlDesc,
      qtdeCxs: qtdeCxs ?? this.qtdeCxs,
      taraCxs: taraCxs ?? this.taraCxs,
      pv2Ns: pv2Ns ?? this.pv2Ns,
      produto: produto ?? this.produto,
      lotesaida: lotesaida ?? List.of(this.lotesaida),
    );
  }

  factory PreVenda2Model.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return PreVenda2Model.empty();
    return PreVenda2Model(
      idFilial: map[colLoja] ?? 0,
      idPrevenda: map[colNumero] ?? 0,
      ordem: map[colOrdem] ?? 0,
      tipo: map[colTipo] ?? 0,
      idProduto: map[colIdProduto] ?? 0,
      lote: map[colLote] ?? '',
      validade: map[colValidade] ?? '',
      nomeProduto: map[colNomeProduto] ?? '',
      und: map[colUnd] ?? '',
      pecas: map[colPecas] ?? 0,
      qtde: (map[colQtde] as num?)?.toDouble() ?? 0.0,
      qtdesep: (map[colQtdeSep] as num?)?.toDouble() ?? 0.0,
      desconto: (map[colDesconto] as num?)?.toDouble() ?? 0.0,
      tabela: map[colTabela] ?? 0,
      precoTabela: (map[colPrecoTabela] as num?)?.toDouble() ?? 0.0,
      preco: (map[colPreco] as num?)?.toDouble() ?? 0.0,
      tecnico: map[colTecnico] ?? 0,
      tipoComissao: map[colTipoComissao] ?? 0,
      comissao: (map[colComissao] as num?)?.toDouble() ?? 0.0,
      status: map[colStatus] ?? 0,
      requis: map[colRequis] ?? 0,
      autUsuario: map[colAutUsuario] ?? '',
      xPedNfe: map[colXPedNfe] ?? '',
      xIPedNfe: map[colXIPedNfe] ?? '',
      fatorVenda: (map[colFatorVenda] as num?)?.toDouble() ?? 0.0,
      vlDesc: (map[colVlDesc] as num?)?.toDouble() ?? 0.0,
      qtdeCxs: map[colQtdeCxs] ?? 0,
      taraCxs: (map[colTaraCxs] as num?)?.toDouble() ?? 0.0,
      pv2Ns: map[colPv2Ns] ?? '',
      produto: map[colProduto] is Map<String, dynamic>
          ? ProdutoModel.fromMap(map[colProduto] as Map<String, dynamic>)
          : ProdutoModel.empty(),
      lotesaida: (map[colLotesaida] as List<dynamic>? ?? [])
          .map((e) => LoteSaidaModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    colLoja: idFilial,
    colNumero: idPrevenda,
    colOrdem: ordem,
    colTipo: tipo,
    colIdProduto: idProduto,
    colLote: lote,
    colValidade: validade,
    colNomeProduto: nomeProduto,
    colUnd: und,
    colPecas: pecas,
    colQtde: qtde,
    colQtdeSep: qtdesep,
    colDesconto: desconto,
    colTabela: tabela,
    colPrecoTabela: precoTabela,
    colPreco: preco,
    colTecnico: tecnico,
    colTipoComissao: tipoComissao,
    colComissao: comissao,
    colStatus: status,
    colRequis: requis,
    colAutUsuario: autUsuario,
    colXPedNfe: xPedNfe,
    colXIPedNfe: xIPedNfe,
    colFatorVenda: fatorVenda,
    colVlDesc: vlDesc,
    colQtdeCxs: qtdeCxs,
    colTaraCxs: taraCxs,
    colPv2Ns: pv2Ns,
    colProduto: produto.toMap(),
    colLotesaida: lotesaida.map((e) => e.toMap()).toList(),
  };

  @override
  String toString() =>
      'PreVenda2Model(loja: $idFilial, numero: $idPrevenda, ordem: $ordem, idproduto: $idProduto, qtde: $qtde, qtdesep: $qtdesep)';
}
