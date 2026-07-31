import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/auditoria/auditoria_model.dart';

class AuditoriaProdutoLabel extends StatelessWidget {
  const AuditoriaProdutoLabel({
    super.key,
    required this.auditoria,
  });

  final AuditoriaLogisticaModel auditoria;

  @override
  Widget build(BuildContext context) {
    final inativo = !auditoria.ativo;
    final cor = inativo ? AppColors.warning : AppColors.success;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${auditoria.codigo} - ${auditoria.nome}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (inativo) ...[
            const SizedBox(width: 10),
            const StatusBadge(label: 'INATIVO', color: AppColors.error),
          ],
        ],
      ),
    );
  }
}
