import '../../models/carga/carga_model.dart';

class ResponseCarregamento {
  ResponseCarregamento({
    required this.itens,
    required this.paginaAtual,
    required this.proximaPagina,
    required this.qtdPaginas,
    required this.totalRegistros,
  });

  final List<CarregamentoModel> itens;
  final int paginaAtual;
  final int proximaPagina;
  final int qtdPaginas;
  final int totalRegistros;

  factory ResponseCarregamento.empty() => ResponseCarregamento(
    itens: const [],
    paginaAtual: 1,
    proximaPagina: 1,
    qtdPaginas: 1,
    totalRegistros: 0,
  );

  ResponseCarregamento copyWith({
    List<CarregamentoModel>? itens,
    int? paginaAtual,
    int? proximaPagina,
    int? qtdPaginas,
    int? totalRegistros,
  }) {
    return ResponseCarregamento(
      itens: itens ?? List.of(this.itens),
      paginaAtual: paginaAtual ?? this.paginaAtual,
      proximaPagina: proximaPagina ?? this.proximaPagina,
      qtdPaginas: qtdPaginas ?? this.qtdPaginas,
      totalRegistros: totalRegistros ?? this.totalRegistros,
    );
  }

  factory ResponseCarregamento.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ResponseCarregamento.empty();
    return ResponseCarregamento(
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map((e) => CarregamentoModel.fromMap(e as Map<String, dynamic>))
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

  @override
  String toString() =>
      'ResponseCarregamento(itens: ${itens.length}, pagina: $paginaAtual/$qtdPaginas)';
}
