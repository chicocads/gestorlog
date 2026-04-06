import '../../../models/cadastro/colaborador_model.dart';

class ReponseColaborador {
  ReponseColaborador({
    required this.itens,
    required this.paginaAtual,
    required this.proximaPagina,
    required this.qtdPaginas,
  });

  final List<ColaboradorModel> itens;
  final int paginaAtual;
  final int proximaPagina;
  final int qtdPaginas;

  factory ReponseColaborador.empty() => ReponseColaborador(
    itens: const [],
    paginaAtual: 1,
    proximaPagina: 1,
    qtdPaginas: 1,
  );

  ReponseColaborador copyWith({
    List<ColaboradorModel>? itens,
    int? paginaAtual,
    int? proximaPagina,
    int? qtdPaginas,
  }) {
    return ReponseColaborador(
      itens: itens ?? List.of(this.itens),
      paginaAtual: paginaAtual ?? this.paginaAtual,
      proximaPagina: proximaPagina ?? this.proximaPagina,
      qtdPaginas: qtdPaginas ?? this.qtdPaginas,
    );
  }

  factory ReponseColaborador.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ReponseColaborador.empty();
    return ReponseColaborador(
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map((e) => ColaboradorModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      paginaAtual: map['paginaAtual'] as int? ?? 1,
      proximaPagina: map['proximaPagina'] as int? ?? 1,
      qtdPaginas: map['qtdPaginas'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toMap() => {
    'itens': itens.map((e) => e.toMap()).toList(),
    'paginaAtual': paginaAtual,
    'proximaPagina': proximaPagina,
    'qtdPaginas': qtdPaginas,
  };
}
