enum StatusCliente {
  normal(1),
  supespenso(2),
  gerencia(3),
  especial(4);

  const StatusCliente(this.value);
  final int value;

  static StatusCliente fromValue(int value) => StatusCliente.values.firstWhere(
    (e) => e.value == value,
    orElse: () => StatusCliente.normal,
  );
}

class ClienteModel {
  static const tblNome = 'cliente';

  static const colId = 'codigo';
  static const colCnpj = 'cnpj';
  static const colIE = 'ie';
  static const colTipo = 'tipo';
  static const colNome = 'nome';
  static const colFantasia = 'fantasia';
  static const colEnd = 'endentrega';
  static const colBai = 'baientrega';
  static const colCdCid = 'cdcidentrega';
  static const colCid = 'cidentrega';
  static const colUF = 'ufentrega';
  static const colCep = 'cepentrega';
  static const colRefEnt = 'refentrega';
  static const colEmail = 'email';
  static const colFone = 'fone';
  static const colContato = 'contato';
  static const colRca = 'idColabor';
  static const colSeg = 'idSegmento';
  static const colIdRota = 'idRota';
  static const colIntinerario = 'intinerario';
  static const colFpa = 'idFpagamto';
  static const colPrazo = 'idPrazo';
  static const colTabela = 'tabela';
  static const colSituacao = 'situacao';
  static const colStatus = 'status';
  static const colLimite = 'limite';
  static const colUtilizado = 'utilizado';
  static const colVlCtr = 'vlContrato';
  static const colTpCtr = 'tpcontrato';
  static const colUltCompra = 'ultcompra';
  static const colLatitude = 'latitude';
  static const colLongitude = 'longitude';
  static const colSenhaWeb = 'senhaweb';
  static const colProxVisita = 'proxVisita';
  static const colMotNPos = 'motnpos';
  static const colSugestao = 'sugestao';
  static const colDscPadrao = 'dscpadrao';
  static const colAcrPadrao = 'acrpadrao';

  ClienteModel({
    required this.codigo,
    required this.cnpj,
    required this.ie,
    required this.tipo,
    required this.nome,
    required this.fantasia,
    required this.endereco,
    required this.bairro,
    required this.cdCidade,
    required this.cidade,
    required this.uf,
    required this.cep,
    required this.refEntrega,
    required this.email,
    required this.fone,
    required this.contato,
    required this.idColabor,
    required this.idSegmento,
    required this.idRota,
    required this.intinerario,
    required this.idFpagamto,
    required this.idPrazo,
    required this.tabela,
    required this.situacao,
    required this.status,
    required this.limite,
    required this.utilizado,
    required this.vlContrato,
    required this.tpContrato,
    required this.ultCompra,
    required this.latitude,
    required this.longitude,
    required this.senhaWeb,
    required this.proxVisita,
    required this.motivo,
    required this.sugestao,
    required this.dscPadrao,
    required this.acrPadrao,
  });

  // chave primária
  final int codigo;

  // identificação fiscal
  final String cnpj;
  final String ie;
  final int tipo;

  // dados cadastrais
  final String nome;
  final String fantasia;
  final String contato;
  final String email;
  final String fone;
  final String senhaWeb;

  // endereço
  final String endereco;
  final String bairro;
  final int cdCidade;
  final String cidade;
  final String uf;
  final String cep;
  final String refEntrega;
  final String latitude;
  final String longitude;

  // comercial
  final int idColabor;
  final int idSegmento;
  final int idRota;
  final int intinerario;
  final int idFpagamto;
  final int idPrazo;
  final int tabela;
  final int situacao;
  final StatusCliente status;
  final String proxVisita;
  final String ultCompra;
  final int motivo;
  final int sugestao;

  // financeiro
  final double limite;
  final double utilizado;
  final double vlContrato;
  final int tpContrato;
  final double dscPadrao;
  final double acrPadrao;

