import '../cadastro/cliente_model.dart';
import '../cadastro/colaborador_model.dart';
import 'prevenda2_model.dart';

enum StatusPV {
  orcamento(0),
  confirmado(1),
  fechado(2),
  cancelado(3);

  const StatusPV(this.value);
  final int value;

  static StatusPV fromValue(int value) => StatusPV.values.firstWhere(
    (e) => e.value == value,
    orElse: () => StatusPV.orcamento,
  );
}

enum NaturezaOperacao {
  venda(1),
  aComercializar(2),
  transferencia(3),
  devVenda(4),
  devCompra(5),
  retornoCarga(6),
  simplesRemessa(7),
  amostraGratis(8),
  bonificacao(9),
  emprestimo(10),
  brindeDoacao(11),
  avaria(12),
  consignacao(13),
  perdaRoubo(14),
  icmsComplementar(15),
  ativoImobilizado(16),
  ressarcimento(17),
  comodato(18),
  outrasOperacoes(19),
  mortalidadeEntrega(20),
  consumoInterno(21),
  demostracao(22),
  transformacao(23),
  remVasilhame(24),
  devVasilhame(25),
  cobertutaNfce(26),
  devolucaoFrete(27),
  nfeVinculada(28),
  vendaOrdem(29),
  remessaOrdem(30),
  produtoVencido(31),
  garantiaVenda(32);

  const NaturezaOperacao(this.value);
  final int value;

  static NaturezaOperacao fromValue(int value) =>
      NaturezaOperacao.values.firstWhere(
        (e) => e.value == value,
        orElse: () => NaturezaOperacao.venda,
      );
}

enum NOperacaoMobile {
  venda(1),
  troca(2),
  bonificado(3),
  avaria(4),
  sugestao(5),
  recolher(6);

  const NOperacaoMobile(this.value);
  final int value;

  static NOperacaoMobile fromValue(int value) => NOperacaoMobile.values
      .firstWhere((e) => e.value == value, orElse: () => NOperacaoMobile.venda);
}

class PreVendaModel {
  static const tblNome = 'PreVenda';

  static const colIdFilial = 'idfilial';
  static const colIdPrevenda = 'idprevenda';
  static const colUsuario = 'usuario';
  static const colUData = 'udata';
  static const colTipo = 'tipo';
  static const colNatOpe = 'natope';
  static const colOs = 'os';
  static const colEstacao = 'estacao';
  static const colCaixa = 'caixa';
  static const colModelo = 'modelo';
  static const colNFiscal = 'nfiscal';
  static const colNfSerie = 'nfserie';
  static const colCarregamento = 'carregamento';
  static const colData = 'data';
  static const colIdCliente = 'idcliente';
  static const colCliente = 'cliente';
  static const colIdColabor = 'idcolabor';
  static const colColabor = 'colaborador';
  static const colComiPecas = 'comipecas';
  static const colComiServicos = 'comiservicos';
  static const colValor = 'valor';
  static const colTipDesconto = 'tipdesconto';
  static const colDesconto = 'desconto';
  static const colFPagamento = 'idfpagamto';
  static const colNParcelas = 'nparcelas';
  static const colNf = 'nf';
  static const colObs = 'obs';
  static const colStatus = 'status';
  static const colRomaneio = 'romaneio';
  static const colMinuta = 'minuta';
  static const colEntregue = 'entregue';
  static const colDtEntrega = 'dtentrega';
  static const colHrEntrega = 'hrentrega';
  static const colArmazenado = 'armazenado';
  static const colNTabela = 'ntabela';
  static const colVolume = 'volume';
  static const colSeparador = 'separador';
  static const colParkPlaca = 'park_placa';
  static const colTelemarketing = 'telamarketing';
  static const colAutentica = 'autentica';
  static const colVlProdutos = 'vlprodutos';
  static const colVlTxEntrega = 'vltxentrega';
  static const colFrota = 'frota';
  static const colTFrete = 'tfrete';
  static const colVlFrete = 'vl_frete';
  static const colObs2 = 'obs2';
  static const colVDesconto = 'vdesconto';
  static const colPvDtIniSep = 'pv_dtinisep';
  static const colPvDtFimSep = 'pv_dtfimsep';
  static const colPvWms = 'pv_wms';
  static const colPvNfServ = 'pv_nfserv';
  static const colPvOpiniao = 'pv_opiniao';
  static const colSolicitante = 'solicitante';
  static const colCanalVenda = 'canalvenda';
  static const colPvLstCompra = 'pv_lstcompra';
  static const colNavVessel = 'navvessel';
  static const colNavAgency = 'navagency';
  static const colNavPort = 'navport';
  static const colNavPo = 'navpo';
  static const colTerroSepar = 'terrosepar';
  static const colPvParceiro = 'pvparceiro';
  static const colVAcessorias = 'vacessorias';

