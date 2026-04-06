import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
class PvEntregaFiltroBarra extends StatelessWidget {
  const PvEntregaFiltroBarra({
    super.key,
    this.carregamento = 0,
    required this.prevendaController,
    required this.onBuscar,
    required this.entregueSelecionado,
    required this.onEntregueChanged,
  });

  final int carregamento;
  final TextEditingController prevendaController;
  final VoidCallback onBuscar;
  final int entregueSelecionado;
  final ValueChanged<int> onEntregueChanged;

  static const _entregueLabels = {0: 'Não', 1: 'Sim'};

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.entrega.withValues(alpha: 0.06),
        border: const Border(
          bottom: BorderSide(color: AppColors.entrega, width: 0.5),
        ),
      ),
      child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                if (carregamento > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_shipping_outlined,
                          size: 18,
                          color: AppColors.entrega,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Carga Nº $carregamento',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.entrega,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 18,
                  color: AppColors.entrega,
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: prevendaController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onTap: () => prevendaController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: prevendaController.text.length,
                    ),
                    onSubmitted: (_) => onBuscar(),
                    decoration: const InputDecoration(
                      labelText: 'Nº Prevenda',
                      labelStyle: TextStyle(
                        fontSize: 13,
                        color: AppColors.entrega,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Entrega',
                      labelStyle: TextStyle(
                        fontSize: 13,
                        color: AppColors.entrega,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: entregueSelecionado,
                        isDense: true,
                        isExpanded: true,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                        items: _entregueLabels.entries
                            .map(
                              (e) => DropdownMenuItem<int>(
                                value: e.key,
                                child: Text(e.value),
                              ),
                            )
                            .toList(),
                        onChanged: (s) {
                          if (s != null) onEntregueChanged(s);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: onBuscar,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.entrega,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Buscar', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
