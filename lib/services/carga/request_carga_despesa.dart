class CargaDespesaRequest {
  CargaDespesaRequest({
    required this.id,
    required this.idfilial,
    required this.idcarga,
    required this.data,
    required this.descricao,
    required this.valor,
  });

  final int id;
  final int idfilial;
  final int idcarga;
  final String data;
  final String descricao;
  final double valor;

  factory CargaDespesaRequest.empty() => CargaDespesaRequest(
    id: 0,
    idfilial: 0,
    idcarga: 0,
    data: '',
    descricao: '',
    valor: 0,
  );

  CargaDespesaRequest copyWith({
    int? id,
    int? idfilial,
    int? idcarga,
    String? data,
    String? descricao,
    double? valor,
  }) {
    return CargaDespesaRequest(
      id: id ?? this.id,
      idfilial: idfilial ?? this.idfilial,
      idcarga: idcarga ?? this.idcarga,
      data: data ?? this.data,
      descricao: descricao ?? this.descricao,
      valor: valor ?? this.valor,
    );
  }

  factory CargaDespesaRequest.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return CargaDespesaRequest.empty();
    return CargaDespesaRequest(
      id: map['id'] as int? ?? 0,
      idfilial: map['idfilial'] as int? ?? 0,
      idcarga: map['idcarga'] as int? ?? 0,
      data: map['data'] as String? ?? '',
      descricao: map['descricao'] as String? ?? '',
      valor: (map['valor'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'idfilial': idfilial,
    'idcarga': idcarga,
    'data': data,
    'descricao': descricao,
    'valor': valor,
  };
}
