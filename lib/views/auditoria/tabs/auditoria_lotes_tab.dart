import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/info_row.dart';
import '../../../models/diversos/auditoria_model.dart';

typedef AuditoriaCardBuilder = Widget Function(Widget child);

class AuditoriaLotesTab extends StatelessWidget {
  const AuditoriaLotesTab({
    super.key,
    required this.buscando,
    required this.auditoria,
    required this.cardBuilder,
    required this.formatValidade,
    required this.formatQtd,
  });

  final bool buscando;
  final AuditoriaLogisticaModel? auditoria;
  final AuditoriaCardBuilder cardBuilder;
  final String Function(String raw) formatValidade;
  final String Function(double value) formatQtd;

  @override
  Widget build(BuildContext context) {
    if (buscando) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final a = auditoria;
    if (a == null) {
      return const Center(
        child: Text(
          'Consulte um produto para ver os lotes.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    if (a.lotes.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum lote retornado.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: a.lotes.length,
      separatorBuilder: (_, index) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final lote = a.lotes[index];
        return cardBuilder(
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InfoRow(
                      label: 'Lote',
                      value: lote.lote.trim().isNotEmpty ? lote.lote : '-',
                      labelWidth: 52,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: InfoRow(
                      label: 'Validade',
                      value: formatValidade(lote.validade),
                      labelWidth: 62,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoRow(
                      label: 'Saldo',
                      value: formatQtd(lote.saldo),
                      labelWidth: 48,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

