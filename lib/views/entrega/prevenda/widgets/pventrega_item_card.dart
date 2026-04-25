import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/info_row.dart';
import '../../../../models/prevenda/prevenda2_model.dart';

class PvEntregaItemCard extends StatelessWidget {
  const PvEntregaItemCard({
    super.key,
    required this.item,
    this.highlighted = false,
  });

  final PreVenda2Model item;
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
                    item.produto.nome,
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
                  child: InfoRow(label: 'Código:', value: '${item.idProduto}'),
                ),
                Expanded(
                  child: InfoRow(label: 'Unidade:', value: item.und),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InfoRow(
                    label: 'Marca:',
                    value: item.produto.marca
                        .padRight(10)
                        .substring(0, 10)
                        .trim(),
                    valueStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: InfoRow(
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
