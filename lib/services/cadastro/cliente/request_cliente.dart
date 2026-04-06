class RequestCliente {
  RequestCliente({
    required this.paginaAtual,
    required this.qtdTotal,
    required this.codigo,
    required this.nome,
    required this.fantasia,
    required this.cnpj,
    required this.fone,
    required this.email,
    required this.rca,
    required this.segmento,
    required this.rota,
    required this.situacao,
  });

  final String paginaAtual;
  final String qtdTotal;
  final int codigo;
  final String nome;
  final String fantasia;
  final String cnpj;
  final String fone;
  final String email;
  final int rca;
  final int segmento;
  final int rota;
  final int situacao;

  factory RequestCliente.empty() => RequestCliente(
    paginaAtual: '1',
    qtdTotal: '50',
    codigo: 0,
    nome: '',
    fantasia: '',
    cnpj: '',
    fone: '',
    email: '',
    rca: 0,
    segmento: 0,
    rota: 0,
    situacao: 0,
  );

  RequestCliente copyWith({
    String? paginaAtual,
    String? qtdTotal,
    int? codigo,
    String? nome,
    String? fantasia,
    String? cnpj,
    String? fone,
    String? email,
    int? rca,
    int? segmento,
    int? rota,
    int? situacao,
  }) {
    return RequestCliente(
      paginaAtual: paginaAtual ?? this.paginaAtual,
      qtdTotal: qtdTotal ?? this.qtdTotal,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      fantasia: fantasia ?? this.fantasia,
      cnpj: cnpj ?? this.cnpj,
      fone: fone ?? this.fone,
      email: email ?? this.email,
      rca: rca ?? this.rca,
      segmento: segmento ?? this.segmento,
      rota: rota ?? this.rota,
      situacao: situacao ?? this.situacao,
    );
  }

  factory RequestCliente.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestCliente.empty();
    return RequestCliente(
      paginaAtual: map['paginaAtual'] as String? ?? '1',
      qtdTotal: map['qtdTotal'] as String? ?? '50',
      codigo: map['codigo'] as int? ?? 0,
      nome: map['nome'] as String? ?? '',
      fantasia: map['fantasia'] as String? ?? '',
      cnpj: map['cnpj'] as String? ?? '',
      fone: map['fone'] as String? ?? '',
      email: map['email'] as String? ?? '',
      rca: map['rca'] as int? ?? 0,
      segmento: map['segmento'] as int? ?? 0,
      rota: map['rota'] as int? ?? 0,
      situacao: map['situacao'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'paginaAtual': paginaAtual,
    'qtdTotal': qtdTotal,
    'codigo': codigo,
    'nome': nome,
    'fantasia': fantasia,
    'cnpj': cnpj,
    'fone': fone,
    'email': email,
    'rca': rca,
    'segmento': segmento,
    'rota': rota,
    'situacao': situacao,
  };
}
