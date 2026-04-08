class ProdutoModel {
  static const tblNome = 'produto';
  static const colCodigo = 'codigo';
  static const colCodigoAlfa = 'codigoalfa';
  static const colDun14 = 'dun14';
  static const colNome = 'nome';
  static const colUnd = 'undvenda';
  static const colLocaliza = 'localizacao';
  static const colWmsmod = 'wms_mod';
  static const colWmsrua = 'wms_rua';
  static const colWmsblc = 'wms_blc';
  static const colWmsniv = 'wms_niv';
  static const colWmsapt = 'wms_apt';
  static const colWmsgvt = 'wms_gvt';
  static const colSecao = 'secao';
  static const colGrupo = 'grupo';
  static const colSgrupo = 'sgrupo';
  static const colFornecedor = 'fornecedor';
  static const colPrecoVenda = 'precovenda';
  static const colPrecoVenda2 = 'precovenda2';
  static const colPrecoVenda3 = 'precovenda3';
  static const colPrecoVenda4 = 'precovenda4';
  static const colPrecoVenda5 = 'precovenda5';
  static const colPrecoVenda6 = 'precovenda6';
  static const colPrecoVenda7 = 'precovenda7';
  static const colDescv = 'descontov';
  static const colSaldo = 'saldo';
  static const colReserva = 'reserva';
  static const colFator = 'fator';
  static const colQtEmbala = 'qtembala';
  static const colQtAtacado = 'qtatacado';
  static const colMarca = 'marca';
  static const colRefer = 'referencia';
  static const colCaracter = 'caracteristicas';
  static const colConsumo = 'consumo';
  static const colSituacao = 'situacao';
  static const colTabWeb = 'tabweb';
  static const colCst = 'cst';
  static const colImagem = 'imagem';

  ProdutoModel({
    required this.codigo,
    required this.codigoalfa,
    required this.dun14,
    required this.nome,
    required this.undvenda,
    required this.localizacao,
    required this.wmsmod,
    required this.wmsrua,
    required this.wmsblc,
    required this.wmsniv,
    required this.wmsapt,
    required this.wmsgvt,
    required this.secao,
    required this.grupo,
    required this.sgrupo,
    required this.fornecedor,
    required this.precovenda,
    required this.precovenda2,
    required this.precovenda3,
    required this.precovenda4,
    required this.precovenda5,
    required this.precovenda6,
    required this.precovenda7,
    required this.descontov,
    required this.saldo,
    required this.reserva,
    required this.fator,
    required this.qtembala,
    required this.qtatacado,
    required this.marca,
    required this.referencia,
    required this.caracteristicas,
    required this.consumo,
    required this.situacao,
    required this.tabweb,
    required this.cst,
    required this.imagem,
  });

  final int codigo;
  final String codigoalfa;
  final String dun14;
  final String nome;
  final String undvenda;
  final String localizacao;
  final int wmsmod;
  final int wmsrua;
  final int wmsblc;
  final int wmsniv;
  final int wmsapt;
  final int wmsgvt;
  final int secao;
  final int grupo;
  final int sgrupo;
  final int fornecedor;
  final double precovenda;
  final double precovenda2;
  final double precovenda3;
  final double precovenda4;
  final double precovenda5;
  final double precovenda6;
  final double precovenda7;
  final double descontov;
  final double saldo;
  final double reserva;
  final double fator;
  final int qtembala;
  final double qtatacado;
  final String marca;
  final String referencia;
  final String caracteristicas;
  final int consumo;
  final int situacao;
  final int tabweb;
  final String cst;
  final String imagem;

  factory ProdutoModel.empty() => ProdutoModel(
    codigo: 0,
    codigoalfa: '',
    dun14: '',
    nome: '',
    undvenda: '',
    localizacao: '',
    wmsmod: 0,
    wmsrua: 0,
    wmsblc: 0,
    wmsniv: 0,
    wmsapt: 0,
    wmsgvt: 0,
    secao: 0,
    grupo: 0,
    sgrupo: 0,
    fornecedor: 0,
    precovenda: 0,
    precovenda2: 0,
    precovenda3: 0,
    precovenda4: 0,
    precovenda5: 0,
    precovenda6: 0,
    precovenda7: 0,
    descontov: 0,
    saldo: 0,
    reserva: 0,
    fator: 1,
    qtembala: 0,
    qtatacado: 0,
    marca: '',
    referencia: '',
    caracteristicas: '',
    consumo: 0,
    situacao: 0,
    tabweb: 0,
    cst: '',
    imagem: '',
  );

  ProdutoModel copyWith({
    int? codigo,
    String? codigoalfa,
    String? dun14,
    String? nome,
    String? undvenda,
    String? localizacao,
    int? wmsmod,
    int? wmsrua,
    int? wmsblc,
    int? wmsniv,
    int? wmsapt,
    int? wmsgvt,
    int? secao,
    int? grupo,
    int? sgrupo,
    int? fornecedor,
    double? precovenda,
    double? precovenda2,
    double? precovenda3,
    double? precovenda4,
    double? precovenda5,
    double? precovenda6,
    double? precovenda7,
    double? descontov,
    double? saldo,
    double? reserva,
    double? fator,
    int? qtembala,
    double? qtatacado,
    String? marca,
    String? referencia,
    String? caracteristicas,
    int? consumo,
    int? situacao,
    int? tabweb,
    String? cst,
    String? imagem,
  }) {
    return ProdutoModel(
      codigo: codigo ?? this.codigo,
      codigoalfa: codigoalfa ?? this.codigoalfa,
      dun14: dun14 ?? this.dun14,
      nome: nome ?? this.nome,
      undvenda: undvenda ?? this.undvenda,
      localizacao: localizacao ?? this.localizacao,
      wmsmod: wmsmod ?? this.wmsmod,
      wmsrua: wmsrua ?? this.wmsrua,
      wmsblc: wmsblc ?? this.wmsblc,
      wmsniv: wmsniv ?? this.wmsniv,
      wmsapt: wmsapt ?? this.wmsapt,
      wmsgvt: wmsgvt ?? this.wmsgvt,
      secao: secao ?? this.secao,
      grupo: grupo ?? this.grupo,
      sgrupo: sgrupo ?? this.sgrupo,
      fornecedor: fornecedor ?? this.fornecedor,
      precovenda: precovenda ?? this.precovenda,
      precovenda2: precovenda2 ?? this.precovenda2,
      precovenda3: precovenda3 ?? this.precovenda3,
      precovenda4: precovenda4 ?? this.precovenda4,
      precovenda5: precovenda5 ?? this.precovenda5,
      precovenda6: precovenda6 ?? this.precovenda6,
      precovenda7: precovenda7 ?? this.precovenda7,
      descontov: descontov ?? this.descontov,
      saldo: saldo ?? this.saldo,
      reserva: reserva ?? this.reserva,
      fator: fator ?? this.fator,
      qtembala: qtembala ?? this.qtembala,
      qtatacado: qtatacado ?? this.qtatacado,
      marca: marca ?? this.marca,
      referencia: referencia ?? this.referencia,
      caracteristicas: caracteristicas ?? this.caracteristicas,
      consumo: consumo ?? this.consumo,
      situacao: situacao ?? this.situacao,
      tabweb: tabweb ?? this.tabweb,
      cst: cst ?? this.cst,
      imagem: imagem ?? this.imagem,
    );
  }

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ProdutoModel.empty();
    final imagemRaw = (map[colImagem] ?? '').toString();
    return ProdutoModel(
      codigo: map[colCodigo] as int? ?? 0,
      codigoalfa: map[colCodigoAlfa] as String? ?? '',
      dun14: map[colDun14] as String? ?? '',
      nome: (map[colNome] ?? '').toString().replaceAll('"', ' '),
      undvenda: map[colUnd] as String? ?? '',
      localizacao: map[colLocaliza] as String? ?? '',
      wmsmod: map[colWmsmod] as int? ?? 0,
      wmsrua: map[colWmsrua] as int? ?? 0,
      wmsblc: map[colWmsblc] as int? ?? 0,
      wmsniv: map[colWmsniv] as int? ?? 0,
      wmsapt: map[colWmsapt] as int? ?? 0,
      wmsgvt: map[colWmsgvt] as int? ?? 0,
      secao: map[colSecao] as int? ?? 0,
      grupo: map[colGrupo] as int? ?? 0,
      sgrupo: map[colSgrupo] as int? ?? 0,
      fornecedor: map[colFornecedor] as int? ?? 0,
      precovenda: (map[colPrecoVenda] as num?)?.toDouble() ?? 0,
      precovenda2: (map[colPrecoVenda2] as num?)?.toDouble() ?? 0,
      precovenda3: (map[colPrecoVenda3] as num?)?.toDouble() ?? 0,
      precovenda4: (map[colPrecoVenda4] as num?)?.toDouble() ?? 0,
      precovenda5: (map[colPrecoVenda5] as num?)?.toDouble() ?? 0,
      precovenda6: (map[colPrecoVenda6] as num?)?.toDouble() ?? 0,
      precovenda7: (map[colPrecoVenda7] as num?)?.toDouble() ?? 0,
      descontov: (map[colDescv] as num?)?.toDouble() ?? 0,
      saldo: (map[colSaldo] as num?)?.toDouble() ?? 0,
      reserva: (map[colReserva] as num?)?.toDouble() ?? 0,
      fator: (map[colFator] as num?)?.toDouble() ?? 1,
      qtembala: map[colQtEmbala] as int? ?? 0,
      qtatacado: (map[colQtAtacado] as num?)?.toDouble() ?? 0,
      marca: map[colMarca] as String? ?? '',
      referencia: map[colRefer] as String? ?? '',
      caracteristicas: (map[colCaracter] ?? '').toString().replaceAll(
        RegExp('\r\n'),
        '',
      ),
      consumo: map[colConsumo] as int? ?? 0,
      situacao: map[colSituacao] as int? ?? 0,
      tabweb: map[colTabWeb] as int? ?? 0,
      cst: map[colCst] as String? ?? '000',
      imagem: imagemRaw.replaceAll(imagemRaw.length < 100 ? 'MA==' : '', ''),
    );
  }

  Map<String, dynamic> toMap() => {
    colCodigo: codigo,
    colCodigoAlfa: codigoalfa,
    colDun14: dun14,
    colNome: nome,
    colUnd: undvenda,
    colLocaliza: localizacao,
    colWmsmod: wmsmod,
    colWmsrua: wmsrua,
    colWmsblc: wmsblc,
    colWmsniv: wmsniv,
    colWmsapt: wmsapt,
    colWmsgvt: wmsgvt,
    colSecao: secao,
    colGrupo: grupo,
    colSgrupo: sgrupo,
    colFornecedor: fornecedor,
    colPrecoVenda: precovenda,
    colPrecoVenda2: precovenda2,
    colPrecoVenda3: precovenda3,
    colPrecoVenda4: precovenda4,
    colPrecoVenda5: precovenda5,
    colPrecoVenda6: precovenda6,
    colPrecoVenda7: precovenda7,
    colDescv: descontov,
    colSaldo: saldo,
    colReserva: reserva,
    colFator: fator,
    colQtEmbala: qtembala,
    colQtAtacado: qtatacado,
    colMarca: marca,
    colRefer: referencia,
    colCaracter: caracteristicas,
    colConsumo: consumo,
    colSituacao: situacao,
    colTabWeb: tabweb,
    colCst: cst,
    colImagem: imagem,
  };

  @override
  String toString() => 'ProdutoModel(codigo: $codigo, nome: $nome)';
}

