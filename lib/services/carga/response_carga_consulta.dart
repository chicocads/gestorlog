import '../../models/carga/carga_model.dart';

class ResponseCargaConsulta {
  ResponseCargaConsulta({
    required this.itens,
    required this.paginaAtual,
    required this.proximaPagina,
    required this.qtdPaginas,
    required this.totalRegistros,
  });

  final List<CargaModel> itens;
  final int paginaAtual;
  final int proximaPagina;
  final int qtdPaginas;
  final int totalRegistros;

  factory ResponseCargaConsulta.empty() => ResponseCargaConsulta(
    itens: const [],
    paginaAtual: 1,
    proximaPagina: 1,
    qtdPaginas: 1,
    totalRegistros: 0,
  );

  ResponseCargaConsulta copyWith({
    List<CargaModel>? itens,
    int? paginaAtual,
    int? proximaPagina,
    int? qtdPaginas,
    int? totalRegistros,
  }) {
    return ResponseCargaConsulta(
      itens: itens ?? List.of(this.itens),
      paginaAtual: paginaAtual ?? this.paginaAtual,
      proximaPagina: proximaPagina ?? this.proximaPagina,
      qtdPaginas: qtdPaginas ?? this.qtdPaginas,
      totalRegistros: totalRegistros ?? this.totalRegistros,
    );
  }

  factory ResponseCargaConsulta.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ResponseCargaConsulta.empty();
    return ResponseCargaConsulta(
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map((e) => CargaModel.fromMap(e as Map<String, dynamic>))
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
