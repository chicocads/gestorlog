import '../../models/prevenda/prevenda_model.dart';

class ResponsePreVenda {
  ResponsePreVenda({
    required this.itens,
    required this.paginaAtual,
    required this.proximaPagina,
    required this.qtdPaginas,
  });

  final List<PreVendaModel> itens;
  final int paginaAtual;
  final int proximaPagina;
  final int qtdPaginas;

  factory ResponsePreVenda.empty() => ResponsePreVenda(
    itens: const [],
    paginaAtual: 1,
    proximaPagina: 1,
    qtdPaginas: 1,
  );

  ResponsePreVenda copyWith({
    List<PreVendaModel>? itens,
    int? paginaAtual,
    int? proximaPagina,
    int? qtdPaginas,
  }) {
    return ResponsePreVenda(
      itens: itens ?? List.of(this.itens),
      paginaAtual: paginaAtual ?? this.paginaAtual,
      proximaPagina: proximaPagina ?? this.proximaPagina,
      qtdPaginas: qtdPaginas ?? this.qtdPaginas,
    );
  }

  factory ResponsePreVenda.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ResponsePreVenda.empty();
    return ResponsePreVenda(
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map((e) => PreVendaModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      paginaAtual: map['paginaAtual'] ?? 1,
      proximaPagina: map['proximaPagina'] ?? 1,
      qtdPaginas: map['qtdPaginas'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() => {
    'itens': itens.map((e) => e.toMap()).toList(),
    'paginaAtual': paginaAtual,
    'proximaPagina': proximaPagina,
    'qtdPaginas': qtdPaginas,
  };
}
