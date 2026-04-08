import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  runZonedGuarded(() => runApp(const App()), (error, stack) {
    debugPrint('Erro não tratado: $error\n$stack');
  });
}
