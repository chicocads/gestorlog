// Campo acrConsumidor: pegar valor da tabela filial.
class ParametroModel {
  static const tblNome = 'parametro';
  static const colId = 'id';
  static const colIdCads = 'idCads';
  static const colIdFilial = 'idFilial';
  static const colIdPda = 'idPda';
  static const colIdFrota = 'idFrota';
  static const colIdInventario = 'idInventario';
  static const colDecPreco = 'decPreco';
  static const colDecQtde = 'decQtde';
  static const colControlePecas = 'controlepecas';
  static const colUrl = 'Url';

  ParametroModel({
    required this.id,
    required this.idCads,
    required this.idFilial,
    required this.idPda,
    required this.idFrota,
    required this.idInventario,
    required this.decPreco,
    required this.decQtde,
    required this.controlePecas,
    required this.url,
  });

  final int id;
  final int idCads;
  final int idFilial;
  final int idPda;
  final int idFrota;
  final int idInventario;
  final int decPreco;
  final int decQtde;
  final int controlePecas;
  final String url;

  factory ParametroModel.empty() => ParametroModel(
    id: 1,
    idCads: 1,
    idFilial: 1,
    idPda: 0,
    idFrota: 0,
    idInventario: 0,
    decPreco: 2,
    decQtde: 0,
    controlePecas: 0,
    url: 'http://45.224.122.64:5000',
  );

  ParametroModel copyWith({
    int? id,
    int? idCads,
    int? idFilial,
    int? idPda,
    int? idFrota,
    int? idInventario,
    int? decPreco,
    int? decQtde,
    int? controlePecas,
    String? url,
  }) {
    return ParametroModel(
      id: id ?? this.id,
      idCads: idCads ?? this.idCads,
      idFilial: idFilial ?? this.idFilial,
      idPda: idPda ?? this.idPda,
      idFrota: idFrota ?? this.idFrota,
      idInventario: idInventario ?? this.idInventario,
      url: url ?? this.url,
      decPreco: decPreco ?? this.decPreco,
      decQtde: decQtde ?? this.decQtde,
      controlePecas: controlePecas ?? this.controlePecas,
    );
  }

  factory ParametroModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return ParametroModel.empty();
    return ParametroModel(
      id: map[colId] as int? ?? 1,
      idCads: map[colIdCads] as int? ?? 1,
      idFilial: map[colIdFilial] as int? ?? 1,
      idPda: map[colIdPda] as int? ?? 0,
      idFrota: map[colIdFrota] as int? ?? 0,
      idInventario: map[colIdInventario] as int? ?? 0,
      url: map[colUrl] as String? ?? 'http://45.224.122.64:5000',
      decPreco: map[colDecPreco] as int? ?? 2,
      decQtde: map[colDecQtde] as int? ?? 0,
      controlePecas: map[colControlePecas] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colId: id,
    colIdCads: idCads,
    colIdFilial: idFilial,
    colIdPda: idPda,
    colIdFrota: idFrota,
    colIdInventario: idInventario,
    colUrl: url,
    colDecPreco: decPreco,
    colDecQtde: decQtde,
    colControlePecas: controlePecas,
  };

  @override
  String toString() =>
      'ParametroModel(id: $id, idFilial: $idFilial, url: $url, decPreco: $decPreco, decQtde: $decQtde)';
}
