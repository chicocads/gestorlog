class RequestHSaidaEntrega {
  RequestHSaidaEntrega({
    required this.idFilial,
    required this.idPrevenda,
    required this.entregue,
    required this.dtEntrega,
    required this.latitude,
    required this.longitude,
  });

  final int idFilial;
  final int idPrevenda;
  final int entregue;
  final String dtEntrega;
  final String latitude;
  final String longitude;

  factory RequestHSaidaEntrega.empty() => RequestHSaidaEntrega(
    idFilial: 0,
    idPrevenda: 0,
    entregue: 0,
    dtEntrega: '',
    latitude: '',
    longitude: '',
  );

  RequestHSaidaEntrega copyWith({
    int? idFilial,
    int? idPrevenda,
    int? entregue,
    String? dtEntrega,
    String? latitude,
    String? longitude,
  }) {
    return RequestHSaidaEntrega(
      idFilial: idFilial ?? this.idFilial,
      idPrevenda: idPrevenda ?? this.idPrevenda,
      entregue: entregue ?? this.entregue,
      dtEntrega: dtEntrega ?? this.dtEntrega,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory RequestHSaidaEntrega.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestHSaidaEntrega.empty();
    return RequestHSaidaEntrega(
      idFilial: map['idFilial'] ?? 0,
      idPrevenda: map['idPrevenda'] ?? 0,
      entregue: map['entregue'] ?? 0,
      dtEntrega: map['dtEntrega'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'idFilial': idFilial,
    'idPrevenda': idPrevenda,
    'entregue': entregue,
    'dtEntrega': dtEntrega,
    'latitude': latitude,
    'longitude': longitude,
  };
}
