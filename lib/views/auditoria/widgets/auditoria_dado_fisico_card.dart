import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/widgets/app_int_field.dart';
import 'auditoria_card.dart';

class AuditoriaDadoFisicoCard extends StatelessWidget {
  const AuditoriaDadoFisicoCard({
    super.key,
    required this.buscando,
    required this.salvando,
    required this.habilitado,
    required this.pesoController,
    required this.alturaController,
    required this.larguraController,
    required this.comprimentoController,
    required this.onSalvar,
  });

  final bool buscando;
  final bool salvando;
  final bool habilitado;
  final TextEditingController pesoController;
  final TextEditingController alturaController;
  final TextEditingController larguraController;
  final TextEditingController comprimentoController;
  final VoidCallback onSalvar;

  @override
  Widget build(BuildContext context) {
    final inputFormatters = <TextInputFormatter>[
      const DigitsCommaDotInputFormatter(),
      DecimalMaxDigitsFormatter(4),
    ];

    Widget campo(
      String label,
      TextEditingController controller, {
      String? suffixText,
    }) {
      return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) selectAllText(controller);
        },
        child: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: inputFormatters,
          onTap: () => selectAllText(controller),
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            isDense: true,
            suffixText: suffixText,
          ),
        ),
      );
    }

    return AuditoriaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Dados Físicos',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: (buscando || salvando || !habilitado) ? null : onSalvar,
                icon: salvando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                color: AppColors.primary,
                tooltip: 'Salvar',
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: campo('Peso', pesoController, suffixText: 'kg')),
              const SizedBox(width: 10),
              Expanded(
                child: campo('Altura', alturaController, suffixText: 'm'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: campo('Largura', larguraController, suffixText: 'm'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: campo(
                  'Comprimento',
                  comprimentoController,
                  suffixText: 'm',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
