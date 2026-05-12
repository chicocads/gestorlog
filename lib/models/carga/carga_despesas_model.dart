class CargaDespesaModel {
  static const tblNome = 'carga_despesa';
  static const colId = 'id';
  static const colIdFilial = 'idfilial';
  static const colIdCarga = 'idcarga';
  static const colData = 'data';
  static const colDescricao = 'descricao';
  static const colValor = 'valor';

  CargaDespesaModel({
    required this.id,
    required this.idFilial,
    required this.idCarga,
    required this.data,
    required this.descricao,
    required this.valor,
  });

  final int id;
  final int idFilial;
  final int idCarga;
  final String data;
  final String descricao;
  final double valor;

  factory CargaDespesaModel.empty() => CargaDespesaModel(
    id: 0,
    idFilial: 0,
    idCarga: 0,
    data: '',
    descricao: '',
    valor: 0,
  );

  CargaDespesaModel copyWith({
    int? id,
    int? idFilial,
    int? idCarga,
    String? data,
    String? descricao,
    double? valor,
  }) {
    return CargaDespesaModel(
      id: id ?? this.id,
      idFilial: idFilial ?? this.idFilial,
      idCarga: idCarga ?? this.idCarga,
      data: data ?? this.data,
      descricao: descricao ?? this.descricao,
      valor: valor ?? this.valor,
    );
  }

  factory CargaDespesaModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return CargaDespesaModel.empty();

    final rawData = map[colData];
    final data = switch (rawData) {
      final String v => v,
      final DateTime v => v.toIso8601String(),
      _ => '',
    };

    return CargaDespesaModel(
      id: map[colId] as int? ?? 0,
      idFilial: map[colIdFilial] as int? ?? 0,
      idCarga: map[colIdCarga] as int? ?? 0,
      data: data,
      descricao: map[colDescricao] as String? ?? '',
      valor: (map[colValor] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colId: id,
    colIdFilial: idFilial,
    colIdCarga: idCarga,
    colData: data,
    colDescricao: descricao,
    colValor: valor,
  };

  @override
  String toString() =>
      'CargaDespesaModel(id: $id, idfilial: $idFilial, idcarga: $idCarga, data: $data, descricao: $descricao, valor: $valor)';
}
