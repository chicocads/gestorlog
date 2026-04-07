import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/data_formatar.dart';
import '../../../models/prevenda/prevenda_model.dart';

class PvSeparacaoFiltroBarra extends StatelessWidget {
  const PvSeparacaoFiltroBarra({
    super.key,
    required this.data1,
    required this.data2,
    required this.onTap,
    required this.cargaController,
    required this.onBuscar,
    required this.statusSelecionado,
    required this.onStatusChanged,
  });

  final DateTime? data1;
  final DateTime? data2;
  final VoidCallback onTap;
  final TextEditingController cargaController;
  final VoidCallback onBuscar;
  final StatusPV statusSelecionado;
  final ValueChanged<StatusPV> onStatusChanged;

  static const _statusLabels = {
    StatusPV.orcamento: 'Orçamento',
    StatusPV.confirmado: 'Confirmado',
    StatusPV.fechado: 'Fechado',
    StatusPV.cancelado: 'Cancelado',
  };

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
          // Linha período
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  //const Icon(
                  //  Icons.filter_list,
                  //  size: 18,
                  //  color: AppColors.primary,
                  //),
                  //const SizedBox(width: 8),
                  Text(
                    data1 != null && data2 != null
                        ? 'Período: ${DataFormatar.formatDate(data1!)}  →  ${DataFormatar.formatDate(data2!)}'
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
          // Linha Nº Carga + Status
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
                    controller: cargaController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onTap: () => cargaController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: cargaController.text.length,
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
                Expanded(
                  flex: 3,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      labelStyle: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<StatusPV>(
                        value: statusSelecionado,
                        isDense: true,
                        isExpanded: true,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                        items: _statusLabels.entries
                            .map(
                              (e) => DropdownMenuItem<StatusPV>(
                                value: e.key,
                                child: Text(e.value),
                              ),
                            )
                            .toList(),
                        onChanged: (s) {
                          if (s != null) onStatusChanged(s);
                        },
                      ),
                    ),
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
