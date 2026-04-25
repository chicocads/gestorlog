class AuditoriaLogisticaModel {
  static const colCodigo = 'codigo';
  static const colNome = 'nome';
  static const colUndvenda = 'undvenda';
  static const colCodigoAlfa = 'codigoalfa';
  static const colDun14 = 'dun14';
  static const colLocalizacao = 'localizacao';
  static const colFator = 'fator';
  static const colQtEmbala = 'qtembala';
  static const colSaldo = 'saldo';
  static const colReserva = 'reserva';

  static const colWmsRua = 'wms_rua';
  static const colWmsBlc = 'wms_blc';
  static const colWmsMod = 'wms_mod';
  static const colWmsNiv = 'wms_niv';
  static const colWmsApt = 'wms_apt';

  static const colWmsRua2 = 'wms_rua2';
  static const colWmsBlc2 = 'wms_blc2';
  static const colWmsMod2 = 'wms_mod2';
  static const colWmsNiv2 = 'wms_niv2';
  static const colWmsApt2 = 'wms_apt2';

  static const colQtse = 'qtse';
  static const colQtcc = 'qtcc';
  static const colQtsc = 'qtsc';

  static const colLoteList = 'LoteList';

  AuditoriaLogisticaModel({
    required this.codigo,
    required this.nome,
    required this.undvenda,
    required this.codigoalfa,
    required this.dun14,
    required this.localizacao,
    required this.fator,
    required this.qtembala,
    required this.saldo,
    required this.reserva,
    required this.wmsrua,
    required this.wmsblc,
    required this.wmsmod,
    required this.wmsniv,
    required this.wmsapt,
    required this.wmsrua2,
    required this.wmsblc2,
    required this.wmsmod2,
    required this.wmsniv2,
    required this.wmsapt2,
    required this.qtse,
    required this.qtcc,
    required this.qtsc,
    required this.lotes,
  });

  final int codigo;
  final String nome;
  final String undvenda;
  final String codigoalfa;
  final String dun14;
  final String localizacao;
  final double fator;
  final int qtembala;
  final double saldo;
  final double reserva;
  final int wmsrua;
  final int wmsblc;
  final int wmsmod;
  final int wmsniv;
  final int wmsapt;
  final int wmsrua2;
  final int wmsblc2;
  final int wmsmod2;
  final int wmsniv2;
  final int wmsapt2;
  final double qtse;
  final double qtcc;
  final double qtsc;
  final List<AuditoriaLogisticaLoteModel> lotes;

  factory AuditoriaLogisticaModel.empty() => AuditoriaLogisticaModel(
    codigo: 0,
    nome: '',
    undvenda: '',
    codigoalfa: '',
    dun14: '',
    localizacao: '',
    fator: 0.0,
    qtembala: 0,
    saldo: 0.0,
    reserva: 0.0,
    wmsrua: 0,
    wmsblc: 0,
    wmsmod: 0,
    wmsniv: 0,
    wmsapt: 0,
    wmsrua2: 0,
    wmsblc2: 0,
    wmsmod2: 0,
    wmsniv2: 0,
    wmsapt2: 0,
    qtse: 0.0,
    qtcc: 0.0,
    qtsc: 0.0,
    lotes: const [],
  );

  AuditoriaLogisticaModel copyWith({
    int? codigo,
    String? nome,
    String? undvenda,
    String? codigoalfa,
    String? dun14,
    String? localizacao,
    double? fator,
    int? qtembala,
    double? saldo,
    double? reserva,
    int? wmsrua,
    int? wmsblc,
    int? wmsmod,
    int? wmsniv,
    int? wmsapt,
    int? wmsrua2,
    int? wmsblc2,
    int? wmsmod2,
    int? wmsniv2,
    int? wmsapt2,
    double? qtse,
    double? qtcc,
    double? qtsc,
    List<AuditoriaLogisticaLoteModel>? lotes,
  }) {
    return AuditoriaLogisticaModel(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      undvenda: undvenda ?? this.undvenda,
      codigoalfa: codigoalfa ?? this.codigoalfa,
      dun14: dun14 ?? this.dun14,
      localizacao: localizacao ?? this.localizacao,
      fator: fator ?? this.fator,
      qtembala: qtembala ?? this.qtembala,
      saldo: saldo ?? this.saldo,
      reserva: reserva ?? this.reserva,
      wmsrua: wmsrua ?? this.wmsrua,
      wmsblc: wmsblc ?? this.wmsblc,
      wmsmod: wmsmod ?? this.wmsmod,
      wmsniv: wmsniv ?? this.wmsniv,
      wmsapt: wmsapt ?? this.wmsapt,
      wmsrua2: wmsrua2 ?? this.wmsrua2,
      wmsblc2: wmsblc2 ?? this.wmsblc2,
      wmsmod2: wmsmod2 ?? this.wmsmod2,
      wmsniv2: wmsniv2 ?? this.wmsniv2,
      wmsapt2: wmsapt2 ?? this.wmsapt2,
      qtse: qtse ?? this.qtse,
      qtcc: qtcc ?? this.qtcc,
      qtsc: qtsc ?? this.qtsc,
      lotes: lotes ?? this.lotes,
    );
  }

  static int _asInt(dynamic value) => (value as num?)?.toInt() ?? 0;
  static double _asDouble(dynamic value) => (value as num?)?.toDouble() ?? 0.0;

  factory AuditoriaLogisticaModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return AuditoriaLogisticaModel.empty();

    final rawLotes =
        map[colLoteList] ??
        map['loteList'] ??
        map['lotes'] ??
        map['lote_list'] ??
        map['Lotes'];
    final lotes = (rawLotes is List)
        ? rawLotes
            .whereType<Map<String, dynamic>>()
            .map(AuditoriaLogisticaLoteModel.fromMap)
            .toList()
        : <AuditoriaLogisticaLoteModel>[];

    return AuditoriaLogisticaModel(
      codigo: _asInt(map[colCodigo]),
      nome: map[colNome] as String? ?? '',
      undvenda: map[colUndvenda] as String? ?? '',
      codigoalfa: map[colCodigoAlfa] as String? ?? '',
      dun14: map[colDun14] as String? ?? '',
      localizacao: map[colLocalizacao] as String? ?? '',
      fator: _asDouble(map[colFator]),
      qtembala: _asInt(map[colQtEmbala] ?? map['qtemb'] ?? map['qtembala']),
      saldo: _asDouble(map[colSaldo]),
      reserva: _asDouble(map[colReserva]),
      wmsrua: _asInt(map[colWmsRua] ?? map['wmsrua']),
      wmsblc: _asInt(map[colWmsBlc] ?? map['wmsblc']),
      wmsmod: _asInt(map[colWmsMod] ?? map['wmsmod']),
      wmsniv: _asInt(map[colWmsNiv] ?? map['wmsniv']),
      wmsapt: _asInt(map[colWmsApt] ?? map['wmsapt']),
      wmsrua2: _asInt(map[colWmsRua2] ?? map['wmsrua2']),
      wmsblc2: _asInt(map[colWmsBlc2] ?? map['wmsblc2']),
      wmsmod2: _asInt(map[colWmsMod2] ?? map['wmsmod2']),
      wmsniv2: _asInt(map[colWmsNiv2] ?? map['wmsniv2']),
      wmsapt2: _asInt(map[colWmsApt2] ?? map['wmsapt2']),
      qtse: _asDouble(map[colQtse]),
      qtcc: _asDouble(map[colQtcc]),
      qtsc: _asDouble(map[colQtsc]),
      lotes: lotes,
    );
  }

  Map<String, dynamic> toMap() => {
    colCodigo: codigo,
    colNome: nome,
    colUndvenda: undvenda,
    colCodigoAlfa: codigoalfa,
    colDun14: dun14,
    colLocalizacao: localizacao,
    colFator: fator,
    colQtEmbala: qtembala,
    colSaldo: saldo,
    colReserva: reserva,
    colWmsRua: wmsrua,
    colWmsBlc: wmsblc,
    colWmsMod: wmsmod,
    colWmsNiv: wmsniv,
    colWmsApt: wmsapt,
    colWmsRua2: wmsrua2,
    colWmsBlc2: wmsblc2,
    colWmsMod2: wmsmod2,
    colWmsNiv2: wmsniv2,
    colWmsApt2: wmsapt2,
    colQtse: qtse,
    colQtcc: qtcc,
    colQtsc: qtsc,
    colLoteList: lotes.map((e) => e.toMap()).toList(),
  };

  @override
  String toString() => '$codigo - $nome';
}

