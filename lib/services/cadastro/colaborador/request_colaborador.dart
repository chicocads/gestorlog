class RequestColaborador {
  RequestColaborador({
    required this.paginaAtual,
    required this.qtdTotal,
    required this.codigo,
    required this.nome,
    required this.situacao,
  });

  final String paginaAtual;
  final String qtdTotal;
  final int codigo;
  final String nome;
  final int situacao;

  factory RequestColaborador.empty() => RequestColaborador(
    paginaAtual: '1',
    qtdTotal: '50',
    codigo: 0,
    nome: '',
    situacao: 0,
  );

  RequestColaborador copyWith({
    String? paginaAtual,
    String? qtdTotal,
    int? codigo,
    String? nome,
    int? situacao,
  }) {
    return RequestColaborador(
      paginaAtual: paginaAtual ?? this.paginaAtual,
      qtdTotal: qtdTotal ?? this.qtdTotal,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      situacao: situacao ?? this.situacao,
    );
  }

  factory RequestColaborador.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestColaborador.empty();
    return RequestColaborador(
      paginaAtual: map['paginaAtual'] as String? ?? '1',
      qtdTotal: map['qtdTotal'] as String? ?? '50',
      codigo: map['codigo'] as int? ?? 0,
      nome: map['nome'] as String? ?? '',
      situacao: map['situacao'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'paginaAtual': paginaAtual,
    'qtdTotal': qtdTotal,
    'codigo': codigo,
    'nome': nome,
    'situacao': situacao,
  };
}
