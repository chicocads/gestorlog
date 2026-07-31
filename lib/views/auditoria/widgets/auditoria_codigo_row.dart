import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/string_sanitizer.dart';
import '../../../core/widgets/app_int_field.dart';

class AuditoriaCodigoRow extends StatelessWidget {
  const AuditoriaCodigoRow({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.buscando,
    required this.onBuscar,
    required this.onLimpar,
    required this.onAbrirPesquisaNome,
    required this.onAbrirScanner,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool buscando;
  final VoidCallback onBuscar;
  final VoidCallback onLimpar;
  final VoidCallback onAbrirPesquisaNome;
  final VoidCallback onAbrirScanner;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onTap: () => selectAllText(controller),
            onSubmitted: (_) => onBuscar(),
            onChanged: (value) {
              final v = value.trim();
              if (!StringSanitizer.isDigits(v)) return;
              if (v.length != 13 && v.length != 14) return;
              if (!StringSanitizer.isValidEan(v)) return;
              onBuscar();
            },
            decoration: InputDecoration(
              labelText: 'Código de barras',
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: IconButton(
                onPressed: buscando ? null : onBuscar,
                icon: buscando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search_outlined),
                color: AppColors.primary,
                tooltip: 'Buscar',
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 48,
          height: 48,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: buscando ? null : onLimpar,
              icon: const Icon(Icons.cleaning_services_outlined),
              color: Colors.white,
              tooltip: 'Limpar',
            ),
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 48,
          height: 48,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: buscando ? null : onAbrirPesquisaNome,
              icon: const Icon(Icons.list_alt_outlined),
              color: Colors.white,
              tooltip: 'Buscar por nome',
            ),
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 48,
          height: 48,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: buscando ? null : onAbrirScanner,
              icon: const Icon(Icons.qr_code_scanner_outlined),
              color: Colors.white,
              tooltip: 'Ler código',
            ),
          ),
        ),
      ],
    );
  }
}