  PreVendaModel({
    required this.idFilial,
    required this.idPrevenda,
    required this.usuario,
    required this.uData,
    required this.tipo,
    required this.natope,
    required this.os,
    required this.estacao,
    required this.caixa,
    required this.modelo,
    required this.nFiscal,
    required this.nfSerie,
    required this.carregamento,
    required this.data,
    required this.idCliente,
    required this.cliente,
    required this.idColabor,
    required this.colaborador,
    required this.comiPecas,
    required this.comiServicos,
    required this.valor,
    required this.tipDesconto,
    required this.desconto,
    required this.fPagamento,
    required this.nParcelas,
    required this.nf,
    required this.obs,
    required this.status,
    required this.romaneio,
    required this.minuta,
    required this.entregue,
    required this.dtEntrega,
    required this.hrEntrega,
    required this.armazenado,
    required this.nTabela,
    required this.volume,
    required this.separador,
    required this.parkPlaca,
    required this.telemarketing,
    required this.autentica,
    required this.vlProdutos,
    required this.vlTxEntrega,
    required this.frota,
    required this.tFrete,
    required this.vlFrete,
    required this.obs2,
    required this.vDesconto,
    required this.pvDtIniSep,
    required this.pvDtFimSep,
    required this.pvWms,
    required this.pvNfServ,
    required this.pvOpiniao,
    required this.solicitante,
    required this.canalVenda,
    required this.pvLstCompra,
    required this.navVessel,
    required this.navAgency,
    required this.navPort,
    required this.navPo,
    required this.terroSepar,
    required this.pvParceiro,
    required this.vAcessorias,
    required this.itens,
  });

  // chave primária
  final int idFilial;
  final int idPrevenda;

  // identificação / auditoria
  final String usuario;
  final String uData;
  final String autentica;
  final String solicitante;

  // classificação
  final int tipo;
  final int natope;
  final int os;
  final int estacao;
  final int caixa;
  final String modelo;
  final int nTabela;
  final int canalVenda;

  // nota fiscal
  final int nFiscal;
  final String nfSerie;
  final int nf;
  final int pvNfServ;

  // datas
  final String data;
  final String dtEntrega;
  final String hrEntrega;
  final String pvDtIniSep;
  final String pvDtFimSep;

  // partes envolvidas
  final int idCliente;
  final int idColabor;
  final int carregamento;
  final int separador;
  final int frota;
  final int telemarketing;
  final int pvParceiro;
  final int pvLstCompra;

  // valores financeiros
  final double comiPecas;
  final double comiServicos;
  final double valor;
  final double desconto;
  final double vlProdutos;
  final double vlTxEntrega;
  final double vlFrete;
  final double vDesconto;
  final double vAcessorias;

  // pagamento
  final int tipDesconto;
  final int fPagamento;
  final int nParcelas;
  final int tFrete;

  // logística
  final int romaneio;
  final int minuta;
  final int entregue;
  final int volume;
  final String armazenado;
  final String parkPlaca;

  // navegação (exportação)
  final String navVessel;
  final String navAgency;
  final String navPort;
  final String navPo;
  final int terroSepar;

  // outros
  final String obs;
  final String obs2;
  final StatusPV status;
  final int pvWms;
  final int pvOpiniao;

  final ClienteModel cliente;
  final ColaboradorModel colaborador;

  // itens da pré-venda (PreVenda2)
  final List<PreVenda2Model> itens;

