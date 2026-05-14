import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/utils/numero_formatar.dart';
import '../../../core/widgets/custom_button.dart';

class CargaKmDraft {
  const CargaKmDraft({required this.kmSaida, required this.kmChegada});

  final double kmSaida;
  final double kmChegada;
}

class CargaKmBottomSheet extends StatefulWidget {
  const CargaKmBottomSheet({
    super.key,
    required this.cargaId,
    this.kmSaida,
    this.kmChegada,
  });

  final int cargaId;
  final double? kmSaida;
  final double? kmChegada;

  @override
  State<CargaKmBottomSheet> createState() => _CargaKmBottomSheetState();
}

class _CargaKmBottomSheetState extends State<CargaKmBottomSheet> {
  late final TextEditingController _kmSaidaCtrl;
  late final TextEditingController _kmChegadaCtrl;

  String _formatKm(double? value) {
    if (value == null || value == 0) return '';
    return value == value.truncateToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  @override
  void initState() {
    super.initState();
    _kmSaidaCtrl = TextEditingController(text: _formatKm(widget.kmSaida));
    _kmChegadaCtrl = TextEditingController(text: _formatKm(widget.kmChegada));
  }

  @override
  void dispose() {
    _kmSaidaCtrl.dispose();
    _kmChegadaCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    final kmSaida = NumeroFormatar.tryParse(_kmSaidaCtrl.text.trim());
    final kmChegada = NumeroFormatar.tryParse(_kmChegadaCtrl.text.trim());

    if (kmSaida == null || kmSaida <= 0) {
      AppSnackBar.erro(context, 'Informe o KM de saída.');
      return;
    }
    if (kmChegada == null || kmChegada <= 0) {
      AppSnackBar.erro(context, 'Informe o KM de chegada.');
      return;
    }
    if (kmSaida >= kmChegada) {
      AppSnackBar.erro(context, 'KM de saída deve ser menor que o KM de chegada.');
      return;
    }

    Navigator.pop(context, CargaKmDraft(kmSaida: kmSaida, kmChegada: kmChegada));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Informar KM • Carga ${widget.cargaId}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _kmSaidaCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              const DigitsCommaDotInputFormatter(),
              DecimalMaxDigitsFormatter(1),
            ],
            decoration: const InputDecoration(
              labelText: 'KM Saída',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _kmChegadaCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              const DigitsCommaDotInputFormatter(),
              DecimalMaxDigitsFormatter(1),
            ],
            decoration: const InputDecoration(
              labelText: 'KM Chegada',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 14),
          CustomButton(
            label: 'Salvar',
            icon: Icons.save_outlined,
            onPressed: _salvar,
          ),
        ],
      ),
    );
  }
}
