import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/numero_formatar.dart';
import '../../../models/prevenda/prevenda2_model.dart';

class PvSeparacaoItemCard extends StatefulWidget {
  const PvSeparacaoItemCard({
    super.key,
    required this.item,
    required this.qtdeController,
    this.qtdeFocusNode,
    this.highlighted = false,
    this.onSalvar,
    this.onQtdeExcedida,
    this.isSalvando = false,
    this.decQtde = 3,
    this.romaneio = 0,
  });

  final PreVenda2Model item;
  final TextEditingController qtdeController;
  final FocusNode? qtdeFocusNode;
  final bool highlighted;
  final VoidCallback? onSalvar;
  final VoidCallback? onQtdeExcedida;
  final bool isSalvando;
  final int decQtde;
  final int romaneio;

  @override
  State<PvSeparacaoItemCard> createState() => _PvSeparacaoItemCardState();
}

class _PvSeparacaoItemCardState extends State<PvSeparacaoItemCard> {
  String _lastValidValue = '';

  @override
  void initState() {
    super.initState();
    _lastValidValue = widget.qtdeController.text;
    widget.qtdeController.addListener(_syncLastValidValue);
  }

  @override
  void dispose() {
    widget.qtdeController.removeListener(_syncLastValidValue);
    super.dispose();
  }

  void _syncLastValidValue() {
    final value = widget.qtdeController.text;
    final entered = double.tryParse(value.replaceAll(',', '.'));
    if (entered == null || entered <= widget.item.qtde) {
      _lastValidValue = value;
    }
    setState(() {});
  }

  bool get _conferido {
    final separado = double.tryParse(
      widget.qtdeController.text.replaceAll(',', '.'),
    );
    return separado != null && separado > 0 && separado == widget.item.qtde;
  }

  bool get _temWms {
    final p = widget.item.produto;
    return p.wmsrua > 0;
  }

  String get _wmsFormatado {
    final p = widget.item.produto;
    final partes = <String>[
      if (p.wmsrua != 0) 'Rua: ${p.wmsrua}',
      if (p.wmsmod != 0) 'Mod: ${p.wmsmod}',
      if (p.wmsblc != 0) 'Blc: ${p.wmsblc}',
      if (p.wmsniv != 0) 'Niv: ${p.wmsniv}',
      if (p.wmsapt != 0) 'Apt: ${p.wmsapt}',
      if (p.wmsgvt != 0) 'Gvt: ${p.wmsgvt}',
    ];
    return partes.join(' | ');
  }

  void _onQtdeChanged(String value) {
    final entered = double.tryParse(value.replaceAll(',', '.'));
    if (entered != null && entered > widget.item.qtde) {
      widget.qtdeController.text = _lastValidValue;
      widget.qtdeController.selection = TextSelection.fromPosition(
        TextPosition(offset: _lastValidValue.length),
      );
      widget.onQtdeExcedida?.call();
    } else {
      _lastValidValue = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: _conferido ? const Color(0xFFE8F5E9) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: widget.highlighted
            ? const BorderSide(color: AppColors.success, width: 2)
            : _conferido
            ? const BorderSide(color: AppColors.success, width: 1)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.produto.nome,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _InfoRow(
                    label: 'Código:',
                    value: '${widget.item.idproduto}',
                  ),
                ),
                Expanded(
                  child: _InfoRow(label: 'Unidade:', value: widget.item.und),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _InfoRow(
                    label: 'Preço:',
                    value: NumeroFormatar.moeda(widget.item.preco.toString()),
                  ),
                ),
                Expanded(
                  child: _InfoRow(
                    label: 'Marca:',
                    value: widget.item.produto.marca
                        .padRight(10)
                        .substring(0, 10),
                    valueStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                // Expanded(
                //   child: _InfoRow(
                //     label: 'Qtde Pedida:',
                //     value: widget.item.qtde.toStringAsFixed(
                //       widget.item.qtde.truncateToDouble() == widget.item.qtde
                //           ? 0
                //           : 2,
                //     ),
                //     valueStyle: const TextStyle(
                //       fontSize: 13,
                //       fontWeight: FontWeight.w600,
                //       color: AppColors.textPrimary,
                //     ),
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _InfoRow(
                    label: 'Codigo Barra:',
                    value: widget.item.produto.codigoalfa,
                  ),
                ),
              ],
            ),
            if (widget.item.produto.localizacao.trim().isNotEmpty && !_temWms)
              Row(
                children: [
                  Expanded(
                    child: _InfoRow(
                      label: 'Localização:',
                      value: widget.item.produto.localizacao,
                    ),
                  ),
                ],
              )
            else if (_temWms)
              Row(
                children: [
                  Expanded(
                    child: _InfoRow(
                      label: 'Localização:',
                      value: _wmsFormatado,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Pedido',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    child: Text(
                      widget.item.qtde.toStringAsFixed(
                        widget.item.qtde.truncateToDouble() == widget.item.qtde
                            ? 0
                            : 2,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: widget.qtdeController,
                    focusNode: widget.qtdeFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Separado',
                      border: const OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: IconButton(
                        onPressed:
                            widget.isSalvando ||
                                widget.onSalvar == null ||
                                widget.romaneio == 2
                            ? null
                            : widget.onSalvar,
                        icon: widget.isSalvando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.save_rounded,
                                size: 24,
                                color: widget.onSalvar == null
                                    ? Colors.grey
                                    : AppColors.primary,
                              ),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d,]')),
                      _DecimalMaxDigitsFormatter(widget.decQtde),
                    ],
                    onTap: () =>
                        widget.qtdeController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: widget.qtdeController.text.length,
                        ),
                    onChanged: _onQtdeChanged,
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

class _DecimalMaxDigitsFormatter extends TextInputFormatter {
  _DecimalMaxDigitsFormatter(this.maxDecimals);

  final int maxDecimals;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final sepIndex = text.indexOf(',');

    // Block multiple commas
    if (sepIndex != -1 && text.indexOf(',', sepIndex + 1) > sepIndex) {
      return oldValue;
    }

    // Limit decimal places
    if (sepIndex != -1 && text.length - sepIndex - 1 > maxDecimals) {
      return oldValue;
    }

    return newValue;
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueStyle});

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 85,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  valueStyle ??
                  const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