class AuditoriaLogisticaLoteModel {
  static const colLoja = 'loja';
  static const colProduto = 'produto';
  static const colLote = 'lote';
  static const colFabricacao = 'fabricacao';
  static const colValidade = 'validade';
  static const colSaldo = 'saldo';

  AuditoriaLogisticaLoteModel({
    required this.idFilial,
    required this.idProduto,
    required this.lote,
    required this.fabricacao,
    required this.validade,
    required this.saldo,
  });

  final int idFilial;
  final int idProduto;
  final String lote;
  final String fabricacao;
  final String validade; 
  final double saldo;

  factory AuditoriaLogisticaLoteModel.empty() => AuditoriaLogisticaLoteModel(
    idFilial: 0,
    idProduto: 0,
    lote: '',
    fabricacao: '',
    validade: '',
    saldo: 0.0,
  );

  AuditoriaLogisticaLoteModel copyWith({
    int? idFilial,
    int? idProduto,
    String? lote,
    String? fabricacao,
    String? validade,
    double? saldo,
  }) {
    return AuditoriaLogisticaLoteModel(
      idFilial: idFilial ?? this.idFilial,
      idProduto: idProduto ?? this.idProduto,
      lote: lote ?? this.lote,
      fabricacao: fabricacao ?? this.fabricacao,
      validade: validade ?? this.validade,
      saldo: saldo ?? this.saldo,
    );
  }

  factory AuditoriaLogisticaLoteModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return AuditoriaLogisticaLoteModel.empty();

    final rawFabricacao = map[colFabricacao];
    String fabricacao;
    if (rawFabricacao is String) {
      fabricacao = rawFabricacao;
    } else if (rawFabricacao is DateTime) {
      fabricacao = rawFabricacao.toIso8601String();
    } else {
      fabricacao = rawFabricacao?.toString() ?? '';
    }

    final rawValidade = map[colValidade];
    String validade;
    if (rawValidade is String) {
      validade = rawValidade;
    } else if (rawValidade is DateTime) {
      validade = rawValidade.toIso8601String();
    } else {
      validade = rawValidade?.toString() ?? '';
    }

    return AuditoriaLogisticaLoteModel(
      idFilial: (map[colLoja] as num?)?.toInt() ?? 0,
      idProduto: (map[colProduto] as num?)?.toInt() ?? 0,
      lote: map[colLote] as String? ?? '',
      fabricacao: fabricacao,
      validade: validade,
      saldo: (map[colSaldo] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() => {
    colLoja: idFilial,
    colProduto: idProduto,
    colLote: lote,
    colFabricacao: fabricacao,
    colValidade: validade,
    colSaldo: saldo,
  };
}
