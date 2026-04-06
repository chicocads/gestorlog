class RequestUsuario {
  RequestUsuario({
    required this.paginaAtual,
    required this.qtdTotal,
    required this.login,
  });

  final String paginaAtual;
  final String qtdTotal;
  final String login;

  factory RequestUsuario.empty() =>
      RequestUsuario(paginaAtual: '0', qtdTotal: '0', login: '');

  RequestUsuario copyWith({
    String? paginaAtual,
    String? qtdTotal,
    String? login,
  }) {
    return RequestUsuario(
      paginaAtual: paginaAtual ?? this.paginaAtual,
      qtdTotal: qtdTotal ?? this.qtdTotal,
      login: login ?? this.login,
    );
  }

  factory RequestUsuario.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestUsuario.empty();
    return RequestUsuario(
      paginaAtual: map['paginaAtual'] as String? ?? '0',
      qtdTotal: map['qtdTotal'] as String? ?? '0',
      login: map['login'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'paginaAtual': paginaAtual,
    'qtdTotal': qtdTotal,
    'login': login,
  };
}
