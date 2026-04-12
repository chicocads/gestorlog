import 'package:geolocator/geolocator.dart';

typedef CoordenadaGeografica = ({double latitude, double longitude});

Future<CoordenadaGeografica> obterCoordenadaGeograficaAtual({
  LocationAccuracy accuracy = LocationAccuracy.high,
  Duration timeLimit = const Duration(seconds: 10),
}) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Serviço de localização desativado.');
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    throw Exception('Permissão de localização negada.');
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Permissão de localização negada permanentemente.');
  }

  final position = await Geolocator.getCurrentPosition(
    locationSettings: LocationSettings(
      accuracy: accuracy,
      timeLimit: timeLimit,
    ),
  );

  return (latitude: position.latitude, longitude: position.longitude);
}
