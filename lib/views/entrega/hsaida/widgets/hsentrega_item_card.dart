import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/hsaida/dsaida_model.dart';

class HsEntregaItemCard extends StatelessWidget {
  const HsEntregaItemCard({
    super.key,
    required this.item,
    this.highlighted = false,
  });

  final DSaidaModel item;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: highlighted
            ? const BorderSide(color: AppColors.entrega, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.nomeProduto,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _InfoRow(label: 'Código:', value: '${item.idProduto}'),
                ),
                Expanded(
                  child: _InfoRow(label: 'Unidade:', value: item.undvenda),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _InfoRow(
                    label: 'Lote:',
                    value: item.lote.isNotEmpty ? item.lote : '-',
                  ),
                ),
                Expanded(
                  child: _InfoRow(
                    label: 'Qtde:',
                    value: _formatQtde(item.qtde),
                    valueStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatQtde(double value) {
    final hasDecimals = value.truncateToDouble() != value;
    return value.toStringAsFixed(hasDecimals ? 2 : 0);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueStyle});

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 85,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  valueStyle ??
                  const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
