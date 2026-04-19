import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/app_snack_bar.dart';

typedef CoordenadaGeografica = ({double latitude, double longitude});

Future<bool> isGpsAtivo() => Geolocator.isLocationServiceEnabled();

Future<bool> validarGpsAtivoParaEntrega(BuildContext context) async {
  final ativo = await isGpsAtivo();
  if (ativo) return true;
  if (!context.mounted) return false;
  AppSnackBar.erro(
    context,
    'Ative o GPS do celular para acessar a Entrega de Carga.',
  );
  return false;
}

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
