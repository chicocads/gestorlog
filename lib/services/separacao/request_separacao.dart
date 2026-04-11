import '../../models/lote_saida_model.dart';

class RequestSeparacaoItem {
  static const colOrdem = 'ordem';
  static const colIdProduto = 'idproduto';
  static const colQtdeSep = 'qtdesep';
  static const colLoteSaida = 'lotesaida';

  RequestSeparacaoItem({
    required this.ordem,
    required this.idproduto,
    required this.qtdesep,
    this.lotesaida = const [],
  });

  final int ordem;
  final int idproduto;
  final double qtdesep;
  final List<LoteSaidaModel> lotesaida;

  factory RequestSeparacaoItem.fromMap(Map<String, dynamic> map) {
    return RequestSeparacaoItem(
      ordem: map[colOrdem] ?? 0,
      idproduto: map[colIdProduto] ?? 0,
      qtdesep: (map[colQtdeSep] as num?)?.toDouble() ?? 0.0,
      lotesaida: (map[colLoteSaida] as List<dynamic>? ?? [])
          .map((e) => LoteSaidaModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    colOrdem: ordem,
    colIdProduto: idproduto,
    colQtdeSep: qtdesep,
    colLoteSaida: lotesaida.map((e) => e.toMap()).toList(),
  };
}

class RequestSeparacao {
  static const colIdFilial = 'idfilial';
  static const colIdPrevenda = 'idprevenda';
  static const colIdSeparador = 'idseparador';
  static const colRomaneio = 'romaneio';
  static const colItens = 'itens';

  RequestSeparacao({
    required this.idFilial,
    required this.idPrevenda,
    required this.idSeparador,
    required this.romaneio,
    required this.itens,
  });

  final int idFilial;
  final int idPrevenda;
  final int idSeparador;
  final int romaneio;
  final List<RequestSeparacaoItem> itens;

  factory RequestSeparacao.empty() => RequestSeparacao(
    idFilial: 0,
    idPrevenda: 0,
    idSeparador: 0,
    romaneio: 0,
    itens: const [],
  );

  RequestSeparacao copyWith({
    int? idFilial,
    int? idPrevenda,
    int? idSeparador,
    int? romaneio,
    List<RequestSeparacaoItem>? itens,
  }) {
    return RequestSeparacao(
      idFilial: idFilial ?? this.idFilial,
      idPrevenda: idPrevenda ?? this.idPrevenda,
      idSeparador: idSeparador ?? this.idSeparador,
      romaneio: romaneio ?? this.romaneio,
      itens: itens ?? List.of(this.itens),
    );
  }

  factory RequestSeparacao.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestSeparacao.empty();
    return RequestSeparacao(
      idFilial: map[colIdFilial] ?? 0,
      idPrevenda: map[colIdPrevenda] ?? 0,
      idSeparador: map[colIdSeparador] ?? 0,
      romaneio: map[colRomaneio] ?? 0,
      itens: (map[colItens] as List<dynamic>? ?? [])
          .map((e) => RequestSeparacaoItem.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    colIdFilial: idFilial,
    colIdPrevenda: idPrevenda,
    colIdSeparador: idSeparador,
    colRomaneio: romaneio,
    colItens: itens.map((e) => e.toMap()).toList(),
  };
}
