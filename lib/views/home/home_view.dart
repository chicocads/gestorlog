import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/routes.dart';
import '../../controllers/cadastro/filial_controller.dart';
import '../../controllers/cadastro/usuario_controller.dart';
import '../../controllers/parametro/parametro_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/functions/geolocalizacao.dart';
import '../../core/widgets/drawer_menu_item.dart';
import '../../core/widgets/quick_action_card.dart';
import '../../models/cadastro/filial_model.dart';
import '../../services/cadastro/filial/request_filial.dart';

part 'widgets/app_drawer.dart';
part 'widgets/filial_logo.dart';
part 'widgets/filial_dropdown.dart';

Future<void> _abrirEntregaCargaComValidacaoGps(BuildContext context) async {
  final podeAbrir = await validarGpsAtivoParaEntrega(context);
  if (!context.mounted || !podeAbrir) return;
  Navigator.pushNamed(context, AppRoutes.entregaCarga);
}

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
        final inventarioOnly = usuario.id == 0;

        return Scaffold(
          appBar: AppBar(title: const Text(AppStrings.appName), elevation: 0),
          drawer: _AppDrawer(
            usuarioController: widget.usuarioController,
            parametroController: widget.parametroController,
            filialController: widget.filialController,
            inventarioOnly: inventarioOnly,
          ),
          body: SingleChildScrollView(
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
                            _FilialLogo(
                              filialController: widget.filialController,
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Olá, ${usuario.login.isNotEmpty ? usuario.login : 'usuário'}!',
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
                          controller: widget.filialController,
                          idFilialParametro:
                              widget.parametroController.parametro.idFilial,
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
                                enabled: !inventarioOnly,
                                onTap: inventarioOnly
                                    ? null
                                    : () async =>
                                          _abrirEntregaCargaComValidacaoGps(
                                            context,
                                          ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: QuickActionCard(
                                icon: Icons.warehouse_outlined,
                                label: 'Separação de Carga',
                                color: AppColors.primary,
                                enabled: !inventarioOnly,
                                onTap: inventarioOnly
                                    ? null
                                    : () => Navigator.pushNamed(
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
                                label: 'Inventário de Estoque',
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
                                enabled: !inventarioOnly,
                                onTap: inventarioOnly
                                    ? null
                                    : () => Navigator.pushNamed(
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
          ),
        );
      },
    );
  }
}
