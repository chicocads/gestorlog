import '../cadastro/produto_model.dart';
import '../lote_saida_model.dart';

class PreVenda2Model {
  static const tblNome = 'PreVenda2';

  static const colLoja = 'loja';
  static const colNumero = 'numero';
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
    required this.loja,
    required this.numero,
    required this.ordem,
    required this.tipo,
    required this.idproduto,
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
  final int loja;
  final int numero;
  final int ordem;

  // identificação do produto
  final int idproduto;
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
    loja: 0,
    numero: 0,
    ordem: 0,
    tipo: 0,
    idproduto: 0,
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
    int? loja,
    int? numero,
    int? ordem,
    int? tipo,
    int? idproduto,
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
      loja: loja ?? this.loja,
      numero: numero ?? this.numero,
      ordem: ordem ?? this.ordem,
      tipo: tipo ?? this.tipo,
      idproduto: idproduto ?? this.idproduto,
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
      loja: map[colLoja] ?? 0,
      numero: map[colNumero] ?? 0,
      ordem: map[colOrdem] ?? 0,
      tipo: map[colTipo] ?? 0,
      idproduto: map[colIdProduto] ?? 0,
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
    colLoja: loja,
    colNumero: numero,
    colOrdem: ordem,
    colTipo: tipo,
    colIdProduto: idproduto,
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
      'PreVenda2Model(loja: $loja, numero: $numero, ordem: $ordem, idproduto: $idproduto, qtde: $qtde, qtdesep: $qtdesep)';
}
