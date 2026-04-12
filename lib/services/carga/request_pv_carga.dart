class PvCargaRequest {
  PvCargaRequest({
    required this.idfilial,
    required this.idprevenda,
    required this.situacao,
    required this.latitude,
    required this.longitude,
    required this.obs,
    required this.assintura,
  });

  final int idfilial;
  final int idprevenda;
  final int situacao;
  final String latitude;
  final String longitude;
  final String obs;
  final String assintura;

  factory PvCargaRequest.empty() => PvCargaRequest(
    idfilial: 0,
    idprevenda: 0,
    situacao: 0,
    latitude: '',
    longitude: '',
    obs: '',
    assintura: '',
  );

  PvCargaRequest copyWith({
    int? idfilial,
    int? idprevenda,
    int? situacao,
    String? latitude,
    String? longitude,
    String? obs,
    String? assintura,
  }) {
    return PvCargaRequest(
      idfilial: idfilial ?? this.idfilial,
      idprevenda: idprevenda ?? this.idprevenda,
      situacao: situacao ?? this.situacao,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      obs: obs ?? this.obs,
      assintura: assintura ?? this.assintura,
    );
  }

  factory PvCargaRequest.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return PvCargaRequest.empty();
    return PvCargaRequest(
      idfilial: map['idfilial'] ?? 0,
      idprevenda: map['idprevenda'] ?? 0,
      situacao: map['situacao'] ?? 0,
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      obs: map['obs'] ?? '',
      assintura: map['assintura'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'idfilial': idfilial,
    'idprevenda': idprevenda,
    'situacao': situacao,
    'latitude': latitude,
    'longitude': longitude,
    'obs': obs,
    'assintura': assintura,
  };
}
