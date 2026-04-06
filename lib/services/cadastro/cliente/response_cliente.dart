import '../../../models/cadastro/cliente_model.dart';

class ResponseCliente {
  ResponseCliente({
    required this.itens,
    required this.paginaAtual,
    required this.proximaPagina,
    required this.qtdPaginas,
  });

  final List<ClienteModel> itens;
  final int paginaAtual;
  final int proximaPagina;
  final int qtdPaginas;

  factory ResponseCliente.empty() => ResponseCliente(
    itens: const [],
    paginaAtual: 1,
    proximaPagina: 1,
    qtdPaginas: 1,
  );

  ResponseCliente copyWith({
    List<ClienteModel>? itens,
    int? paginaAtual,
    int? proximaPagina,
    int? qtdPaginas,
  }) {
    return ResponseCliente(
      itens: itens ?? List.of(this.itens),
      paginaAtual: paginaAtual ?? this.paginaAtual,
      proximaPagina: proximaPagina ?? this.proximaPagina,
      qtdPaginas: qtdPaginas ?? this.qtdPaginas,
    );
  }

  factory ResponseCliente.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ResponseCliente.empty();
    return ResponseCliente(
      itens: (map['lista'] as List<dynamic>? ?? [])
          .map((e) => ClienteModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      paginaAtual: map['paginaAtual'] as int? ?? 1,
      proximaPagina: map['proximaPagina'] as int? ?? 1,
      qtdPaginas: map['qtdPaginas'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toMap() => {
    'lista': itens.map((e) => e.toMap()).toList(),
    'paginaAtual': paginaAtual,
    'proximaPagina': proximaPagina,
    'qtdPaginas': qtdPaginas,
  };
}
