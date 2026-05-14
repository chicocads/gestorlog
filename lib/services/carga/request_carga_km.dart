class CargaKmRequest {
  CargaKmRequest({
    required this.idFilial,
    required this.idCarga,
    required this.kmSaida,
    required this.kmChegada,
  });

  final int idFilial;
  final int idCarga;
  final double kmSaida;
  final double kmChegada;

  factory CargaKmRequest.empty() => CargaKmRequest(
    idFilial: 0,
    idCarga: 0,
    kmSaida: 0,
    kmChegada: 0,
  );

  CargaKmRequest copyWith({
    int? idFilial,
    int? idCarga,
    double? kmSaida,
    double? kmChegada,
  }) {
    return CargaKmRequest(
      idFilial: idFilial ?? this.idFilial,
      idCarga: idCarga ?? this.idCarga,
      kmSaida: kmSaida ?? this.kmSaida,
      kmChegada: kmChegada ?? this.kmChegada,
    );
  }

  factory CargaKmRequest.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return CargaKmRequest.empty();
    return CargaKmRequest(
      idFilial: map['idfilial'] as int? ?? 0,
      idCarga: map['idcarga'] as int? ?? 0,
      kmSaida: (map['kmsaida'] as num?)?.toDouble() ?? 0,
      kmChegada: (map['kmchegada'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'idfilial': idFilial,
    'idcarga': idCarga,
    'kmsaida': kmSaida,
    'kmchegada': kmChegada,
  };
}