  factory PreVendaModel.empty() => PreVendaModel(
    idFilial: 0,
    idPrevenda: 0,
    usuario: '',
    uData: '',
    tipo: 0,
    natope: 0,
    os: 0,
    estacao: 0,
    caixa: 0,
    modelo: '',
    nFiscal: 0,
    nfSerie: '',
    carregamento: 0,
    data: '',
    idCliente: 0,
    idColabor: 0,
    comiPecas: 0,
    comiServicos: 0,
    valor: 0,
    tipDesconto: 0,
    desconto: 0,
    fPagamento: 0,
    nParcelas: 0,
    nf: 0,
    obs: '',
    status: StatusPV.orcamento,
    romaneio: 0,
    minuta: 0,
    entregue: 0,
    dtEntrega: '',
    hrEntrega: '',
    armazenado: '',
    nTabela: 0,
    volume: 0,
    separador: 0,
    parkPlaca: '',
    telemarketing: 0,
    autentica: '',
    vlProdutos: 0,
    vlTxEntrega: 0,
    frota: 0,
    tFrete: 0,
    vlFrete: 0,
    obs2: '',
    vDesconto: 0,
    pvDtIniSep: '',
    pvDtFimSep: '',
    pvWms: 0,
    pvNfServ: 0,
    pvOpiniao: 0,
    solicitante: '',
    canalVenda: 0,
    pvLstCompra: 0,
    navVessel: '',
    navAgency: '',
    navPort: '',
    navPo: '',
    terroSepar: 0,
    pvParceiro: 0,
    vAcessorias: 0,
    cliente: ClienteModel.empty(),
    colaborador: ColaboradorModel.empty(),
    itens: const [],
  );

  PreVendaModel copyWith({
    int? idFilial,
    int? idPrevenda,
    String? usuario,
    String? uData,
    int? tipo,
    int? natope,
    int? os,
    int? estacao,
    int? caixa,
    String? modelo,
    int? nFiscal,
    String? nfSerie,
    int? carregamento,
    String? data,
    int? idCliente,
    int? idColabor,
    double? comiPecas,
    double? comiServicos,
    double? valor,
    int? tipDesconto,
    double? desconto,
    int? fPagamento,
    int? nParcelas,
    int? nf,
    String? obs,
    StatusPV? status,
    int? romaneio,
    int? minuta,
    int? entregue,
    String? dtEntrega,
    String? hrEntrega,
    String? armazenado,
    int? nTabela,
    int? volume,
    int? separador,
    String? parkPlaca,
    double? impFederal,
    int? telemarketing,
    String? autentica,
    double? vlProdutos,
    double? vlTxEntrega,
    int? frota,
    int? tFrete,
    double? vlFrete,
    String? obs2,
    double? vDesconto,
    String? pvDtIniSep,
    String? pvDtFimSep,
    int? pvWms,
    int? pvNfServ,
    int? pvOpiniao,
    String? solicitante,
    int? canalVenda,
    int? pvLstCompra,
    String? navVessel,
    String? navAgency,
    String? navPort,
    String? navPo,
    int? terroSepar,
    int? pvParceiro,
    double? vAcessorias,
    ClienteModel? cliente,
    ColaboradorModel? colaborador,
    List<PreVenda2Model>? itens,
  }) {
    return PreVendaModel(
      idFilial: idFilial ?? this.idFilial,
      idPrevenda: idPrevenda ?? this.idPrevenda,
      usuario: usuario ?? this.usuario,
      uData: uData ?? this.uData,
      tipo: tipo ?? this.tipo,
      natope: natope ?? this.natope,
      os: os ?? this.os,
      estacao: estacao ?? this.estacao,
      caixa: caixa ?? this.caixa,
      modelo: modelo ?? this.modelo,
      nFiscal: nFiscal ?? this.nFiscal,
      nfSerie: nfSerie ?? this.nfSerie,
      carregamento: carregamento ?? this.carregamento,
      data: data ?? this.data,
      idCliente: idCliente ?? this.idCliente,
      idColabor: idColabor ?? this.idColabor,
      comiPecas: comiPecas ?? this.comiPecas,
      comiServicos: comiServicos ?? this.comiServicos,
      valor: valor ?? this.valor,
      tipDesconto: tipDesconto ?? this.tipDesconto,
      desconto: desconto ?? this.desconto,
      fPagamento: fPagamento ?? this.fPagamento,
      nParcelas: nParcelas ?? this.nParcelas,
      nf: nf ?? this.nf,
      obs: obs ?? this.obs,
      status: status ?? this.status,
      romaneio: romaneio ?? this.romaneio,
      minuta: minuta ?? this.minuta,
      entregue: entregue ?? this.entregue,
      dtEntrega: dtEntrega ?? this.dtEntrega,
      hrEntrega: hrEntrega ?? this.hrEntrega,
      armazenado: armazenado ?? this.armazenado,
      nTabela: nTabela ?? this.nTabela,
      volume: volume ?? this.volume,
      separador: separador ?? this.separador,
      parkPlaca: parkPlaca ?? this.parkPlaca,
      telemarketing: telemarketing ?? this.telemarketing,
      autentica: autentica ?? this.autentica,
      vlProdutos: vlProdutos ?? this.vlProdutos,
      vlTxEntrega: vlTxEntrega ?? this.vlTxEntrega,
      frota: frota ?? this.frota,
      tFrete: tFrete ?? this.tFrete,
      vlFrete: vlFrete ?? this.vlFrete,
      obs2: obs2 ?? this.obs2,
      vDesconto: vDesconto ?? this.vDesconto,
      pvDtIniSep: pvDtIniSep ?? this.pvDtIniSep,
      pvDtFimSep: pvDtFimSep ?? this.pvDtFimSep,
      pvWms: pvWms ?? this.pvWms,
      pvNfServ: pvNfServ ?? this.pvNfServ,
      pvOpiniao: pvOpiniao ?? this.pvOpiniao,
      solicitante: solicitante ?? this.solicitante,
      canalVenda: canalVenda ?? this.canalVenda,
      pvLstCompra: pvLstCompra ?? this.pvLstCompra,
      navVessel: navVessel ?? this.navVessel,
      navAgency: navAgency ?? this.navAgency,
      navPort: navPort ?? this.navPort,
      navPo: navPo ?? this.navPo,
      terroSepar: terroSepar ?? this.terroSepar,
      pvParceiro: pvParceiro ?? this.pvParceiro,
      vAcessorias: vAcessorias ?? this.vAcessorias,
      cliente: cliente ?? this.cliente,
      colaborador: colaborador ?? this.colaborador,
      itens: itens ?? List.of(this.itens),
    );
  }