enum TabelaPreco {
  libarado(0),
  preco1(1),
  preco2(2),
  preco3(3),
  preco4(4),
  preco5(5),
  preco6(6),
  preco7(7);

  final num value;
  const TabelaPreco(this.value);
}

class RequestProdutoModel {
  static const colPaginaAtual = 'paginaAtual';
  static const colQtdTotal = 'qtdTotal';
  static const colIdFilial = 'idFilial';
  static const colCodigo = 'codigo';
  static const colNome = 'nome';
  static const colCodigoAlfa = 'codigoalfa';
  static const colDun14 = 'dun14';
  static const colMarca = 'marca';
  static const colDepart = 'departamento';
  static const colSecao = 'secao';
  static const colGrupo = 'grupo';
  static const colSGrupo = 'sgrupo';
  static const colFornecedor = 'fornecedor';
  static const colEquipe = 'equipe';
  static const colConsumo = 'consumo';
  static const colSituacao = 'situacao';
  static const colSaldo = 'saldo';
  static const colVendaWeb = 'vendaweb';
  static const colComImagem = 'comImagem';

  RequestProdutoModel({
    required this.paginaAtual,
    required this.qtdTotal,
    required this.idFilial,
    required this.codigo,
    required this.nome,
    required this.codigoalfa,
    required this.dun14,
    required this.marca,
    required this.departamento,
    required this.secao,
    required this.grupo,
    required this.sgrupo,
    required this.fornecedor,
    required this.equipe,
    required this.consumo,
    required this.situacao,
    required this.saldo,
    required this.vendaWeb,
    required this.comImagem,
  });

