import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/utils/data_formatar.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/widgets/app_int_field.dart';
import '../../../core/widgets/info_row.dart';
import '../../../models/diversos/auditoria_model.dart';

typedef AuditoriaCardBuilder = Widget Function(Widget child);

class AuditoriaLotesTab extends StatefulWidget {
  const AuditoriaLotesTab({
    super.key,
    required this.buscando,
    required this.auditoria,
    required this.cardBuilder,
    required this.formatValidade,
    required this.formatQtd,
  });

  final bool buscando;
  final AuditoriaLogisticaModel? auditoria;
  final AuditoriaCardBuilder cardBuilder;
  final String Function(String raw) formatValidade;
  final String Function(double value) formatQtd;

  @override
  State<AuditoriaLotesTab> createState() => _AuditoriaLotesTabState();
}

class _AuditoriaLotesTabState extends State<AuditoriaLotesTab> {
  final Set<int> _savingIndexes = {};
  List<_LoteEditControllers> _controllers = [];

  @override
  void initState() {
    super.initState();
    _syncControllers(widget.auditoria);
  }

  @override
  void didUpdateWidget(covariant AuditoriaLotesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    final codigo = widget.auditoria?.codigo;
    final oldCodigo = oldWidget.auditoria?.codigo;
    final newLength = widget.auditoria?.lotes.length ?? 0;
    final oldLength = oldWidget.auditoria?.lotes.length ?? 0;
    if (codigo != oldCodigo || newLength != oldLength) {
      _syncControllers(widget.auditoria);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncControllers(AuditoriaLogisticaModel? auditoria) {
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers = [];
    _savingIndexes.clear();

    if (auditoria == null || auditoria.lotes.isEmpty) {
      if (mounted) setState(() {});
      return;
    }

    _controllers = auditoria.lotes
        .map(
          (l) => _LoteEditControllers(
            fabricacao: TextEditingController(
              text: _formatDateShort(l.fabricacao),
            ),
            validade: TextEditingController(
              text: _formatDateShort(l.validade),
            ),
            saldo: TextEditingController(text: widget.formatQtd(l.saldo)),
          ),
        )
        .toList();

    if (mounted) setState(() {});
  }

  double _parseSaldo(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return 0.0;
    return double.tryParse(raw.replaceAll(',', '.')) ?? 0.0;
  }

  String _formatDateShort(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '';

    if (v.contains('/')) {
      final parts = v.split('/');
      if (parts.length == 3) {
        final dd = parts[0].padLeft(2, '0');
        final mm = parts[1].padLeft(2, '0');
        final yyRaw = parts[2];
        final yy = yyRaw.length >= 2 ? yyRaw.substring(yyRaw.length - 2) : yyRaw;
        return '$dd/$mm/$yy';
      }
      return v;
    }

    final dt = DateTime.tryParse(v);
    if (dt != null) {
      return DataFormatar.formatDateShort(dt);
    }

    if (v.length >= 10 && v.codeUnitAt(4) == 45 && v.codeUnitAt(7) == 45) {
      final dt2 = DateTime.tryParse(v.substring(0, 10));
      if (dt2 != null) return DataFormatar.formatDateShort(dt2);
    }

    return v;
  }

  Future<void> _salvarLote(int index) async {
    if (widget.buscando) return;
    final auditoria = widget.auditoria;
    if (auditoria == null) return;
    if (index < 0 || index >= auditoria.lotes.length) return;
    if (_savingIndexes.contains(index)) return;

    final maxPermitido = (auditoria.saldo - auditoria.reserva).isFinite
        ? (auditoria.saldo - auditoria.reserva)
        : 0.0;
    final limite = maxPermitido < 0 ? 0.0 : maxPermitido;
    final totalLotes = _controllers.fold<double>(
      0.0,
      (sum, c) => sum + _parseSaldo(c.saldo.text),
    );
    if (totalLotes > limite + 0.000001) {
      AppSnackBar.erro(
        context,
        'Soma das quantidades dos lotes (${widget.formatQtd(totalLotes)}) '
        'não pode ser maior que saldo - reserva (${widget.formatQtd(limite)}).',
      );
      return;
    }

    final deps = AppScope.of(context);
    final baseUrl = deps.parametroController.parametro.url.trim();
    if (baseUrl.isEmpty) {
      AppSnackBar.erro(context, 'Configure a URL da API antes de salvar.');
      return;
    }

    final original = auditoria.lotes[index];
    final edited = _controllers[index];
    final atualizado = original.copyWith(
      fabricacao: edited.fabricacao.text.trim(),
      validade: edited.validade.text.trim(),
      saldo: _parseSaldo(edited.saldo.text),
    );

    setState(() => _savingIndexes.add(index));
    try {
      final ok = await deps.auditoriaService.salvarAuditoriaLogisticaLoteProduto(
        baseUrl: baseUrl,
        lote: atualizado,
      );
      if (!mounted) return;
      if (ok) {
        AppSnackBar.sucesso(context, 'Lote salvo com sucesso.');
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao salvar lote: $e');
    } finally {
      if (mounted) setState(() => _savingIndexes.remove(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buscando) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final a = widget.auditoria;
    if (a == null) {
      return const Center(
        child: Text(
          'Consulte um produto para ver os lotes.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    if (a.lotes.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum lote retornado.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: a.lotes.length,
      separatorBuilder: (_, index) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final lote = a.lotes[index];
        final saving = _savingIndexes.contains(index);
        final ctrls = _controllers[index];
        return widget.cardBuilder(
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InfoRow(
                      label: 'Lote',
                      value: lote.lote.trim().isNotEmpty ? lote.lote : '-',
                      labelWidth: 52,
                    ),
                  ),
                  IconButton(
                    onPressed: saving ? null : () => _salvarLote(index),
                    icon: saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_rounded),
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
                        if (hasFocus) selectAllText(ctrls.fabricacao);
                      },
                      child: TextField(
                        controller: ctrls.fabricacao,
                        enabled: !saving,
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [DateDdMmYyyyFormatter()],
                        onTap: () => selectAllText(ctrls.fabricacao),
                        decoration: const InputDecoration(
                          labelText: 'Fabricação',
                          hintText: 'DD/MM/AA',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (hasFocus) selectAllText(ctrls.validade);
                      },
                      child: TextField(
                        controller: ctrls.validade,
                        enabled: !saving,
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [DateDdMmYyyyFormatter()],
                        onTap: () => selectAllText(ctrls.validade),
                        decoration: const InputDecoration(
                          labelText: 'Validade',
                          hintText: 'DD/MM/AA',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (hasFocus) selectAllText(ctrls.saldo);
                      },
                      child: TextField(
                        controller: ctrls.saldo,
                        enabled: !saving,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          const DigitsCommaDotInputFormatter(),
                          DecimalMaxDigitsFormatter(2),
                        ],
                        onTap: () => selectAllText(ctrls.saldo),
                        decoration: const InputDecoration(
                          labelText: 'Quantidade',
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
      },
    );
  }
}

class _LoteEditControllers {
  _LoteEditControllers({
    required this.fabricacao,
    required this.validade,
    required this.saldo,
  });

  final TextEditingController fabricacao;
  final TextEditingController validade;
  final TextEditingController saldo;

  void dispose() {
    fabricacao.dispose();
    validade.dispose();
    saldo.dispose();
  }
}