  factory PreVendaModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return PreVendaModel.empty();
    return PreVendaModel(
      idFilial: map[colIdFilial] ?? 0,
      idPrevenda: map[colIdPrevenda] ?? 0,
      usuario: map[colUsuario] ?? '',
      uData: map[colUData] ?? '',
      tipo: map[colTipo] ?? 0,
      natope: map[colNatOpe] ?? 0,
      os: map[colOs] ?? 0,
      estacao: map[colEstacao] ?? 0,
      caixa: map[colCaixa] ?? 0,
      modelo: map[colModelo] ?? '',
      nFiscal: map[colNFiscal] ?? 0,
      nfSerie: map[colNfSerie] ?? '',
      carregamento: map[colCarregamento] ?? 0,
      data: map[colData] ?? '',
      idCliente: map[colIdCliente] ?? 0,
      idColabor: map[colIdColabor] ?? 0,
      comiPecas: map[colComiPecas] ?? 0,
      comiServicos: map[colComiServicos] ?? 0,
      valor: map[colValor] ?? 0,
      tipDesconto: map[colTipDesconto] ?? 0,
      desconto: map[colDesconto] ?? 0,
      fPagamento: map[colFPagamento] ?? 0,
      nParcelas: map[colNParcelas] ?? 0,
      nf: map[colNf] ?? 0,
      obs: map[colObs] ?? '',
      status: StatusPV.fromValue(map[colStatus] ?? 0),
      romaneio: map[colRomaneio] ?? 0,
      minuta: map[colMinuta] ?? 0,
      entregue: map[colEntregue] ?? 0,
      dtEntrega: map[colDtEntrega] ?? '',
      hrEntrega: map[colHrEntrega] ?? '',
      armazenado: map[colArmazenado] ?? '',
      nTabela: map[colNTabela] ?? 0,
      volume: map[colVolume] ?? 0,
      separador: map[colSeparador] ?? 0,
      parkPlaca: map[colParkPlaca] ?? '',
      telemarketing: map[colTelemarketing] ?? 0,
      autentica: map[colAutentica] ?? '',
      vlProdutos: map[colVlProdutos] ?? 0,
      vlTxEntrega: map[colVlTxEntrega] ?? 0,
      frota: map[colFrota] ?? 0,
      tFrete: map[colTFrete] ?? 0,
      vlFrete: map[colVlFrete] ?? 0,
      obs2: map[colObs2] ?? '',
      vDesconto: map[colVDesconto] ?? 0,
      pvDtIniSep: map[colPvDtIniSep] ?? '',
      pvDtFimSep: map[colPvDtFimSep] ?? '',
      pvWms: map[colPvWms] ?? 0,
      pvNfServ: map[colPvNfServ] ?? 0,
      pvOpiniao: map[colPvOpiniao] ?? 0,
      solicitante: map[colSolicitante] ?? '',
      canalVenda: map[colCanalVenda] ?? 0,
      pvLstCompra: map[colPvLstCompra] ?? 0,
      navVessel: map[colNavVessel] ?? '',
      navAgency: map[colNavAgency] ?? '',
      navPort: map[colNavPort] ?? '',
      navPo: map[colNavPo] ?? '',
      terroSepar: map[colTerroSepar] ?? 0,
      pvParceiro: map[colPvParceiro] ?? 0,
      vAcessorias: map[colVAcessorias] ?? 0,
      cliente: map[colCliente] is Map<String, dynamic>
          ? ClienteModel.fromMap(map[colCliente] as Map<String, dynamic>)
          : ClienteModel.empty(),
      colaborador: map[colColabor] is Map<String, dynamic>
          ? ColaboradorModel.fromMap(map[colColabor] as Map<String, dynamic>)
          : ColaboradorModel.empty(),
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map((e) => PreVenda2Model.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  //json['itens'] = itens!.map((v) => v.toJson()).toList();

  Map<String, dynamic> toMap() => {
    colIdFilial: idFilial,
    colIdPrevenda: idPrevenda,
    colUsuario: usuario,
    colUData: uData,
    colTipo: tipo,
    colNatOpe: natope,
    colOs: os,
    colEstacao: estacao,
    colCaixa: caixa,
    colModelo: modelo,
    colNFiscal: nFiscal,
    colNfSerie: nfSerie,
    colCarregamento: carregamento,
    colData: data,
    colIdCliente: idCliente,
    colIdColabor: idColabor,
    colComiPecas: comiPecas,
    colComiServicos: comiServicos,
    colValor: valor,
    colTipDesconto: tipDesconto,
    colDesconto: desconto,
    colFPagamento: fPagamento,
    colNParcelas: nParcelas,
    colNf: nf,
    colObs: obs,
    colStatus: status.value,
    colRomaneio: romaneio,
    colMinuta: minuta,
    colEntregue: entregue,
    colDtEntrega: dtEntrega,
    colHrEntrega: hrEntrega,
    colArmazenado: armazenado,
    colNTabela: nTabela,
    colVolume: volume,
    colSeparador: separador,
    colParkPlaca: parkPlaca,
    colTelemarketing: telemarketing,
    colAutentica: autentica,
    colVlProdutos: vlProdutos,
    colVlTxEntrega: vlTxEntrega,
    colFrota: frota,
    colTFrete: tFrete,
    colVlFrete: vlFrete,
    colObs2: obs2,
    colVDesconto: vDesconto,
    colPvDtIniSep: pvDtIniSep,
    colPvDtFimSep: pvDtFimSep,
    colPvWms: pvWms,
    colPvNfServ: pvNfServ,
    colPvOpiniao: pvOpiniao,
    colSolicitante: solicitante,
    colCanalVenda: canalVenda,
    colPvLstCompra: pvLstCompra,
    colNavVessel: navVessel,
    colNavAgency: navAgency,
    colNavPort: navPort,
    colNavPo: navPo,
    colTerroSepar: terroSepar,
    colPvParceiro: pvParceiro,
    colVAcessorias: vAcessorias,
    colCliente: cliente.toMap(),
    colColabor: colaborador.toMap(),
    'itens': itens.map((e) => e.toMap()).toList(),
  };

  @override
  String toString() =>
      'PreVendaModel(loja: $idFilial, numero: $idPrevenda, cliente: $idCliente, valor: $valor, status: $status)';
}