  final String paginaAtual;
  final String qtdTotal;
  final int idFilial;
  final int codigo;
  final String nome;
  final String codigoalfa;
  final String dun14;
  final String marca;
  final int departamento;
  final int secao;
  final int grupo;
  final int sgrupo;
  final int fornecedor;
  final int equipe;
  final int consumo;
  final int situacao;
  final int saldo;
  final int vendaWeb;
  final int comImagem;

  factory RequestProdutoModel.empty(int idFilial) => RequestProdutoModel(
    paginaAtual: '0',
    qtdTotal: '0',
    idFilial: idFilial,
    codigo: 0,
    nome: '',
    codigoalfa: '',
    dun14: '',
    marca: '',
    departamento: 0,
    secao: 0,
    grupo: 0,
    sgrupo: 0,
    fornecedor: 0,
    equipe: 0,
    consumo: 0,
    situacao: 0,
    saldo: 0,
    vendaWeb: 2,
    comImagem: 0,
  );

  RequestProdutoModel copyWith({
    String? paginaAtual,
    String? qtdTotal,
    int? idFilial,
    int? codigo,
    String? nome,
    String? codigoalfa,
    String? dun14,
    String? marca,
    int? departamento,
    int? secao,
    int? grupo,
    int? sgrupo,
    int? fornecedor,
    int? equipe,
    int? consumo,
    int? situacao,
    int? saldo,
    int? vendaWeb,
    int? comImagem,
  }) {
    return RequestProdutoModel(
      paginaAtual: paginaAtual ?? this.paginaAtual,
      qtdTotal: qtdTotal ?? this.qtdTotal,
      idFilial: idFilial ?? this.idFilial,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      codigoalfa: codigoalfa ?? this.codigoalfa,
      dun14: dun14 ?? this.dun14,
      marca: marca ?? this.marca,
      departamento: departamento ?? this.departamento,
      secao: secao ?? this.secao,
      grupo: grupo ?? this.grupo,
      sgrupo: sgrupo ?? this.sgrupo,
      fornecedor: fornecedor ?? this.fornecedor,
      equipe: equipe ?? this.equipe,
      consumo: consumo ?? this.consumo,
      situacao: situacao ?? this.situacao,
      saldo: saldo ?? this.saldo,
      vendaWeb: vendaWeb ?? this.vendaWeb,
      comImagem: comImagem ?? this.comImagem,
    );
  }

