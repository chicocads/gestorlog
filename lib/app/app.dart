import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'routes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppDependencies _deps;

  @override
  void initState() {
    super.initState();
    _deps = AppDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) {
        return AppScope(
          deps: _deps,
          child: MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('pt', 'BR')],
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: <PointerDeviceKind>{
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.trackpad,
                PointerDeviceKind.unknown,
              },
            ),
            title: 'GestorLog',
            debugShowCheckedModeBanner: false,
            theme: AppRoutes.theme,
            initialRoute: AppRoutes.login,
            onGenerateRoute: (settings) =>
                AppRoutes.onGenerateRoute(settings, _deps),
          ),
        );
      },
    );
  }
}
