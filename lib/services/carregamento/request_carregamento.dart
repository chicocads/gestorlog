class RequestCarregamento {
  RequestCarregamento({
    required this.paginaAtual,
    required this.qtdTotal,
    required this.data1,
    required this.data2,
    required this.idFilial,
    required this.numero,
    required this.status,
    required this.frota,
  });

  final String paginaAtual;
  final String qtdTotal;
  final String data1;
  final String data2;
  final int idFilial;
  final int numero;
  final int status;
  final int frota;

  factory RequestCarregamento.empty() => RequestCarregamento(
    paginaAtual: '1',
    qtdTotal: '50',
    data1: '',
    data2: '',
    idFilial: 0,
    numero: 0,
    status: 0,
    frota: 0,
  );

  RequestCarregamento copyWith({
    String? paginaAtual,
    String? qtdTotal,
    String? data1,
    String? data2,
    int? idFilial,
    int? numero,
    int? status,
    int? frota,
  }) {
    return RequestCarregamento(
      paginaAtual: paginaAtual ?? this.paginaAtual,
      qtdTotal: qtdTotal ?? this.qtdTotal,
      data1: data1 ?? this.data1,
      data2: data2 ?? this.data2,
      idFilial: idFilial ?? this.idFilial,
      numero: numero ?? this.numero,
      status: status ?? this.status,
      frota: frota ?? this.frota,
    );
  }

  factory RequestCarregamento.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestCarregamento.empty();
    return RequestCarregamento(
      paginaAtual: map['paginaAtual'] ?? '0',
      qtdTotal: map['qtdTotal'] ?? '0',
      data1: map['data1'] ?? '',
      data2: map['data2'] ?? '',
      idFilial: map['idFilial'] ?? 0,
      numero: map['numero'] ?? 0,
      status: map['status'] ?? 0,
      frota: map['frota'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'paginaAtual': paginaAtual,
    'qtdTotal': qtdTotal,
    'data1': data1,
    'data2': data2,
    'idFilial': idFilial,
    'numero': numero,
    'status': status,
    'frota': frota,
  };
}
