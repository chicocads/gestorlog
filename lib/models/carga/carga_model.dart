enum StatusCarregamento {
  aberto(0),
  fechado(1),
  encerrado(2);

  const StatusCarregamento(this.value);
  final int value;

  static StatusCarregamento fromValue(int value) =>
      StatusCarregamento.values.firstWhere(
        (e) => e.value == value,
        orElse: () => StatusCarregamento.aberto,
      );
}

class CarregamentoModel {
  static const tblNome = 'Carregamento';

  static const colIdFilial = 'loja';
  static const colIdCarga = 'numero';
  static const colUsuario = 'usuario';
  static const colUData = 'udata';
  static const colData = 'data';
  static const colTipo = 'tipo';
  static const colFrota = 'frota';
  static const colMotorista = 'motorista';
  static const colTkg = 'tkg';
  static const colTm3 = 'tm3';
  static const colVTotal = 'vtotal';
  static const colObs1 = 'obs1';
  static const colObs2 = 'obs2';
  static const colStatus = 'status';
  static const colMotDevolucao = 'motdevolucao';
  static const colKmSaida = 'kmsaida';
  static const colKmChegada = 'kmchegada';
  static const colCpfCondutor = 'cpfcondutor';
  static const colPlaca = 'placa';
  static const colCentroCusto = 'centrocusto';

  CarregamentoModel({
    required this.idFilial,
    required this.idCarga,
    required this.usuario,
    required this.uData,
    required this.data,
    required this.tipo,
    required this.frota,
    required this.motorista,
    required this.tkg,
    required this.tm3,
    required this.vTotal,
    required this.obs1,
    required this.obs2,
    required this.status,
    required this.motDevolucao,
    required this.kmSaida,
    required this.kmChegada,
    required this.cpfCondutor,
    required this.placa,
    required this.centroCusto,
  });

  // chave primária
  final int idFilial;
  final int idCarga;

  // identificação / auditoria
  final String usuario;
  final String uData;

  // datas
  final String data;

  // classificação
  final int tipo;
  final int frota;
  final String motorista;

  // valores
  final double tkg;
  final double tm3;
  final double vTotal;

  // observações
  final String obs1;
  final String obs2;

  // status
  final StatusCarregamento status;
  final int motDevolucao;

  // logística
  final double kmSaida;
  final double kmChegada;
  final String cpfCondutor;
  final String placa;
  final String centroCusto;

  factory CarregamentoModel.empty() => CarregamentoModel(
    idFilial: 0,
    idCarga: 0,
    usuario: '',
    uData: '',
    data: '',
    tipo: 0,
    frota: 0,
    motorista: '',
    tkg: 0,
    tm3: 0,
    vTotal: 0,
    obs1: '',
    obs2: '',
    status: StatusCarregamento.aberto,
    motDevolucao: 0,
    kmSaida: 0,
    kmChegada: 0,
    cpfCondutor: '',
    placa: '',
    centroCusto: '',
  );

  CarregamentoModel copyWith({
    int? idFilial,
    int? idCarga,
    String? usuario,
    String? uData,
    String? data,
    int? tipo,
    int? frota,
    String? motorista,
    double? tkg,
    double? tm3,
    double? vTotal,
    String? obs1,
    String? obs2,
    StatusCarregamento? status,
    int? motDevolucao,
    double? kmSaida,
    double? kmChegada,
    String? cpfCondutor,
    String? placa,
    String? centroCusto,
  }) {
    return CarregamentoModel(
      idFilial: idFilial ?? this.idFilial,
      idCarga: idCarga ?? this.idCarga,
      usuario: usuario ?? this.usuario,
      uData: uData ?? this.uData,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      frota: frota ?? this.frota,
      motorista: motorista ?? this.motorista,
      tkg: tkg ?? this.tkg,
      tm3: tm3 ?? this.tm3,
      vTotal: vTotal ?? this.vTotal,
      obs1: obs1 ?? this.obs1,
      obs2: obs2 ?? this.obs2,
      status: status ?? this.status,
      motDevolucao: motDevolucao ?? this.motDevolucao,
      kmSaida: kmSaida ?? this.kmSaida,
      kmChegada: kmChegada ?? this.kmChegada,
      cpfCondutor: cpfCondutor ?? this.cpfCondutor,
      placa: placa ?? this.placa,
      centroCusto: centroCusto ?? this.centroCusto,
    );
  }

  factory CarregamentoModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return CarregamentoModel.empty();
    return CarregamentoModel(
      idFilial: map[colIdFilial] ?? 0,
      idCarga: map[colIdCarga] ?? 0,
      usuario: map[colUsuario] ?? '',
      uData: map[colUData] ?? '',
      data: map[colData] ?? '',
      tipo: map[colTipo] ?? 0,
      frota: map[colFrota] ?? 0,
      motorista: map[colMotorista] ?? '',
      tkg: (map[colTkg] ?? 0).toDouble(),
      tm3: (map[colTm3] ?? 0).toDouble(),
      vTotal: (map[colVTotal] ?? 0).toDouble(),
      obs1: map[colObs1] ?? '',
      obs2: map[colObs2] ?? '',
      status: StatusCarregamento.fromValue(map[colStatus] ?? 0),
      motDevolucao: map[colMotDevolucao] ?? 0,
      kmSaida: (map[colKmSaida] ?? 0).toDouble(),
      kmChegada: (map[colKmChegada] ?? 0).toDouble(),
      cpfCondutor: map[colCpfCondutor] ?? '',
      placa: map[colPlaca] ?? '',
      centroCusto: map[colCentroCusto] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    colIdFilial: idFilial,
    colIdCarga: idCarga,
    colUsuario: usuario,
    colUData: uData,
    colData: data,
    colTipo: tipo,
    colFrota: frota,
    colMotorista: motorista,
    colTkg: tkg,
    colTm3: tm3,
    colVTotal: vTotal,
    colObs1: obs1,
    colObs2: obs2,
    colStatus: status.value,
    colMotDevolucao: motDevolucao,
    colKmSaida: kmSaida,
    colKmChegada: kmChegada,
    colCpfCondutor: cpfCondutor,
    colPlaca: placa,
    colCentroCusto: centroCusto,
  };

  @override
  String toString() =>
      'CarregamentoModel(loja: $idFilial, numero: $idCarga, motorista: $motorista, status: $status)';
}
