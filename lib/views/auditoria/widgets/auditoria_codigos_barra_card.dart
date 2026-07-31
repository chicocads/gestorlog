import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_int_field.dart';
import 'auditoria_card.dart';

class AuditoriaCodigosBarraCard extends StatelessWidget {
  const AuditoriaCodigosBarraCard({
    super.key,
    required this.buscando,
    required this.salvando,
    required this.habilitado,
    required this.eanController,
    required this.dun14Controller,
    required this.onSalvar,
  });

  final bool buscando;
  final bool salvando;
  final bool habilitado;
  final TextEditingController eanController;
  final TextEditingController dun14Controller;
  final VoidCallback onSalvar;

  @override
  Widget build(BuildContext context) {
    return AuditoriaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Códigos de Barra',
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
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) selectAllText(eanController);
                  },
                  child: TextField(
                    controller: eanController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onTap: () => selectAllText(eanController),
                    decoration: const InputDecoration(
                      labelText: 'EAN',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) selectAllText(dun14Controller);
                  },
                  child: TextField(
                    controller: dun14Controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onTap: () => selectAllText(dun14Controller),
                    decoration: const InputDecoration(
                      labelText: 'DUN14',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
