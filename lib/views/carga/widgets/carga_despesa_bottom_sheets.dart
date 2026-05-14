import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/utils/data_formatar.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/utils/numero_formatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../models/carga/carga_despesas_model.dart';

class CargaDespesaDraft {
  const CargaDespesaDraft({required this.descricao, required this.valor});

  final String descricao;
  final double valor;
}

class CargaDespesaBottomSheet extends StatefulWidget {
  const CargaDespesaBottomSheet({super.key, required this.cargaId});

  final int cargaId;

  @override
  State<CargaDespesaBottomSheet> createState() =>
      _CargaDespesaBottomSheetState();
}

class _CargaDespesaBottomSheetState extends State<CargaDespesaBottomSheet> {
  final _descricaoCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();

  @override
  void dispose() {
    _descricaoCtrl.dispose();
    _valorCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    final descricao = _descricaoCtrl.text.trim();
    final valorRaw = _valorCtrl.text.trim();
    final valor = NumeroFormatar.tryParse(valorRaw);

    if (descricao.isEmpty) {
      AppSnackBar.erro(context, 'Informe a descrição.');
      return;
    }
    if (valor == null || valor <= 0) {
      AppSnackBar.erro(context, 'Informe um valor válido.');
      return;
    }

    Navigator.pop(
      context,
      CargaDespesaDraft(descricao: descricao, valor: valor),
    );
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
            'Lançar despesa • Carga ${widget.cargaId}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descricaoCtrl,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              LengthLimitingTextInputFormatter(100),
              UpperCaseTextFormatter(),
            ],
            decoration: const InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _valorCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              const DigitsCommaDotInputFormatter(),
              DecimalMaxDigitsFormatter(2),
            ],
            decoration: const InputDecoration(
              labelText: 'Valor',
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

class CargaDespesasBottomSheet extends StatefulWidget {
  const CargaDespesasBottomSheet({super.key, required this.cargaId});

  final int cargaId;

  @override
  State<CargaDespesasBottomSheet> createState() =>
      _CargaDespesasBottomSheetState();
}

class _CargaDespesasBottomSheetState extends State<CargaDespesasBottomSheet> {
  var _loading = false;
  String? _error;
  List<CargaDespesaModel> _itens = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  String _formatarData(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '';
    final dt = DateTime.tryParse(v);
    if (dt != null) return DataFormatar.formatDtDDMMYY(dt);
    if (v.length >= 10) {
      final dt2 = DateTime.tryParse(v.substring(0, 10));
      if (dt2 != null) return DataFormatar.formatDtDDMMYY(dt2);
    }
    return v;
  }

  Future<void> _carregar() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final deps = AppScope.of(context);
      final baseUrl = deps.parametroController.parametro.url.trim();
      if (baseUrl.isEmpty) {
        throw Exception('Configure a URL da API antes de consultar.');
      }

      final itens = await deps.cargaDespesaService.consultarPorCarga(
        baseUrl: baseUrl,
        idCarga: widget.cargaId,
      );

      if (!mounted) return;
      setState(() {
        _itens = itens;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Despesas • Carga ${widget.cargaId}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _loading ? null : _carregar,
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_outlined),
                  tooltip: 'Atualizar',
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!.replaceAll('Exception:', '').trim(),
                style: const TextStyle(color: AppColors.error),
              ),
            ],
            const SizedBox(height: 8),
            Flexible(
              child: _itens.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Text('Nenhuma despesa lançada para esta carga.'),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _itens.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final d = _itens[index];
                        return ListTile(
                          dense: true,
                          title: Text(
                            d.descricao,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(_formatarData(d.data)),
                          trailing: Text(
                            NumeroFormatar.moeda(
                              d.valor.toString(),
                              simbolo: 'R\$',
                            ),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
