class RequestHSaida {
  RequestHSaida({
    required this.paginaAtual,
    required this.qtdTotal,
    required this.data1,
    required this.data2,
    required this.idFilial,
    required this.idCliente,
    required this.idColabor,
    required this.idSeparador,
    required this.romaneio,
    required this.carregamento,
    required this.numero,
    required this.os,
    required this.status,
    required this.entregue,
    required this.tabAux,
  });

  final String paginaAtual;
  final String qtdTotal;
  final String data1;
  final String data2;
  final int idFilial;
  final int idCliente;
  final int idColabor;
  final int idSeparador;
  final int romaneio;
  final int carregamento;
  final int numero;
  final int os;
  final int status;
  final int entregue;
  final int tabAux;

  factory RequestHSaida.empty() => RequestHSaida(
    paginaAtual: '1',
    qtdTotal: '50',
    data1: '',
    data2: '',
    idFilial: 0,
    idCliente: 0,
    idColabor: 0,
    idSeparador: 0,
    romaneio: 0,
    carregamento: 0,
    numero: 0,
    os: 0,
    status: 0,
    entregue: 0,
    tabAux: 1,
  );

  RequestHSaida copyWith({
    String? paginaAtual,
    String? qtdTotal,
    String? data1,
    String? data2,
    int? idFilial,
    int? idCliente,
    int? idColabor,
    int? idSeparador,
    int? romaneio,
    int? carregamento,
    int? numero,
    int? os,
    int? status,
    int? entregue,
    int? tabAux,
  }) {
    return RequestHSaida(
      paginaAtual: paginaAtual ?? this.paginaAtual,
      qtdTotal: qtdTotal ?? this.qtdTotal,
      data1: data1 ?? this.data1,
      data2: data2 ?? this.data2,
      idFilial: idFilial ?? this.idFilial,
      idCliente: idCliente ?? this.idCliente,
      idColabor: idColabor ?? this.idColabor,
      idSeparador: idSeparador ?? this.idSeparador,
      romaneio: romaneio ?? this.romaneio,
      carregamento: carregamento ?? this.carregamento,
      numero: numero ?? this.numero,
      os: os ?? this.os,
      status: status ?? this.status,
      entregue: entregue ?? this.entregue,
      tabAux: tabAux ?? this.tabAux,
    );
  }

  factory RequestHSaida.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestHSaida.empty();
    return RequestHSaida(
      paginaAtual: map['paginaAtual'] ?? '0',
      qtdTotal: map['qtdTotal'] ?? '0',
      data1: map['data1'] ?? '',
      data2: map['data2'] ?? '',
      idFilial: map['idFilial'] ?? 0,
      idCliente: map['idCliente'] ?? 0,
      idColabor: map['idColabor'] ?? 0,
      idSeparador: map['idSeparador'] ?? 0,
      romaneio: map['romaneio'] ?? 0,
      carregamento: map['carregamento'] ?? 0,
      numero: map['idPrevenda'] ?? 0,
      os: map['os'] ?? 0,
      status: map['status'] ?? 0,
      entregue: map['entregue'] ?? 0,
      tabAux: map['tabAux'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() => {
    'paginaAtual': paginaAtual,
    'qtdTotal': qtdTotal,
    'data1': data1,
    'data2': data2,
    'idFilial': idFilial,
    'idCliente': idCliente,
    'idColabor': idColabor,
    'idSeparador': idSeparador,
    'romaneio': romaneio,
    'carregamento': carregamento,
    'idPrevenda': numero,
    'os': os,
    'status': status,
    'entregue': entregue,
    'tabAux': tabAux,
  };
}
