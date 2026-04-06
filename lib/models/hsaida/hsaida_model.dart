import 'package:gestorlog/models/cadastro/colaborador_model.dart';

import '../cadastro/cliente_model.dart';
import 'dsaida_model.dart';
import 'hsaida2_model.dart';

enum StatusPV {
  fechado(2),
  cancelado(3);

  const StatusPV(this.value);
  final int value;

  static StatusPV fromValue(int value) => StatusPV.values.firstWhere(
    (e) => e.value == value,
    orElse: () => StatusPV.fechado,
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

class HSaidaModel {
  static const tblNome = 'hsaida';

  static const colIdFilial = 'idfilial';
  static const colIdPrevenda = 'idprevenda';
  static const colNfiscal = 'nfiscal';
  static const colCarregamento = 'carregamento';
  static const colData = 'data';
  static const colTipo = 'tipo';
  static const colNatope = 'natope';
  static const colVolume = 'volume';
  static const colPeso = 'peso';
  static const colIdCliente = 'idcliente';
  static const colCliente = 'cliente';
  static const colIdColabor = 'idcolabor';
  static const colColabor = 'colaborador';
  static const colVdocumento = 'vdocumento';
  static const colVnota = 'vnota';
  static const colVprodutos = 'vprodutos';
  static const colVdesconto = 'vdesconto';
  static const colVretorno = 'vretorno';
  static const colRetorno = 'retorno';
  static const colEntregue = 'entregue';
  static const colDtEntrega = 'dtentrega';
  static const colRomaneio = 'romaneio';
  static const colIdSeparador = 'idSeparador';
  static const colStatus = 'status';
  static const colObs = 'obs';
  static const colDsaidaList = 'dsaidaList';
  static const colHsaida2List = 'hsaida2List';

  HSaidaModel({
    required this.idFilial,
    required this.idPrevenda,
    required this.nfiscal,
    required this.carregamento,
    required this.data,
    required this.tipo,
    required this.natope,
    required this.volume,
    required this.peso,
    required this.idCliente,
    required this.cliente,
    required this.idColabor,
    required this.colaborador,
    required this.vdocumento,
    required this.vnota,
    required this.vprodutos,
    required this.vdesconto,
    required this.vretorno,
    required this.retorno,
    required this.entregue,
    required this.dtEntrega,
    required this.romaneio,
    required this.idSeparador,
    required this.status,
    required this.obs,
    required this.dsaidaList,
    required this.hsaida2List,
  });

  // chave primária
  final int idFilial;
  final int idPrevenda;
  final int nfiscal;

  // identificação
  final int carregamento;
  final String data;
  final int tipo;
  final int natope;

  // volumes e peso
  final int volume;
  final double peso;

  // referências
  final int idCliente;
  final int idColabor;

  // valores
  final double vdocumento;
  final double vnota;
  final double vprodutos;
  final double vdesconto;
  final double vretorno;

  // status
  final int retorno;
  final int entregue;
  final String dtEntrega;
  final int romaneio;
  final int idSeparador;
  final int status;
  final String obs;

  // detalhes
  final ClienteModel cliente;
  final ColaboradorModel colaborador;
  final List<DSaidaModel> dsaidaList;
  final List<HSaida2Model> hsaida2List;

  factory HSaidaModel.empty() => HSaidaModel(
    idFilial: 0,
    idPrevenda: 0,
    nfiscal: 0,
    carregamento: 0,
    data: '',
    tipo: 0,
    natope: 0,
    volume: 0,
    peso: 0,
    idCliente: 0,
    cliente: ClienteModel.empty(),
    idColabor: 0,
    colaborador: ColaboradorModel.empty(),
    vdocumento: 0,
    vnota: 0,
    vprodutos: 0,
    vdesconto: 0,
    vretorno: 0,
    retorno: 0,
    entregue: 0,
    dtEntrega: '',
    romaneio: 0,
    idSeparador: 0,
    status: 0,
    obs: '',
    dsaidaList: const [],
    hsaida2List: const [],
  );

  HSaidaModel copyWith({
    int? idFilial,
    int? idPrevenda,
    int? nfiscal,
    int? carregamento,
    String? data,
    int? tipo,
    int? natope,
    int? volume,
    double? peso,
    int? idCliente,
    ClienteModel? cliente,
    int? idColabor,
    ColaboradorModel? colaborador,
    double? vdocumento,
    double? vnota,
    double? vprodutos,
    double? vdesconto,
    double? vretorno,
    int? retorno,
    int? entregue,
    String? dtEntrega,
    int? romaneio,
    int? idSeparador,
    int? status,
    String? obs,
    List<DSaidaModel>? dsaidaList,
    List<HSaida2Model>? hsaida2List,
  }) {
    return HSaidaModel(
      idFilial: idFilial ?? this.idFilial,
      idPrevenda: idPrevenda ?? this.idPrevenda,
      nfiscal: nfiscal ?? this.nfiscal,
      carregamento: carregamento ?? this.carregamento,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      natope: natope ?? this.natope,
      volume: volume ?? this.volume,
      peso: peso ?? this.peso,
      idCliente: idCliente ?? this.idCliente,
      cliente: cliente ?? this.cliente,
      idColabor: idColabor ?? this.idColabor,
      colaborador: colaborador ?? this.colaborador,
      vdocumento: vdocumento ?? this.vdocumento,
      vnota: vnota ?? this.vnota,
      vprodutos: vprodutos ?? this.vprodutos,
      vdesconto: vdesconto ?? this.vdesconto,
      vretorno: vretorno ?? this.vretorno,
      retorno: retorno ?? this.retorno,
      entregue: entregue ?? this.entregue,
      dtEntrega: dtEntrega ?? this.dtEntrega,
      romaneio: romaneio ?? this.romaneio,
      idSeparador: idSeparador ?? this.idSeparador,
      status: status ?? this.status,
      obs: obs ?? this.obs,
      dsaidaList: dsaidaList ?? List.of(this.dsaidaList),
      hsaida2List: hsaida2List ?? List.of(this.hsaida2List),
    );
  }

  factory HSaidaModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return HSaidaModel.empty();
    return HSaidaModel(
      idFilial: map[colIdFilial] ?? 0,
      idPrevenda: map[colIdPrevenda] ?? 0,
      nfiscal: map[colNfiscal] ?? 0,
      carregamento: map[colCarregamento] ?? 0,
      data: map[colData] ?? '',
      tipo: map[colTipo] ?? 0,
      natope: map[colNatope] ?? 0,
      volume: map[colVolume] ?? 0,
      peso: (map[colPeso] ?? 0).toDouble(),
      idCliente: map[colIdCliente] ?? 0,
      cliente: map[colCliente] is Map<String, dynamic>
          ? ClienteModel.fromMap(map[colCliente] as Map<String, dynamic>)
          : ClienteModel.empty(),
      idColabor: map[colIdColabor] ?? 0,
      colaborador: map[colColabor] is Map<String, dynamic>
          ? ColaboradorModel.fromMap(map[colColabor] as Map<String, dynamic>)
          : ColaboradorModel.empty(),
      vdocumento: (map[colVdocumento] ?? 0).toDouble(),
      vnota: (map[colVnota] ?? 0).toDouble(),
      vprodutos: (map[colVprodutos] ?? 0).toDouble(),
      vdesconto: (map[colVdesconto] ?? 0).toDouble(),
      vretorno: (map[colVretorno] ?? 0).toDouble(),
      retorno: map[colRetorno] ?? 0,
      entregue: map[colEntregue] ?? 0,
      dtEntrega: map[colDtEntrega] ?? '',
      romaneio: map[colRomaneio] ?? 0,
      idSeparador: map[colIdSeparador] ?? 0,
      status: map[colStatus] ?? 0,
      obs: map[colObs] ?? '',
      dsaidaList: (map[colDsaidaList] as List<dynamic>? ?? [])
          .map((e) => DSaidaModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      hsaida2List: (map[colHsaida2List] as List<dynamic>? ?? [])
          .map((e) => HSaida2Model.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    colIdFilial: idFilial,
    colIdPrevenda: idPrevenda,
    colNfiscal: nfiscal,
    colCarregamento: carregamento,
    colData: data,
    colTipo: tipo,
    colNatope: natope,
    colVolume: volume,
    colPeso: peso,
    colIdCliente: idCliente,
    colCliente: cliente.toMap(),
    colIdColabor: idColabor,
    colColabor: colaborador.toMap(),
    colVdocumento: vdocumento,
    colVnota: vnota,
    colVprodutos: vprodutos,
    colVdesconto: vdesconto,
    colVretorno: vretorno,
    colRetorno: retorno,
    colEntregue: entregue,
    colDtEntrega: dtEntrega,
    colRomaneio: romaneio,
    colIdSeparador: idSeparador,
    colStatus: status,
    colObs: obs,
    colDsaidaList: dsaidaList.map((e) => e.toMap()).toList(),
    colHsaida2List: hsaida2List.map((e) => e.toMap()).toList(),
  };

  @override
  String toString() =>
      'HSaidaModel(loja: $idFilial, prevenda: $idPrevenda, cliente: $idCliente, status: $status)';
}
