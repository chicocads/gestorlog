part of '../home_view.dart';

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({
    required this.usuarioController,
    required this.parametroController,
    required this.filialController,
    required this.inventarioOnly,
  });

  final UsuarioController usuarioController;
  final ParametroController parametroController;
  final FilialController filialController;
  final bool inventarioOnly;

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
                  icon: Icons.logout,
                  label: 'EfetuarLogout',
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
                DrawerMenuItem(
                  icon: Icons.tune,
                  label: 'Parâmetros',
                  enabled: !inventarioOnly,
                  onTap: inventarioOnly
                      ? null
                      : () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, AppRoutes.parametros);
                        },
                ),
                DrawerMenuItem(
                  icon: Icons.local_shipping_outlined,
                  label: 'Entrega de Carga',
                  enabled: !inventarioOnly,
                  onTap: inventarioOnly
                      ? null
                      : () async {
                          Navigator.pop(context);
                          await _abrirEntregaCargaComValidacaoGps(context);
                        },
                ),
                DrawerMenuItem(
                  icon: Icons.warehouse_outlined,
                  label: 'Separação de Carga',
                  enabled: !inventarioOnly,
                  onTap: inventarioOnly
                      ? null
                      : () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            AppRoutes.separacaoCarga,
                          );
                        },
                ),
                DrawerMenuItem(
                  icon: Icons.qr_code_scanner_outlined,
                  label: 'Inventário de Estoque',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.inventario);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.fact_check_outlined,
                  label: 'Auditoria de Estoque',
                  enabled: !inventarioOnly,
                  onTap: inventarioOnly
                      ? null
                      : () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            AppRoutes.auditoriaEstoque,
                          );
                        },
                ),
                DrawerMenuItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Produtos Online',
                  enabled: !inventarioOnly,
                  onTap: inventarioOnly
                      ? null
                      : () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, AppRoutes.produtos);
                        },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          DrawerMenuItem(
            icon: Icons.exit_to_app,
            label: 'Finalizar Aplicativo',
            color: AppColors.error,
            onTap: () {
              SystemNavigator.pop();
              exit(0);
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
