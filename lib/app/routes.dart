import 'package:flutter/material.dart';
import '../controllers/parametro_controller.dart';
import '../controllers/cadastro/filial_controller.dart';
import '../controllers/cadastro/usuario_controller.dart';
import '../controllers/separacao/pvseparacao_controller.dart';
import '../controllers/prevenda/prevenda_controller.dart';
import '../core/constants/app_theme.dart';
import '../core/http/dio_client.dart';
import '../services/cadastro/filial/filial_service.dart';
import '../services/cadastro/usuario/usuario_service.dart';
import '../services/separacao/separacao_service.dart';
import '../services/prevenda/prevenda_service.dart';
import '../services/parametro_service.dart';
import '../views/auth/login_view.dart';
import '../controllers/carregamento/carregamento_controller.dart';
import '../controllers/hsaida/hsaida_controller.dart';
import '../services/carregamento/carregamento_service.dart';
import '../services/hsaida/hsaida_service.dart';
import '../views/carregamento/carregamento_list_view.dart';
import '../views/separacao/pvseparacao_list_view.dart';
import '../views/home/home_view.dart';
import '../views/auditoria/auditoria_view.dart';
import '../views/inventario/inventario_view.dart';
import '../views/parametro/parametro_view.dart';

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

  // Dependências criadas uma única vez (DI manual simples)
  static final _parametroService = ParametroService();
  static final _parametroController = ParametroController(_parametroService);

  /// Acesso global aos parâmetros do sistema.
  static ParametroController get parametro => _parametroController;

  static final _apiClient =
      DioApiClient(); // troque por DioApiClient() para usar Dio
  static final _usuarioService = UsuarioService(_apiClient);
  static final _usuarioController = UsuarioController(
    _usuarioService,
    () => _parametroController.parametro.url,
  );

  /// Acesso global ao usuário logado.
  static UsuarioController get usuario => _usuarioController;

  static final _preVendaService = PreVendaService(_apiClient);
  static final _preVendaController = PreVendaController(
    _preVendaService,
    () => _parametroController.parametro.url,
    () => _usuarioController.usuario.senha,
  );
  static final _conferenciaService = SeparacaoService(_apiClient);
  static final _conferenciaController = PvSeparacaoController(
    _conferenciaService,
  );

  static final _carregamentoService = CarregamentoService(_apiClient);
  static final _carregamentoController = CarregamentoController(
    _carregamentoService,
    () => _parametroController.parametro.url,
    () => _usuarioController.usuario.senha,
  );

  static final _hsaidaService = HSaidaService(_apiClient);
  static final _hsaidaController = HSaidaController(
    _hsaidaService,
    () => _parametroController.parametro.url,
    () => _usuarioController.usuario.senha,
  );

  static final _filialService = FilialService(_apiClient);
  static final _filialController = FilialController(
    _filialService,
    () => _parametroController.parametro.url,
    () => _usuarioController.usuario.senha,
  );

  /// Acesso global à filial selecionada.
  static FilialController get filial => _filialController;
  static PvSeparacaoController get conferencia => _conferenciaController;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      login => _route(const LoginView()),
      home => _route(
        HomeView(
          usuarioController: _usuarioController,
          parametroController: _parametroController,
          filialController: _filialController,
        ),
      ),
      parametros => _route(
        ParametroView(
          controller: _parametroController,
          isAdmin: settings.arguments is bool
              ? settings.arguments as bool
              : false,
        ),
      ),
      preVendas => _route(PvSeparacaoListView(controller: _preVendaController)),
      entregaCarga => _route(
        CarregamentoListView(
          controller: _carregamentoController,
          hsaidaController: _hsaidaController,
        ),
      ),
      separacaoCarga => _route(
        PvSeparacaoListView(controller: _preVendaController),
      ),
      inventario => _route(const InventarioView()),
      auditoriaEstoque => _route(const AuditoriaView()),
      _ => _route(const LoginView()),
    };
  }

  static MaterialPageRoute<void> _route(Widget page) =>
      MaterialPageRoute(builder: (_) => page);
}