  factory ClienteModel.empty() => ClienteModel(
    codigo: 0,
    cnpj: '',
    ie: '',
    tipo: 0,
    nome: '',
    fantasia: '',
    endereco: '',
    bairro: '',
    cdCidade: 0,
    cidade: '',
    uf: '',
    cep: '',
    refEntrega: '',
    email: '',
    fone: '',
    contato: '',
    idColabor: 0,
    idSegmento: 0,
    idRota: 0,
    intinerario: 0,
    idFpagamto: 0,
    idPrazo: 0,
    tabela: 0,
    situacao: 1,
    status: StatusCliente.normal,
    limite: 0,
    utilizado: 0,
    vlContrato: 0,
    tpContrato: 0,
    ultCompra: '',
    latitude: '',
    longitude: '',
    senhaWeb: '',
    proxVisita: '',
    motivo: 0,
    sugestao: 1,
    dscPadrao: 0,
    acrPadrao: 0,
  );

  ClienteModel copyWith({
    int? codigo,
    String? cnpj,
    String? ie,
    int? tipo,
    String? nome,
    String? fantasia,
    String? endereco,
    String? bairro,
    int? cdCidade,
    String? cidade,
    String? uf,
    String? cep,
    String? refEntrega,
    String? email,
    String? fone,
    String? contato,
    int? idColabor,
    int? idSegmento,
    int? idRota,
    int? intinerario,
    int? idFpagamto,
    int? idPrazo,
    int? tabela,
    int? situacao,
    StatusCliente? status,
    double? limite,
    double? utilizado,
    double? vlContrato,
    int? tpContrato,
    String? ultCompra,
    String? latitude,
    String? longitude,
    String? senhaWeb,
    String? proxVisita,
    int? motivo,
    int? sugestao,
    double? dscPadrao,
    double? acrPadrao,
  }) {
    return ClienteModel(
      codigo: codigo ?? this.codigo,
      cnpj: cnpj ?? this.cnpj,
      ie: ie ?? this.ie,
      tipo: tipo ?? this.tipo,
      nome: nome ?? this.nome,
      fantasia: fantasia ?? this.fantasia,
      endereco: endereco ?? this.endereco,
      bairro: bairro ?? this.bairro,
      cdCidade: cdCidade ?? this.cdCidade,
      cidade: cidade ?? this.cidade,
      uf: uf ?? this.uf,
      cep: cep ?? this.cep,
      refEntrega: refEntrega ?? this.refEntrega,
      email: email ?? this.email,
      fone: fone ?? this.fone,
      contato: contato ?? this.contato,
      idColabor: idColabor ?? this.idColabor,
      idSegmento: idSegmento ?? this.idSegmento,
      idRota: idRota ?? this.idRota,
      intinerario: intinerario ?? this.intinerario,
      idFpagamto: idFpagamto ?? this.idFpagamto,
      idPrazo: idPrazo ?? this.idPrazo,
      tabela: tabela ?? this.tabela,
      situacao: situacao ?? this.situacao,
      status: status ?? this.status,
      limite: limite ?? this.limite,
      utilizado: utilizado ?? this.utilizado,
      vlContrato: vlContrato ?? this.vlContrato,
      tpContrato: tpContrato ?? this.tpContrato,
      ultCompra: ultCompra ?? this.ultCompra,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      senhaWeb: senhaWeb ?? this.senhaWeb,
      proxVisita: proxVisita ?? this.proxVisita,
      motivo: motivo ?? this.motivo,
      sugestao: sugestao ?? this.sugestao,
      dscPadrao: dscPadrao ?? this.dscPadrao,
      acrPadrao: acrPadrao ?? this.acrPadrao,
    );
  }

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ClienteModel.empty();
    return ClienteModel(
      codigo: map[colId] as int? ?? 0,
      cnpj: map[colCnpj] as String? ?? '',
      ie: map[colIE] as String? ?? '',
      tipo: map[colTipo] as int? ?? 0,
      nome: map[colNome] as String? ?? '',
      fantasia: map[colFantasia] as String? ?? '',
      endereco: map[colEnd] as String? ?? '',
      bairro: map[colBai] as String? ?? '',
      cdCidade: map[colCdCid] as int? ?? 0,
      cidade: map[colCid] as String? ?? '',
      uf: map[colUF] as String? ?? '',
      cep: map[colCep] as String? ?? '',
      refEntrega: map[colRefEnt] as String? ?? '',
      email: map[colEmail] as String? ?? '',
      fone: map[colFone] as String? ?? '',
      contato: map[colContato] as String? ?? '',
      idColabor: map[colRca] as int? ?? 0,
      idSegmento: map[colSeg] as int? ?? 0,
      idRota: map[colIdRota] as int? ?? 0,
      intinerario: map[colIntinerario] as int? ?? 0,
      idFpagamto: map[colFpa] as int? ?? 0,
      idPrazo: map[colPrazo] as int? ?? 0,
      tabela: map[colTabela] as int? ?? 0,
      situacao: map[colSituacao] as int? ?? 1,
      status: StatusCliente.fromValue(map[colStatus] as int? ?? 1),
      limite: (map[colLimite] as num?)?.toDouble() ?? 0,
      utilizado: (map[colUtilizado] as num?)?.toDouble() ?? 0,
      vlContrato: (map[colVlCtr] as num?)?.toDouble() ?? 0,
      tpContrato: map[colTpCtr] as int? ?? 0,
      ultCompra: map[colUltCompra] as String? ?? '',
      latitude: map[colLatitude] as String? ?? '',
      longitude: map[colLongitude] as String? ?? '',
      senhaWeb: map[colSenhaWeb] as String? ?? '',
      proxVisita: map[colProxVisita] as String? ?? '',
      motivo: map[colMotNPos] as int? ?? 0,
      sugestao: map[colSugestao] as int? ?? 1,
      dscPadrao: (map[colDscPadrao] as num?)?.toDouble() ?? 0,
      acrPadrao: (map[colAcrPadrao] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colId: codigo,
    colCnpj: cnpj,
    colIE: ie,
    colTipo: tipo,
    colNome: nome,
    colFantasia: fantasia,
    colEnd: endereco,
    colBai: bairro,
    colCdCid: cdCidade,
    colCid: cidade,
    colUF: uf,
    colCep: cep,
    colRefEnt: refEntrega,
    colEmail: email,
    colFone: fone,
    colContato: contato,
    colRca: idColabor,
    colSeg: idSegmento,
    colIdRota: idRota,
    colIntinerario: intinerario,
    colFpa: idFpagamto,
    colPrazo: idPrazo,
    colTabela: tabela,
    colSituacao: situacao,
    colStatus: status.value,
    colLimite: limite,
    colUtilizado: utilizado,
    colVlCtr: vlContrato,
    colTpCtr: tpContrato,
    colUltCompra: ultCompra,
    colLatitude: latitude,
    colLongitude: longitude,
    colSenhaWeb: senhaWeb,
    colProxVisita: proxVisita,
    colMotNPos: motivo,
    colSugestao: sugestao,
    colDscPadrao: dscPadrao,
    colAcrPadrao: acrPadrao,
  };

  @override
  String toString() => 'ClienteModel(codigo: $codigo, nome: $nome)';
}

class ClienteCoordendaModel {
  ClienteCoordendaModel({
    required this.codigo,
    required this.latitude,
    required this.longitude,
  });

  final int codigo;
  final String latitude;
  final String longitude;

  factory ClienteCoordendaModel.empty() =>
      ClienteCoordendaModel(codigo: 0, latitude: '', longitude: '');

  ClienteCoordendaModel copyWith({
    int? codigo,
    String? latitude,
    String? longitude,
  }) {
    return ClienteCoordendaModel(
      codigo: codigo ?? this.codigo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory ClienteCoordendaModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ClienteCoordendaModel.empty();
    return ClienteCoordendaModel(
      codigo: map['codigo'] as int? ?? 0,
      latitude: map['latitude'] as String? ?? '',
      longitude: map['longitude'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'codigo': codigo,
    'latitude': latitude,
    'longitude': longitude,
  };

  @override
  String toString() =>
      'ClienteCoordendaModel(codigo: $codigo, lat: $latitude, lng: $longitude)';
}
