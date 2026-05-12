class CargaRecebidoModel {
  static const tblNome = 'carga_recebido';
  static const colId = 'id';
  static const colIdFilial = 'idfilial';
  static const colIdCarga = 'idcarga';
  static const colIdPreVenda = 'idprevenda';
  static const colIdFPagamento = 'idfpagamento';
  static const colValor = 'valor';

  CargaRecebidoModel({
    required this.id,
    required this.idFilial,
    required this.idCarga,
    required this.idPreVenda,
    required this.idFPagamento,
    required this.valor,
  });

  final int id;
  final int idFilial;
  final int idCarga;
  final int idPreVenda;
  final int idFPagamento;
  final double valor;

  factory CargaRecebidoModel.empty() => CargaRecebidoModel(
    id: 0,
    idFilial: 0,
    idCarga: 0,
    idPreVenda: 0,
    idFPagamento: 0,
    valor: 0,
  );

  CargaRecebidoModel copyWith({
    int? id,
    int? idFilial,
    int? idCarga,
    int? idPreVenda,
    int? idFPagamento,
    double? valor,
  }) {
    return CargaRecebidoModel(
      id: id ?? this.id,
      idFilial: idFilial ?? this.idFilial,
      idCarga: idCarga ?? this.idCarga,
      idPreVenda: idPreVenda ?? this.idPreVenda,
      idFPagamento: idFPagamento ?? this.idFPagamento,
      valor: valor ?? this.valor,
    );
  }

  factory CargaRecebidoModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return CargaRecebidoModel.empty();
    return CargaRecebidoModel(
      id: map[colId] as int? ?? 0,
      idFilial: map[colIdFilial] as int? ?? 0,
      idCarga: map[colIdCarga] as int? ?? 0,
      idPreVenda: map[colIdPreVenda] as int? ?? 0,
      idFPagamento: map[colIdFPagamento] as int? ?? 0,
      valor: (map[colValor] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colId: id,
    colIdFilial: idFilial,
    colIdCarga: idCarga,
    colIdPreVenda: idPreVenda,
    colIdFPagamento: idFPagamento,
    colValor: valor,
  };

  @override
  String toString() =>
      'CargaRecebidoModel(id: $id, idfilial: $idFilial, idcarga: $idCarga, idprevenda: $idPreVenda, idfpagamento: $idFPagamento, valor: $valor)';
}
