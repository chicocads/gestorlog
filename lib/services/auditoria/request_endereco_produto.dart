class RequestAlterarEnderecoProduto {
  static const colCodigoAlfa = 'codigoalfa';
  static const colDun14 = 'dun14';
  static const colLocalizacao = 'localizacao';
  static const colWmsRua = 'wmsrua';
  static const colWmsBlc = 'wmsblc';
  static const colWmsMod = 'wmsmod';
  static const colWmsNiv = 'wmsniv';
  static const colWmsApt = 'wmsapt';
  static const colWmsGvt = 'wmsgvt';
  static const colWmsRua2 = 'wmsrua2';
  static const colWmsBlc2 = 'wmsblc2';
  static const colWmsMod2 = 'wmsmod2';
  static const colWmsNiv2 = 'wmsniv2';
  static const colWmsApt2 = 'wmsapt2';
  static const colWmsGvt2 = 'wmsgvt2';

  RequestAlterarEnderecoProduto({
    required this.codigoalfa,
    required this.dun14,
    required this.localizacao,
    required this.wmsrua,
    required this.wmsblc,
    required this.wmsmod,
    required this.wmsniv,
    required this.wmsapt,
    required this.wmsgvt,
    required this.wmsrua2,
    required this.wmsblc2,
    required this.wmsmod2,
    required this.wmsniv2,
    required this.wmsapt2,
    required this.wmsgvt2,
  });

  final String codigoalfa;
  final String dun14;
  final String localizacao;
  final int wmsrua;
  final int wmsblc;
  final int wmsmod;
  final int wmsniv;
  final int wmsapt;
  final int wmsgvt;
  final int wmsrua2;
  final int wmsblc2;
  final int wmsmod2;
  final int wmsniv2;
  final int wmsapt2;
  final int wmsgvt2;

  factory RequestAlterarEnderecoProduto.empty() => RequestAlterarEnderecoProduto(
    codigoalfa: '',
    dun14: '',
    localizacao: '',
    wmsrua: 0,
    wmsblc: 0,
    wmsmod: 0,
    wmsniv: 0,
    wmsapt: 0,
    wmsgvt: 0,
    wmsrua2: 0,
    wmsblc2: 0,
    wmsmod2: 0,
    wmsniv2: 0,
    wmsapt2: 0,
    wmsgvt2: 0,
  );

  RequestAlterarEnderecoProduto copyWith({
    String? codigoalfa,
    String? dun14,
    String? localizacao,
    int? wmsrua,
    int? wmsblc,
    int? wmsmod,
    int? wmsniv,
    int? wmsapt,
    int? wmsgvt,
    int? wmsrua2,
    int? wmsblc2,
    int? wmsmod2,
    int? wmsniv2,
    int? wmsapt2,
    int? wmsgvt2,
  }) {
    return RequestAlterarEnderecoProduto(
      codigoalfa: codigoalfa ?? this.codigoalfa,
      dun14: dun14 ?? this.dun14,
      localizacao: localizacao ?? this.localizacao,
      wmsrua: wmsrua ?? this.wmsrua,
      wmsblc: wmsblc ?? this.wmsblc,
      wmsmod: wmsmod ?? this.wmsmod,
      wmsniv: wmsniv ?? this.wmsniv,
      wmsapt: wmsapt ?? this.wmsapt,
      wmsgvt: wmsgvt ?? this.wmsgvt,
      wmsrua2: wmsrua2 ?? this.wmsrua2,
      wmsblc2: wmsblc2 ?? this.wmsblc2,
      wmsmod2: wmsmod2 ?? this.wmsmod2,
      wmsniv2: wmsniv2 ?? this.wmsniv2,
      wmsapt2: wmsapt2 ?? this.wmsapt2,
      wmsgvt2: wmsgvt2 ?? this.wmsgvt2,
    );
  }

  factory RequestAlterarEnderecoProduto.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestAlterarEnderecoProduto.empty();
    return RequestAlterarEnderecoProduto(
      codigoalfa: map[colCodigoAlfa] as String? ?? '',
      dun14: map[colDun14] as String? ?? '',
      localizacao: map[colLocalizacao] as String? ?? '',
      wmsrua: map[colWmsRua] as int? ?? 0,
      wmsblc: map[colWmsBlc] as int? ?? 0,
      wmsmod: map[colWmsMod] as int? ?? 0,
      wmsniv: map[colWmsNiv] as int? ?? 0,
      wmsapt: map[colWmsApt] as int? ?? 0,
      wmsgvt: map[colWmsGvt] as int? ?? 0,
      wmsrua2: map[colWmsRua2] as int? ?? 0,
      wmsblc2: map[colWmsBlc2] as int? ?? 0,
      wmsmod2: map[colWmsMod2] as int? ?? 0,
      wmsniv2: map[colWmsNiv2] as int? ?? 0,
      wmsapt2: map[colWmsApt2] as int? ?? 0,
      wmsgvt2: map[colWmsGvt2] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colCodigoAlfa: codigoalfa,
    colDun14: dun14,
    colLocalizacao: localizacao,
    colWmsRua: wmsrua,
    colWmsBlc: wmsblc,
    colWmsMod: wmsmod,
    colWmsNiv: wmsniv,
    colWmsApt: wmsapt,
    colWmsGvt: wmsgvt,
    colWmsRua2: wmsrua2,
    colWmsBlc2: wmsblc2,
    colWmsMod2: wmsmod2,
    colWmsNiv2: wmsniv2,
    colWmsApt2: wmsapt2,
    colWmsGvt2: wmsgvt2,
  };
}