  factory RequestProdutoModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestProdutoModel.empty(0);
    return RequestProdutoModel(
      paginaAtual: map[colPaginaAtual] as String? ?? '0',
      qtdTotal: map[colQtdTotal] as String? ?? '0',
      idFilial: map[colIdFilial] as int? ?? 1,
      codigo: map[colCodigo] as int? ?? 0,
      nome: map[colNome] as String? ?? '',
      codigoalfa: map[colCodigoAlfa] as String? ?? '',
      dun14: map[colDun14] as String? ?? '',
      marca: map[colMarca] as String? ?? '',
      departamento: map[colDepart] as int? ?? 0,
      secao: map[colSecao] as int? ?? 0,
      grupo: map[colGrupo] as int? ?? 0,
      sgrupo: map[colSGrupo] as int? ?? 0,
      fornecedor: map[colFornecedor] as int? ?? 0,
      equipe: map[colEquipe] as int? ?? 0,
      consumo: map[colConsumo] as int? ?? 0,
      situacao: map[colSituacao] as int? ?? 1,
      saldo: map[colSaldo] as int? ?? 1,
      vendaWeb: map[colVendaWeb] as int? ?? 2,
      comImagem: map[colComImagem] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colPaginaAtual: paginaAtual,
    colQtdTotal: qtdTotal,
    colIdFilial: idFilial,
    colCodigo: codigo,
    colNome: nome,
    colCodigoAlfa: codigoalfa,
    colDun14: dun14,
    colMarca: marca,
    colDepart: departamento,
    colSecao: secao,
    colGrupo: grupo,
    colSGrupo: sgrupo,
    colFornecedor: fornecedor,
    colEquipe: equipe,
    colConsumo: consumo,
    colSituacao: situacao,
    colSaldo: saldo,
    colVendaWeb: vendaWeb,
    colComImagem: comImagem,
  };

  @override
  String toString() =>
      'RequestProdutoModel(nome: $nome, pagina: $paginaAtual/$qtdTotal)';
}

class ResponseProdutoModel {
  ResponseProdutoModel({
    required this.itens,
    required this.paginaAtual,
    required this.proximaPagina,
    required this.qtdPaginas,
  });

  final List<ProdutoModel> itens;
  final int paginaAtual;
  final int proximaPagina;
  final int qtdPaginas;

  factory ResponseProdutoModel.empty() => ResponseProdutoModel(
    itens: [],
    paginaAtual: 1,
    proximaPagina: 1,
    qtdPaginas: 1,
  );

  factory ResponseProdutoModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ResponseProdutoModel.empty();
    return ResponseProdutoModel(
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map((e) => ProdutoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      paginaAtual: map['paginaAtual'] as int? ?? 1,
      proximaPagina: map['proximaPagina'] as int? ?? 1,
      qtdPaginas: map['qtdPaginas'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toMap() => {
    'itens': itens.map((e) => e.toMap()).toList(),
    'paginaAtual': paginaAtual,
    'proximaPagina': proximaPagina,
    'qtdPaginas': qtdPaginas,
  };

  @override
  String toString() =>
      'ResponseProdutoModel(itens: ${itens.length}, pagina: $paginaAtual/$qtdPaginas)';
}
