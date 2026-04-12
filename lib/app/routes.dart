import 'package:flutter/material.dart';
import '../controllers/parametro_controller.dart';
import '../controllers/cadastro/filial_controller.dart';
import '../controllers/cadastro/usuario_controller.dart';
import '../controllers/separacao/pvseparacao_controller.dart';
import '../controllers/prevenda/prevenda_controller.dart';
import '../core/constants/app_theme.dart';
import '../core/http/api_client.dart';
import '../core/http/dio_client.dart';
import '../services/cadastro/filial/filial_service.dart';
import '../services/cadastro/usuario/usuario_service.dart';
import '../services/separacao/separacao_local_service.dart';
import '../services/separacao/separacao_remote_service.dart';
import '../services/prevenda/prevenda_service.dart';
import '../services/parametro_service.dart';
import '../views/auth/login_view.dart';
import '../controllers/carga/carga_controller.dart';
import '../controllers/hsaida/hsaida_controller.dart';
import '../services/carga/carga_service.dart';
import '../services/hsaida/hsaida_service.dart';
import '../views/carga/carga_list_view.dart';
import '../views/separacao/pvseparacao_list_view.dart';
import '../views/home/home_view.dart';
import '../views/auditoria/auditoria_view.dart';
import '../views/inventario/inventario_view.dart';
import '../views/parametro/parametro_view.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.deps,
    required super.child,
  });

  final AppDependencies deps;

  static AppDependencies of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope não encontrado no widget tree.');
    return scope!.deps;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => deps != oldWidget.deps;
}

class AppDependencies {
  AppDependencies({
    ApiClient? apiClient,
    ParametroService? parametroService,
  }) {
    this.apiClient = apiClient ?? DioApiClient();
    this.parametroService = parametroService ?? ParametroService();

    parametroController = ParametroController(this.parametroService);

    usuarioService = UsuarioService(this.apiClient);
    usuarioController = UsuarioController(
      usuarioService,
      () => parametroController.parametro.url,
    );

    preVendaService = PreVendaService(this.apiClient);
    preVendaController = PreVendaController(
      preVendaService,
      () => parametroController.parametro.url,
    );

    conferenciaLocalService = SeparacaoLocalService();
    conferenciaRemoteService = SeparacaoRemoteService(this.apiClient);
    conferenciaController = PvSeparacaoController(
      conferenciaLocalService,
      conferenciaRemoteService,
    );

    carregamentoService = CarregamentoService(this.apiClient);
    carregamentoController = CarregamentoController(
      carregamentoService,
      () => parametroController.parametro.url,
    );

    hsaidaService = HSaidaService(this.apiClient);
    hsaidaController = HSaidaController(
      hsaidaService,
      carregamentoService,
      () => parametroController.parametro.url,
    );

    filialService = FilialService(this.apiClient);
    filialController = FilialController(
      filialService,
      () => parametroController.parametro.url,
    );
  }

  late final ApiClient apiClient;

  late final ParametroService parametroService;
  late final ParametroController parametroController;

  late final UsuarioService usuarioService;
  late final UsuarioController usuarioController;

  late final PreVendaService preVendaService;
  late final PreVendaController preVendaController;

  late final SeparacaoLocalService conferenciaLocalService;
  late final SeparacaoRemoteService conferenciaRemoteService;
  late final PvSeparacaoController conferenciaController;

  late final CarregamentoService carregamentoService;
  late final CarregamentoController carregamentoController;

  late final HSaidaService hsaidaService;
  late final HSaidaController hsaidaController;

  late final FilialService filialService;
  late final FilialController filialController;
}

class AppRoutes {
  AppRoutes._();

  static const login = '/';
  static const home = '/home';
  static const parametros = '/parametros';
  static const preVendas = '/pre-vendas';
  static const entregaCarga = '/entrega-carga';
  static const separacaoCarga = '/separacao-carga';
  static const inventario = '/inventario';
  static const auditoriaEstoque = '/auditoria-estoque';

  static final ThemeData theme = AppTheme.light;

  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
    AppDependencies deps,
  ) {
    return switch (settings.name) {
      login => _route(const LoginView()),
      home => _route(
        HomeView(
          usuarioController: deps.usuarioController,
          parametroController: deps.parametroController,
          filialController: deps.filialController,
        ),
      ),
      parametros => _route(
        ParametroView(
          controller: deps.parametroController,
          isAdmin: settings.arguments is bool
              ? settings.arguments as bool
              : false,
        ),
      ),
      preVendas => _route(
        PvSeparacaoListView(controller: deps.preVendaController),
      ),
      entregaCarga => _route(
        CargaListView(
          controller: deps.carregamentoController,
          hsaidaController: deps.hsaidaController,
        ),
      ),
      separacaoCarga => _route(
        PvSeparacaoListView(controller: deps.preVendaController),
      ),
      inventario => _route(const InventarioView()),
      auditoriaEstoque => _route(const AuditoriaView()),
      _ => _route(const LoginView()),
    };
  }

  static MaterialPageRoute<void> _route(Widget page) =>
      MaterialPageRoute(builder: (_) => page);
}
