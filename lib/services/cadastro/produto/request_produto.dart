class RequestProduto {
  static const colPaginaAtual = 'paginaAtual';
  static const colQtdTotal = 'qtdTotal';
  static const colIdFilial = 'idFilial';
  static const colCodigo = 'codigo';
  static const colNome = 'nome';
  static const colCodigoAlfa = 'codigoalfa';
  static const colDun14 = 'dun14';
  static const colMarca = 'marca';
  static const colDataBusca = 'dataBusca';
  static const colDepart = 'departamento';
  static const colSecao = 'secao';
  static const colGrupo = 'grupo';
  static const colSGrupo = 'sgrupo';
  static const colFornecedor = 'fornecedor';
  static const colRca = 'rca';
  static const colEquipe = 'equipe';
  static const colConsumo = 'consumo';
  static const colSituacao = 'situacao';
  static const colSaldo = 'saldo';
  static const colVendaWeb = 'vendaweb';
  static const colComImagem = 'comImagem';

  RequestProduto({
    required this.paginaAtual,
    required this.qtdTotal,
    required this.idFilial,
    required this.codigo,
    required this.nome,
    required this.codigoalfa,
    required this.dun14,
    required this.marca,
    required this.dataBusca,
    required this.departamento,
    required this.secao,
    required this.grupo,
    required this.sgrupo,
    required this.fornecedor,
    required this.rca,
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
  final String dataBusca;
  final int departamento;
  final int secao;
  final int grupo;
  final int sgrupo;
  final int fornecedor;
  final int rca;
  final int equipe;
  final int consumo;
  final int situacao;
  final int saldo;
  final int vendaWeb;
  final int comImagem;

  factory RequestProduto.empty() => RequestProduto(
    paginaAtual: '1',
    qtdTotal: '50',
    idFilial: 0,
    codigo: 0,
    nome: '',
    codigoalfa: '',
    dun14: '',
    marca: '',
    dataBusca: '',
    departamento: 0,
    secao: 0,
    grupo: 0,
    sgrupo: 0,
    fornecedor: 0,
    rca: 0,
    equipe: 0,
    consumo: 0,
    situacao: 2,
    saldo: 2,
    vendaWeb: 2,
    comImagem: 1,
  );

  RequestProduto copyWith({
    String? paginaAtual,
    String? qtdTotal,
    int? idFilial,
    int? codigo,
    String? nome,
    String? codigoalfa,
    String? dun14,
    String? marca,
    String? dataBusca,
    int? departamento,
    int? secao,
    int? grupo,
    int? sgrupo,
    int? fornecedor,
    int? rca,
    int? equipe,
    int? consumo,
    int? situacao,
    int? saldo,
    int? vendaWeb,
    int? comImagem,
  }) {
    return RequestProduto(
      paginaAtual: paginaAtual ?? this.paginaAtual,
      qtdTotal: qtdTotal ?? this.qtdTotal,
      idFilial: idFilial ?? this.idFilial,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      codigoalfa: codigoalfa ?? this.codigoalfa,
      dun14: dun14 ?? this.dun14,
      marca: marca ?? this.marca,
      dataBusca: dataBusca ?? this.dataBusca,
      departamento: departamento ?? this.departamento,
      secao: secao ?? this.secao,
      grupo: grupo ?? this.grupo,
      sgrupo: sgrupo ?? this.sgrupo,
      fornecedor: fornecedor ?? this.fornecedor,
      rca: rca ?? this.rca,
      equipe: equipe ?? this.equipe,
      consumo: consumo ?? this.consumo,
      situacao: situacao ?? this.situacao,
      saldo: saldo ?? this.saldo,
      vendaWeb: vendaWeb ?? this.vendaWeb,
      comImagem: comImagem ?? this.comImagem,
    );
  }

  factory RequestProduto.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestProduto.empty();
    return RequestProduto(
      paginaAtual: map[colPaginaAtual] as String? ?? '0',
      qtdTotal: map[colQtdTotal] as String? ?? '0',
      idFilial: map[colIdFilial] as int? ?? 1,
      codigo: map[colCodigo] as int? ?? 0,
      nome: map[colNome] as String? ?? '',
      codigoalfa: map[colCodigoAlfa] as String? ?? '',
      dun14: map[colDun14] as String? ?? '',
      marca: map[colMarca] as String? ?? '',
      dataBusca: map[colDataBusca] as String? ?? '',
      departamento: map[colDepart] as int? ?? 0,
      secao: map[colSecao] as int? ?? 0,
      grupo: map[colGrupo] as int? ?? 0,
      sgrupo: map[colSGrupo] as int? ?? 0,
      fornecedor: map[colFornecedor] as int? ?? 0,
      rca: map[colRca] as int? ?? 0,
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
    colDataBusca: dataBusca,
    colDepart: departamento,
    colSecao: secao,
    colGrupo: grupo,
    colSGrupo: sgrupo,
    colFornecedor: fornecedor,
    colRca: rca,
    colEquipe: equipe,
    colConsumo: consumo,
    colSituacao: situacao,
    colSaldo: saldo,
    colVendaWeb: vendaWeb,
    colComImagem: comImagem,
  };
}
