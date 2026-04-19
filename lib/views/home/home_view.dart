import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../controllers/cadastro/filial_controller.dart';
import '../../controllers/cadastro/usuario_controller.dart';
import '../../controllers/parametro_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/drawer_menu_item.dart';
import '../../core/widgets/quick_action_card.dart';
import '../../models/cadastro/filial_model.dart';
import '../../services/cadastro/filial/request_filial.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.usuarioController,
    required this.parametroController,
    required this.filialController,
  });

  final UsuarioController usuarioController;
  final ParametroController parametroController;
  final FilialController filialController;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.filialController.consultar(
        RequestFilial.empty(widget.parametroController.parametro.idFilial),
      );
      final idFilial = widget.parametroController.parametro.idFilial;
      final itens = widget.filialController.itens;
      if (itens.isEmpty) return;
      final filial = itens.firstWhere(
        (f) => f.codigo == idFilial,
        orElse: () => itens.first,
      );
      widget.filialController.selecionar(filial);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.usuarioController,
        widget.parametroController,
        widget.filialController,
      ]),
      builder: (context, _) {
        if (widget.parametroController.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final usuario = widget.usuarioController.usuario;

        return Scaffold(
          appBar: AppBar(title: const Text(AppStrings.appName), elevation: 0),
          drawer: _AppDrawer(
            usuarioController: widget.usuarioController,
            parametroController: widget.parametroController,
            filialController: widget.filialController,
          ),
          body: _HomeBody(
            login: usuario.login,
            filialController: widget.filialController,
            idFilialParametro: widget.parametroController.parametro.idFilial,
          ),
        );
      },
    );
  }
}

// ─── Drawer ────────────────────────────────────────────────────────────────

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({
    required this.usuarioController,
    required this.parametroController,
    required this.filialController,
  });

  final UsuarioController usuarioController;
  final ParametroController parametroController;
  final FilialController filialController;

  @override
  Widget build(BuildContext context) {
    final usuario = usuarioController.usuario;
    final initials = usuario.login.isNotEmpty
        ? usuario.login.substring(0, 1).toUpperCase()
        : '?';
    final codigoFilial = filialController.selecionado.codigo != 0
        ? filialController.selecionado.codigo
        : usuario.idfilial;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.accent,
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            accountName: Text(
              usuario.login.isNotEmpty ? usuario.login : 'Usuário',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(
              usuario.email.isNotEmpty
                  ? usuario.email
                  : 'Filial: $codigoFilial',
              style: const TextStyle(fontSize: 13),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerMenuItem(
                  icon: Icons.tune,
                  label: 'Parâmetros',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.parametros);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.local_shipping_outlined,
                  label: 'Entrega de Carga',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.entregaCarga);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.warehouse_outlined,
                  label: 'Separação de Carga',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.separacaoCarga);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Produtos Online',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.produtos);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.qr_code_scanner_outlined,
                  label: 'Inventário',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.inventario);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.fact_check_outlined,
                  label: 'Auditoria de Estoque',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.auditoriaEstoque);
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          DrawerMenuItem(
            icon: Icons.logout,
            label: 'Logout',
            color: AppColors.error,
            onTap: () {
              Navigator.pop(context);
              usuarioController.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              );
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

// ─── Body ───────────────────────────────────────────────────────────────────

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.login,
    required this.filialController,
    required this.idFilialParametro,
  });

  final String login;
  final FilialController filialController;
  final int idFilialParametro;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 60),
      child: Container(
        color: AppColors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warehouse_outlined,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Olá, ${login.isNotEmpty ? login : 'usuário'}!',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Bem-vindo ao GestorLog',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _FilialDropdown(
                    controller: filialController,
                    idFilialParametro: idFilialParametro,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      'Acesso rápido',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.local_shipping_outlined,
                          label: 'Entrega de Carga',
                          color: AppColors.success,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.entregaCarga,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.warehouse_outlined,
                          label: 'Separação de Carga',
                          color: AppColors.primary,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.separacaoCarga,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.inventory_2_outlined,
                          label: 'Inventário',
                          color: AppColors.warning,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.inventario,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.fact_check_outlined,
                          label: 'Auditoria de Estoque',
                          color: AppColors.accent,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.auditoriaEstoque,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Filial Dropdown ─────────────────────────────────────────────────────────

class _FilialDropdown extends StatelessWidget {
  const _FilialDropdown({
    required this.controller,
    required this.idFilialParametro,
  });

  final FilialController controller;
  final int idFilialParametro;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const SizedBox(
        height: 36,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (controller.itens.isEmpty) {
      return const SizedBox.shrink();
    }

    final codigoAtivo = controller.selecionado.codigo != 0
        ? controller.selecionado.codigo
        : idFilialParametro;

    final selecionado = controller.itens.firstWhere(
      (f) => f.codigo == codigoAtivo,
      orElse: () => controller.itens.first,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.store_outlined, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<FilialModel>(
              value: selecionado,
              dropdownColor: AppColors.primaryDark,
              iconEnabledColor: Colors.white,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              items: controller.itens
                  .map(
                    (f) => DropdownMenuItem(
                      value: f,
                      child: Text(f.fantasia.isNotEmpty ? f.fantasia : f.nome),
                    ),
                  )
                  .toList(),
              onChanged: (f) {
                if (f != null) controller.selecionar(f);
              },
            ),
          ),
        ],
      ),
    );
  }
}
