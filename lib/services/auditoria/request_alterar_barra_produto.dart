class RequestAlterarCodigoBarraProduto {
  static const colCodigo = 'codigo';
  static const colCodigoAlfa = 'codigoAlfa';
  static const colDun14 = 'dun14';

  RequestAlterarCodigoBarraProduto({
    required this.codigo,
    required this.codigoAlfa,
    required this.dun14,
  });

  final int codigo;
  final String codigoAlfa;
  final String dun14;

  factory RequestAlterarCodigoBarraProduto.empty() =>
      RequestAlterarCodigoBarraProduto(codigo: 0, codigoAlfa: '', dun14: '');

  RequestAlterarCodigoBarraProduto copyWith({
    int? codigo,
    String? codigoAlfa,
    String? dun14,
  }) {
    return RequestAlterarCodigoBarraProduto(
      codigo: codigo ?? this.codigo,
      codigoAlfa: codigoAlfa ?? this.codigoAlfa,
      dun14: dun14 ?? this.dun14,
    );
  }

  factory RequestAlterarCodigoBarraProduto.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestAlterarCodigoBarraProduto.empty();
    return RequestAlterarCodigoBarraProduto(
      codigo: (map[colCodigo] as num?)?.toInt() ?? 0,
      codigoAlfa:
          map[colCodigoAlfa] as String? ?? map['codigoalfa'] as String? ?? '',
      dun14: map[colDun14] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    colCodigo: codigo,
    colCodigoAlfa: codigoAlfa,
    colDun14: dun14,
  };
}
