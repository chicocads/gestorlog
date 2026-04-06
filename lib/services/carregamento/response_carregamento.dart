import '../../models/carregamento/carregamento_model.dart';

class ResponseCarregamento {
  ResponseCarregamento({
    required this.itens,
    required this.paginaAtual,
    required this.proximaPagina,
    required this.qtdPaginas,
  });

  final List<CarregamentoModel> itens;
  final int paginaAtual;
  final int proximaPagina;
  final int qtdPaginas;

  factory ResponseCarregamento.empty() => ResponseCarregamento(
    itens: const [],
    paginaAtual: 1,
    proximaPagina: 1,
    qtdPaginas: 1,
  );

  ResponseCarregamento copyWith({
    List<CarregamentoModel>? itens,
    int? paginaAtual,
    int? proximaPagina,
    int? qtdPaginas,
  }) {
    return ResponseCarregamento(
      itens: itens ?? List.of(this.itens),
      paginaAtual: paginaAtual ?? this.paginaAtual,
      proximaPagina: proximaPagina ?? this.proximaPagina,
      qtdPaginas: qtdPaginas ?? this.qtdPaginas,
    );
  }

  factory ResponseCarregamento.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ResponseCarregamento.empty();
    return ResponseCarregamento(
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map((e) => CarregamentoModel.fromMap(e as Map<String, dynamic>))
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

  @override
  String toString() =>
      'ResponseCarregamento(itens: ${itens.length}, pagina: $paginaAtual/$qtdPaginas)';
}
