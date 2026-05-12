class CargaRecebidoRequest {
  CargaRecebidoRequest({
    required this.id,
    required this.idfilial,
    required this.idcarga,
    required this.idprevenda,
    required this.idfpagamento,
    required this.valor,
  });

  final int id;
  final int idfilial;
  final int idcarga;
  final int idprevenda;
  final int idfpagamento;
  final double valor;

  factory CargaRecebidoRequest.empty() => CargaRecebidoRequest(
    id: 0,
    idfilial: 0,
    idcarga: 0,
    idprevenda: 0,
    idfpagamento: 0,
    valor: 0,
  );

  CargaRecebidoRequest copyWith({
    int? id,
    int? idfilial,
    int? idcarga,
    int? idprevenda,
    int? idfpagamento,
    double? valor,
  }) {
    return CargaRecebidoRequest(
      id: id ?? this.id,
      idfilial: idfilial ?? this.idfilial,
      idcarga: idcarga ?? this.idcarga,
      idprevenda: idprevenda ?? this.idprevenda,
      idfpagamento: idfpagamento ?? this.idfpagamento,
      valor: valor ?? this.valor,
    );
  }

  factory CargaRecebidoRequest.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return CargaRecebidoRequest.empty();
    return CargaRecebidoRequest(
      id: map['id'] as int? ?? 0,
      idfilial: map['idfilial'] as int? ?? 0,
      idcarga: map['idcarga'] as int? ?? 0,
      idprevenda: map['idprevenda'] as int? ?? 0,
      idfpagamento: map['idfpagamento'] as int? ?? 0,
      valor: (map['valor'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'idfilial': idfilial,
    'idcarga': idcarga,
    'idprevenda': idprevenda,
    'idfpagamento': idfpagamento,
    'valor': valor,
  };
}
