import 'package:flutter/material.dart';
import 'package:gestorlog/core/utils/numero_formatar.dart';
import 'package:gestorlog/core/widgets/info_row.dart';
import '../../../../app/routes.dart';
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
                  child: InfoRow(label: 'Código:', value: '${item.idProduto}'),
                ),
                Expanded(
                  child: InfoRow(label: 'Unidade:', value: item.undvenda),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InfoRow(
                    label: 'Lote:',
                    value: item.lote.isNotEmpty ? item.lote : '-',
                  ),
                ),
                Expanded(
                  child: InfoRow(
                    label: 'Qtde:',
                    value: NumeroFormatar.qtde(
                      item.qtde,
                      decQtde: AppScope.of(context)
                          .parametroController
                          .parametro
                          .decQtde,
                    ),
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
}
