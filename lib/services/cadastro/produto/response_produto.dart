import '../../../models/cadastro/produto_model.dart';

class ResponseProduto {
  ResponseProduto({
    required this.itens,
    required this.paginaAtual,
    required this.proximaPagina,
    required this.qtdPaginas,
    required this.totalRegistros,
  });

  final List<ProdutoModel> itens;
  final int paginaAtual;
  final int proximaPagina;
  final int qtdPaginas;
  final int totalRegistros;

  factory ResponseProduto.empty() => ResponseProduto(
    itens: const [],
    paginaAtual: 1,
    proximaPagina: 1,
    qtdPaginas: 1,
    totalRegistros: 0,
  );

  ResponseProduto copyWith({
    List<ProdutoModel>? itens,
    int? paginaAtual,
    int? proximaPagina,
    int? qtdPaginas,
    int? totalRegistros,
  }) {
    return ResponseProduto(
      itens: itens ?? List.of(this.itens),
      paginaAtual: paginaAtual ?? this.paginaAtual,
      proximaPagina: proximaPagina ?? this.proximaPagina,
      qtdPaginas: qtdPaginas ?? this.qtdPaginas,
      totalRegistros: totalRegistros ?? this.totalRegistros,
    );
  }

  factory ResponseProduto.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ResponseProduto.empty();
    return ResponseProduto(
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map((e) => ProdutoModel.fromMap(e as Map<String, dynamic>))
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
