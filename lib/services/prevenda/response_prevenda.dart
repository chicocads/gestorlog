import '../../models/prevenda/prevenda_model.dart';

class ResponsePreVenda {
  ResponsePreVenda({
    required this.itens,
    required this.paginaAtual,
    required this.proximaPagina,
    required this.qtdPaginas,
    required this.totalRegistros,
  });

  final List<PreVendaModel> itens;
  final int paginaAtual;
  final int proximaPagina;
  final int qtdPaginas;
  final int totalRegistros;

  factory ResponsePreVenda.empty() => ResponsePreVenda(
    itens: const [],
    paginaAtual: 1,
    proximaPagina: 1,
    qtdPaginas: 1,
    totalRegistros: 0,
  );

  ResponsePreVenda copyWith({
    List<PreVendaModel>? itens,
    int? paginaAtual,
    int? proximaPagina,
    int? qtdPaginas,
    int? totalRegistros,
  }) {
    return ResponsePreVenda(
      itens: itens ?? List.of(this.itens),
      paginaAtual: paginaAtual ?? this.paginaAtual,
      proximaPagina: proximaPagina ?? this.proximaPagina,
      qtdPaginas: qtdPaginas ?? this.qtdPaginas,
      totalRegistros: totalRegistros ?? this.totalRegistros,
    );
  }

  factory ResponsePreVenda.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ResponsePreVenda.empty();
    return ResponsePreVenda(
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map((e) => PreVendaModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      paginaAtual: map['paginaAtual'] as int? ?? 1,
      proximaPagina: map['proximaPagina'] as int? ?? 1,
      qtdPaginas: map['qtdPaginas'] as int? ?? 1,
      totalRegistros:
          map['totalRegistros'] as int? ?? map['total_registros'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'itens': itens.map((e) => e.toMap()).toList(),
    'paginaAtual': paginaAtual,
    'proximaPagina': proximaPagina,
    'qtdPaginas': qtdPaginas,
    'totalRegistros': totalRegistros,
  };
}
