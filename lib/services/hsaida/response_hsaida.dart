import '../../models/hsaida/hsaida_model.dart';

class ResponseHSaida {
  ResponseHSaida({
    required this.itens,
    required this.paginaAtual,
    required this.proximaPagina,
    required this.qtdPaginas,
  });

  final List<HSaidaModel> itens;
  final int paginaAtual;
  final int proximaPagina;
  final int qtdPaginas;

  factory ResponseHSaida.empty() => ResponseHSaida(
    itens: const [],
    paginaAtual: 1,
    proximaPagina: 1,
    qtdPaginas: 1,
  );

  ResponseHSaida copyWith({
    List<HSaidaModel>? itens,
    int? paginaAtual,
    int? proximaPagina,
    int? qtdPaginas,
  }) {
    return ResponseHSaida(
      itens: itens ?? List.of(this.itens),
      paginaAtual: paginaAtual ?? this.paginaAtual,
      proximaPagina: proximaPagina ?? this.proximaPagina,
      qtdPaginas: qtdPaginas ?? this.qtdPaginas,
    );
  }

  factory ResponseHSaida.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ResponseHSaida.empty();
    return ResponseHSaida(
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map((e) => HSaidaModel.fromMap(e as Map<String, dynamic>))
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
