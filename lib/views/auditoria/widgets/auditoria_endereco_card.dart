import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_int_field.dart';
import 'auditoria_card.dart';

class AuditoriaEnderecoCard extends StatelessWidget {
  const AuditoriaEnderecoCard({
    super.key,
    required this.buscando,
    required this.salvando,
    required this.habilitado,
    required this.localizacaoController,
    required this.apanhaRuaController,
    required this.apanhaBlcController,
    required this.apanhaModController,
    required this.apanhaNivController,
    required this.apanhaAptController,
    required this.pulmaoRuaController,
    required this.pulmaoBlcController,
    required this.pulmaoModController,
    required this.pulmaoNivController,
    required this.pulmaoAptController,
    required this.onSalvar,
  });

  final bool buscando;
  final bool salvando;
  final bool habilitado;
  final TextEditingController localizacaoController;
  final TextEditingController apanhaRuaController;
  final TextEditingController apanhaBlcController;
  final TextEditingController apanhaModController;
  final TextEditingController apanhaNivController;
  final TextEditingController apanhaAptController;
  final TextEditingController pulmaoRuaController;
  final TextEditingController pulmaoBlcController;
  final TextEditingController pulmaoModController;
  final TextEditingController pulmaoNivController;
  final TextEditingController pulmaoAptController;
  final VoidCallback onSalvar;

  @override
  Widget build(BuildContext context) {
    return AuditoriaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) selectAllText(localizacaoController);
                  },
                  child: TextField(
                    controller: localizacaoController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [LengthLimitingTextInputFormatter(60)],
                    onTap: () => selectAllText(localizacaoController),
                    decoration: const InputDecoration(
                      labelText: 'Localização',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
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
          const SizedBox(height: 10),
          _AuditoriaEnderecoEditor(
            titulo: 'Endereço Apanha',
            ruaController: apanhaRuaController,
            blcController: apanhaBlcController,
            modController: apanhaModController,
            nivController: apanhaNivController,
            aptController: apanhaAptController,
          ),
          const SizedBox(height: 10),
          _AuditoriaEnderecoEditor(
            titulo: 'Endereço Pulmão',
            ruaController: pulmaoRuaController,
            blcController: pulmaoBlcController,
            modController: pulmaoModController,
            nivController: pulmaoNivController,
            aptController: pulmaoAptController,
          ),
        ],
      ),
    );
  }
}

class _AuditoriaEnderecoEditor extends StatelessWidget {
  const _AuditoriaEnderecoEditor({
    required this.titulo,
    required this.ruaController,
    required this.blcController,
    required this.modController,
    required this.nivController,
    required this.aptController,
  });

  final String titulo;
  final TextEditingController ruaController;
  final TextEditingController blcController;
  final TextEditingController modController;
  final TextEditingController nivController;
  final TextEditingController aptController;

  @override
  Widget build(BuildContext context) {
    final inputFormatters = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(3),
      TextInputFormatter.withFunction((oldValue, newValue) {
        final text = newValue.text;
        if (text.isEmpty) return newValue;
        final v = int.tryParse(text);
        if (v == null) return oldValue;
        if (v > 999) return oldValue;
        return newValue;
      }),
    ];

    Widget campo(
      String label,
      TextEditingController controller, {
      TextInputType keyboardType = TextInputType.number,
    }) {
      return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) selectAllText(controller);
        },
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onTap: () => selectAllText(controller),
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: campo('Rua', ruaController)),
            const SizedBox(width: 8),
            Expanded(child: campo('Blc', blcController)),
            const SizedBox(width: 8),
            Expanded(child: campo('Mod', modController)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: campo('Niv', nivController)),
            const SizedBox(width: 8),
            Expanded(child: campo('Apt', aptController)),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
