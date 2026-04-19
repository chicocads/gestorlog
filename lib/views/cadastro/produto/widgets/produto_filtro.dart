import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';

class ProdutoFiltro extends StatelessWidget {
  const ProdutoFiltro({
    super.key,
    required this.codigoController,
    required this.nomeController,
    required this.onBuscar,
  });

  final TextEditingController codigoController;
  final TextEditingController nomeController;
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.qr_code_scanner_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: codigoController,
                  keyboardType: TextInputType.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  onSubmitted: (_) => onBuscar(),
                  decoration: const InputDecoration(
                    labelText: 'Código / Barra',
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
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: nomeController,
                  keyboardType: TextInputType.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(80)],
                  onSubmitted: (_) => onBuscar(),
                  decoration: const InputDecoration(
                    labelText: 'Nome do produto',
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
            ],
          ),
        ],
      ),
    );
  }
}
