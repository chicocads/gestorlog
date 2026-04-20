import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/utils/numero_formatar.dart';
import '../../../services/inventario/inventario_local_service.dart';
import '../../../services/inventario/inventario_service.dart';

class InventarioTotalTab extends StatefulWidget {
  const InventarioTotalTab({super.key});

  @override
  State<InventarioTotalTab> createState() => _InventarioTotalTabState();
}

class _InventarioTotalTabState extends State<InventarioTotalTab> {
  final _localService = InventarioLocalService();
  bool _enviando = false;
  bool _apagando = false;

  Future<void> _enviarInventario() async {
    if (_enviando) return;

    final deps = AppScope.of(context);
    final parametro = deps.parametroController.parametro;

    if (parametro.idFilial <= 0 ||
        parametro.idInventario <= 0 ||
        parametro.idPda <= 0) {
      AppSnackBar.erro(
        context,
        'Configure filial, inventário e PDA antes de enviar.',
      );
      return;
    }

    setState(() => _enviando = true);
    try {
      final service = InventarioService(
        deps.apiClient,
        localService: _localService,
      );
      final enviados = await service.enviarItensColetados(
        baseUrl: parametro.url,
        idFilial: parametro.idFilial,
        idInventario: parametro.idInventario,
        idPda: parametro.idPda,
      );

      if (!mounted) return;
      AppSnackBar.sucesso(
        context,
        enviados == 0
            ? 'Nenhum item coletado para enviar.'
            : '$enviados item(ns) enviado(s) com sucesso.',
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao enviar inventário: $e');
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Future<void> _confirmarApagarInventario() async {
    if (_apagando || _enviando) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apagar inventário'),
        content: const Text(
          'Deseja apagar todo o inventário? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() => _apagando = true);
    try {
      await _localService.limpar();
      if (!mounted) return;
      setState(() {});
      AppSnackBar.sucesso(context, 'Inventário apagado com sucesso.');
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao apagar inventário: $e');
    } finally {
      if (mounted) setState(() => _apagando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final parametro = AppScope.of(context).parametroController.parametro;
    final pda = parametro.idPda > 0 ? parametro.idPda.toString() : '-';
    final inventario =
        parametro.idInventario > 0 ? parametro.idInventario.toString() : '-';
    final decQtde = parametro.decQtde;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.devices_other_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ID PDA: $pda',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'ID Inventário: $inventario',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<InventarioResumo>(
            future: _localService.buscarResumoGeral(),
            builder: (context, snapshot) {
              final itens =
                  snapshot.hasData ? snapshot.data!.itens.toString() : '-';
              final qtde = snapshot.hasData
                  ? NumeroFormatar.qtde(snapshot.data!.qtde, decQtde: decQtde)
                  : '-';

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.18),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.fact_check_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Total Itens: $itens',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.calculate_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Qtde total: $qtde',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          FilledButton.icon(
            onPressed: (_enviando || _apagando) ? null : _enviarInventario,
            icon: _enviando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload_outlined),
            label: Text(_enviando ? 'Enviando...' : 'Enviar Inventário'),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: (_enviando || _apagando)
                ? null
                : _confirmarApagarInventario,
            icon: _apagando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline),
            label: Text(_apagando ? 'Apagando...' : 'Apagar Inventário'),
          ),
        ],
      ),
    );
  }
}
