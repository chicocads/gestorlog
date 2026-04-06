class RequestFilial {
  RequestFilial({
    required this.paginaAtual,
    required this.qtdTotal,
    required this.codigo,
    required this.nome,
  });

  final String paginaAtual;
  final String qtdTotal;
  final int codigo;
  final String nome;

  factory RequestFilial.empty(int idFilial) => RequestFilial(
    paginaAtual: '1',
    qtdTotal: '50',
    codigo: idFilial,
    nome: '',
  );

  RequestFilial copyWith({
    String? paginaAtual,
    String? qtdTotal,
    int? codigo,
    String? nome,
  }) {
    return RequestFilial(
      paginaAtual: paginaAtual ?? this.paginaAtual,
      qtdTotal: qtdTotal ?? this.qtdTotal,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
    );
  }

  factory RequestFilial.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestFilial.empty(0);
    return RequestFilial(
      paginaAtual: map['paginaAtual'] as String? ?? '0',
      qtdTotal: map['qtdTotal'] as String? ?? '0',
      codigo: map['codigo'] as int? ?? 0,
      nome: map['nome'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'paginaAtual': paginaAtual,
    'qtdTotal': qtdTotal,
    'codigo': codigo,
    'nome': nome,
  };

  @override
  String toString() =>
      'RequestFilial(nome: $nome, pagina: $paginaAtual/$qtdTotal)';
}
