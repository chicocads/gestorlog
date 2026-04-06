import '../../../models/cadastro/usuario_model.dart';

class ResponseUsuario {
  ResponseUsuario({
    required this.itens,
    required this.paginaAtual,
    required this.proximaPagina,
    required this.qtdPaginas,
  });

  final List<UsuarioModel> itens;
  final int paginaAtual;
  final int proximaPagina;
  final int qtdPaginas;

  factory ResponseUsuario.empty() => ResponseUsuario(
    itens: const [],
    paginaAtual: 1,
    proximaPagina: 1,
    qtdPaginas: 1,
  );

  ResponseUsuario copyWith({
    List<UsuarioModel>? itens,
    int? paginaAtual,
    int? proximaPagina,
    int? qtdPaginas,
  }) {
    return ResponseUsuario(
      itens: itens ?? List.of(this.itens),
      paginaAtual: paginaAtual ?? this.paginaAtual,
      proximaPagina: proximaPagina ?? this.proximaPagina,
      qtdPaginas: qtdPaginas ?? this.qtdPaginas,
    );
  }

  factory ResponseUsuario.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ResponseUsuario.empty();
    return ResponseUsuario(
      itens: (map['itens'] as List<dynamic>? ?? [])
          .map((e) => UsuarioModel.fromMap(e as Map<String, dynamic>))
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
