import '../cadastro/fpagamento_model.dart';

class HSaida2Model {
  static const tblNome = 'hsaida2';

  static const colIdFilial = 'idfilial';
  static const colIdPrevenda = 'idprevenda';
  static const colParcela = 'parcela';
  static const colIdFPagamento = 'idfpagamento';
  static const colBancoCob = 'bancocob';
  static const colValor = 'valor';
  static const colVencimento = 'vencimento';
  static const colBandeira = 'bandeira';
  static const colAdministradora = 'administradora';
  static const colRede = 'rede';
  static const colNsu = 'nsu';
  static const colTipoTransacao = 'tipotransacao';
  static const colAutorizacao = 'autorizacao';
  static const colVlTroco = 'vl_troco';
  static const colStaPag = 'sta_pag';
  static const colNumCartao = 'num_cartao';
  static const colHs2PixId = 'hs2_pix_id';
  static const colFPagamento = 'fpagamento';

  HSaida2Model({
    required this.idFilial,
    required this.idPrevenda,
    required this.parcela,
    required this.idfpagamento,
    required this.bancoCob,
    required this.valor,
    required this.vencimento,
    required this.bandeira,
    required this.administradora,
    required this.rede,
    required this.nsu,
    required this.tipoTransacao,
    required this.autorizacao,
    required this.vlTroco,
    required this.staPag,
    required this.numCartao,
    required this.hs2PixId,
    required this.fpagamento,
  });

  // chave primária
  final int idFilial;
  final int idPrevenda;
  final int parcela;

  // pagamento
  final int idfpagamento;
  final int bancoCob;
  final double valor;
  final String vencimento;

  // cartão
  final int bandeira;
  final String administradora;
  final String rede;
  final String nsu;
  final String tipoTransacao;
  final String autorizacao;
  final String numCartao;

  // outros
  final double vlTroco;
  final int staPag;
  final String hs2PixId;

  // detalhes
  final FpagamentoModel fpagamento;

  factory HSaida2Model.empty() => HSaida2Model(
    idFilial: 0,
    idPrevenda: 0,
    parcela: 0,
    idfpagamento: 0,
    bancoCob: 0,
    valor: 0,
    vencimento: '',
    bandeira: 0,
    administradora: '',
    rede: '',
    nsu: '',
    tipoTransacao: '',
    autorizacao: '',
    vlTroco: 0,
    staPag: 0,
    numCartao: '',
    hs2PixId: '',
    fpagamento: FpagamentoModel.empty(),
  );

  HSaida2Model copyWith({
    int? idFilial,
    int? idPrevenda,
    int? parcela,
    int? idfpagamento,
    int? bancoCob,
    double? valor,
    String? vencimento,
    int? bandeira,
    String? administradora,
    String? rede,
    String? nsu,
    String? tipoTransacao,
    String? autorizacao,
    double? vlTroco,
    int? staPag,
    String? numCartao,
    String? hs2PixId,
    FpagamentoModel? fpagamento,
  }) {
    return HSaida2Model(
      idFilial: idFilial ?? this.idFilial,
      idPrevenda: idPrevenda ?? this.idPrevenda,
      parcela: parcela ?? this.parcela,
      idfpagamento: idfpagamento ?? this.idfpagamento,
      bancoCob: bancoCob ?? this.bancoCob,
      valor: valor ?? this.valor,
      vencimento: vencimento ?? this.vencimento,
      bandeira: bandeira ?? this.bandeira,
      administradora: administradora ?? this.administradora,
      rede: rede ?? this.rede,
      nsu: nsu ?? this.nsu,
      tipoTransacao: tipoTransacao ?? this.tipoTransacao,
      autorizacao: autorizacao ?? this.autorizacao,
      vlTroco: vlTroco ?? this.vlTroco,
      staPag: staPag ?? this.staPag,
      numCartao: numCartao ?? this.numCartao,
      hs2PixId: hs2PixId ?? this.hs2PixId,
      fpagamento: fpagamento ?? this.fpagamento,
    );
  }

  factory HSaida2Model.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return HSaida2Model.empty();
    return HSaida2Model(
      idFilial: map[colIdFilial] ?? 0,
      idPrevenda: map[colIdPrevenda] ?? 0,
      parcela: map[colParcela] ?? 0,
      idfpagamento: map[colIdFPagamento] ?? 0,
      bancoCob: map[colBancoCob] ?? 0,
      valor: (map[colValor] ?? 0).toDouble(),
      vencimento: map[colVencimento] ?? '',
      bandeira: map[colBandeira] ?? 0,
      administradora: map[colAdministradora] ?? '',
      rede: map[colRede] ?? '',
      nsu: map[colNsu] ?? '',
      tipoTransacao: map[colTipoTransacao] ?? '',
      autorizacao: map[colAutorizacao] ?? '',
      vlTroco: (map[colVlTroco] ?? 0).toDouble(),
      staPag: map[colStaPag] ?? 0,
      numCartao: map[colNumCartao] ?? '',
      hs2PixId: map[colHs2PixId] ?? '',
      fpagamento: map[colFPagamento] is Map<String, dynamic>
          ? FpagamentoModel.fromMap(map[colFPagamento] as Map<String, dynamic>)
          : FpagamentoModel.empty(),
    );
  }

  Map<String, dynamic> toMap() => {
    colIdFilial: idFilial,
    colIdPrevenda: idPrevenda,
    colParcela: parcela,
    colIdFPagamento: idfpagamento,
    colBancoCob: bancoCob,
    colValor: valor,
    colVencimento: vencimento,
    colBandeira: bandeira,
    colAdministradora: administradora,
    colRede: rede,
    colNsu: nsu,
    colTipoTransacao: tipoTransacao,
    colAutorizacao: autorizacao,
    colVlTroco: vlTroco,
    colStaPag: staPag,
    colNumCartao: numCartao,
    colHs2PixId: hs2PixId,
    colFPagamento: fpagamento.toMap(),
  };

  @override
  String toString() =>
      'HSaida2Model(loja: $idFilial, prevenda: $idPrevenda, parcela: $parcela, valor: $valor)';
}
