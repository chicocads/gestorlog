import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';

class CarregamentoFiltroBarra extends StatelessWidget {
  const CarregamentoFiltroBarra({
    super.key,
    required this.data1,
    required this.data2,
    required this.onTap,
    required this.numeroController,
    required this.onBuscar,
  });

  final DateTime? data1;
  final DateTime? data2;
  final VoidCallback onTap;
  final TextEditingController numeroController;
  final VoidCallback onBuscar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        border: const Border(
          bottom: BorderSide(color: AppColors.primary, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Text(
                    data1 != null && data2 != null
                        ? 'Período: ${DateFormatter.formatDate(data1!)}  →  ${DateFormatter.formatDate(data2!)}'
                        : 'Período: todos',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.edit_calendar_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: numeroController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onTap: () => numeroController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: numeroController.text.length,
                    ),
                    onSubmitted: (_) => onBuscar(),
                    decoration: const InputDecoration(
                      labelText: 'Nº Carga',
                      labelStyle: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: onBuscar,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Buscar', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
