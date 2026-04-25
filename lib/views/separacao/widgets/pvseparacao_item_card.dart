import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../controllers/separacao/pvseparacao_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/utils/data_formatar.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/utils/numero_formatar.dart';
import '../../../core/widgets/info_row.dart';
import '../../../core/functions/lotes_card_helpers.dart';
import '../../../models/hsaida/lote_saida_model.dart';
import '../../../models/prevenda/prevenda2_model.dart';

part 'pvseparacao_item_card_lote_row.dart';

class PvSeparacaoItemCard extends StatefulWidget {
  const PvSeparacaoItemCard({
    super.key,
    required this.idFilial,
    required this.idPrevenda,
    required this.item,
    required this.pvSeparacaoController,
    required this.lotes,
    required this.qtdeController,
    this.qtdeFocusNode,
    this.highlighted = false,
    this.onSalvar,
    this.onQtdeExcedida,
    this.isSalvando = false,
    this.decQtde = 3,
    this.romaneio = 0,
  });

  final int idFilial;
  final int idPrevenda;
  final PreVenda2Model item;
  final PvSeparacaoController pvSeparacaoController;
  final List<LoteSaidaModel> lotes;
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
  final List<_LoteRow> _loteRows = [];
  final Set<int> _savingLoteIndexes = {};
  final Map<int, String> _lastValidLoteQtde = {};

  @override
  void initState() {
    super.initState();
    _lastValidValue = widget.qtdeController.text;
    widget.qtdeController.addListener(_syncLastValidValue);
    _syncLotesFromWidget();
  }

  @override
  void didUpdateWidget(covariant PvSeparacaoItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!sameLotes(oldWidget.lotes, widget.lotes)) {
      _syncLotesFromWidget();
    }
  }

  @override
  void dispose() {
    widget.qtdeController.removeListener(_syncLastValidValue);
    for (final r in _loteRows) {
      r.loteController.dispose();
      r.validadeController.dispose();
      r.qtdeController.dispose();
    }
    super.dispose();
  }

  void _syncLotesFromWidget() {
    for (final r in _loteRows) {
      r.loteController.dispose();
      r.validadeController.dispose();
      r.qtdeController.dispose();
    }
    _loteRows.clear();
    _lastValidLoteQtde.clear();

    final sorted = sortLotes(widget.lotes);

    for (final l in sorted) {
      _loteRows.add(_LoteRow.fromModel(model: l, decQtde: widget.decQtde));
    }
    for (var i = 0; i < _loteRows.length; i++) {
      _lastValidLoteQtde[i] = _loteRows[i].qtdeController.text;
    }
    if (mounted) setState(() {});
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
    const eps = 0.000001;

    double? salvo;
    for (final r in widget.pvSeparacaoController.itens) {
      if (r.idFilial == widget.idFilial &&
          r.idPrevenda == widget.idPrevenda &&
          r.ordem == widget.item.ordem &&
          r.idProduto == widget.item.idProduto) {
        salvo = r.qtde;
        break;
      }
    }
    if (salvo == null) return false;
    if ((salvo - widget.item.qtde).abs() > eps) return false;

    final apiLotes = widget.item.lotesaida.isNotEmpty
        ? widget.item.lotesaida
              .map(
                (e) => e.copyWith(
                  idFilial: widget.idFilial,
                  idPrevenda: widget.idPrevenda,
                  idProduto: widget.item.idProduto,
                ),
              )
              .where((e) => e.lote.trim().isNotEmpty && e.qtde > 0)
              .toList()
        : (widget.item.lote.trim().isNotEmpty ||
              widget.item.validade.trim().isNotEmpty)
        ? [
            LoteSaidaModel(
              idFilial: widget.idFilial,
              idPrevenda: widget.idPrevenda,
              idProduto: widget.item.idProduto,
              lote: widget.item.lote,
              validade: widget.item.validade,
              fabricacao: DateTime.now()
                  .subtract(const Duration(days: 365))
                  .toIso8601String()
                  .substring(0, 10),
              qtde: salvo,
            ),
          ]
        : const <LoteSaidaModel>[];

    final localLotes = widget.pvSeparacaoController
        .lotesDoProduto(widget.item.idProduto)
        .where((e) => e.lote.trim().isNotEmpty && e.qtde > 0)
        .toList();

    final mergedMap = <String, LoteSaidaModel>{
      for (final l in apiLotes) '${l.lote}__${l.validade}': l,
      for (final l in localLotes) '${l.lote}__${l.validade}': l,
    };
    final lotesParaConferencia = mergedMap.values
        .where((e) => e.lote.trim().isNotEmpty && e.qtde > 0)
        .toList();

    if (widget.item.produto.controlelote == 1 ||
        lotesParaConferencia.isNotEmpty) {
      if (lotesParaConferencia.isEmpty) return false;
      final somaLotes = lotesParaConferencia.fold<double>(
        0.0,
        (sum, l) => sum + l.qtde,
      );
      if ((somaLotes - salvo).abs() > eps) return false;
    }

    final digitado = double.tryParse(
      widget.qtdeController.text.replaceAll(',', '.'),
    );
    if (digitado == null) return false;
    return (digitado - salvo).abs() <= eps;
  }

  bool get _temWms {
    final p = widget.item.produto;
    return p.wmsrua > 0;
  }

  String get _wmsFormatado {
    final p = widget.item.produto;
    final partes = <String>[
      if (p.wmsrua != 0) 'Rua: ${p.wmsrua}',
      if (p.wmsblc != 0) 'Blc: ${p.wmsblc}',
      if (p.wmsmod != 0) 'Mod: ${p.wmsmod}',
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

  void _adicionarLote() {
    _loteRows.add(_LoteRow.empty());
    _lastValidLoteQtde[_loteRows.length - 1] = '';
    setState(() {});
  }

  void _onLoteQtdeChanged(int index, String value) {
    if (value.trim().isEmpty) {
      _lastValidLoteQtde[index] = '';
      return;
    }

    final entered = double.tryParse(value.replaceAll(',', '.'));
    if (entered == null) return;

    final somaOutros = sumLotesExcept(
      _loteRows.map((r) => r.qtdeController.text.trim()).toList(),
      index,
    );
    final separado =
        double.tryParse(widget.qtdeController.text.replaceAll(',', '.')) ?? 0.0;
    final max = separado > 0 ? separado : widget.item.qtde;

    if (somaOutros + entered > max) {
      final last = _lastValidLoteQtde[index] ?? '';
      _loteRows[index].qtdeController.text = last;
      _loteRows[index].qtdeController.selection = TextSelection.fromPosition(
        TextPosition(offset: last.length),
      );
      AppSnackBar.erro(
        context,
        separado > 0
            ? 'A soma dos lotes não pode exceder a quantidade separada ($separado).'
            : 'A soma dos lotes não pode exceder a quantidade pedida (${widget.item.qtde}).',
      );
      return;
    }

    _lastValidLoteQtde[index] = value;
  }

  Future<void> _salvarLote(int index) async {
    final row = _loteRows[index];
    final lote = row.loteController.text.trim();
    final validadeTxt = row.validadeController.text.trim();
    final qtdeTxt = row.qtdeController.text.trim();

    if (lote.isEmpty) {
      AppSnackBar.erro(context, 'Informe o lote para salvar.');
      return;
    }
    if (qtdeTxt.isEmpty) {
      AppSnackBar.erro(context, 'Informe a quantidade do lote para salvar.');
      return;
    }

    final qtde = double.tryParse(qtdeTxt.replaceAll(',', '.'));
    if (qtde == null || qtde <= 0) {
      AppSnackBar.erro(context, 'Quantidade do lote inválida.');
      return;
    }

    if (validadeTxt.isNotEmpty &&
        DataFormatar.parseDdMmYyyy(validadeTxt) == null) {
      AppSnackBar.erro(context, 'Validade inválida (use DD/MM/AAAA).');
      return;
    }

    final validade = DataFormatar.toIsoDateFromDdMmYyyy(validadeTxt);

    final somaOutros = sumLotesExcept(
      _loteRows.map((r) => r.qtdeController.text.trim()).toList(),
      index,
    );
    final separado =
        double.tryParse(widget.qtdeController.text.replaceAll(',', '.')) ?? 0.0;
    final max = separado > 0 ? separado : widget.item.qtde;
    if (somaOutros + qtde > max) {
      AppSnackBar.erro(
        context,
        separado > 0
            ? 'A soma dos lotes não pode exceder a quantidade separada ($separado).'
            : 'A soma dos lotes não pode exceder a quantidade pedida (${widget.item.qtde}).',
      );
      return;
    }

    setState(() => _savingLoteIndexes.add(index));

    final model = LoteSaidaModel(
      idFilial: widget.idFilial,
      idPrevenda: widget.idPrevenda,
      idProduto: widget.item.idProduto,
      lote: lote,
      validade: validade,
      fabricacao: DateTime.now()
          .subtract(const Duration(days: 365))
          .toIso8601String()
          .substring(0, 10),
      qtde: qtde,
    );

    await widget.pvSeparacaoController.gravarLote(
      lote: model,
      oldLote: row.originalLote.isEmpty ? null : row.originalLote,
      oldValidade: row.originalValidade.isEmpty ? null : row.originalValidade,
    );

    if (!mounted) return;

    if (widget.pvSeparacaoController.error != null) {
      AppSnackBar.erro(
        context,
        widget.pvSeparacaoController.error ?? 'Não foi possível salvar o lote.',
      );
      setState(() => _savingLoteIndexes.remove(index));
      return;
    }

    await widget.pvSeparacaoController.listarLotes(
      widget.idFilial,
      widget.idPrevenda,
    );
    if (!mounted) return;

    final atualizados = widget.pvSeparacaoController
        .lotesDoProduto(widget.item.idProduto)
        .where((e) => e.lote.isNotEmpty && e.qtde > 0)
        .toList();

    for (final r in _loteRows) {
      r.loteController.dispose();
      r.validadeController.dispose();
      r.qtdeController.dispose();
    }
    _loteRows
      ..clear()
      ..addAll(
        sortLotes(
          atualizados,
        ).map((l) => _LoteRow.fromModel(model: l, decQtde: widget.decQtde)),
      );
    _lastValidLoteQtde
      ..clear()
      ..addEntries(
        List.generate(
          _loteRows.length,
          (i) => MapEntry(i, _loteRows[i].qtdeController.text),
        ),
      );
    widget.item.lotesaida
      ..clear()
      ..addAll(atualizados);

    setState(() => _savingLoteIndexes.remove(index));
    AppSnackBar.sucesso(context, 'Lote salvo com sucesso.');
  }

  Future<void> _deletarLote(int index) async {
    final row = _loteRows[index];
    if (row.originalLote.isEmpty && row.originalValidade.isEmpty) {
      row.loteController.dispose();
      row.validadeController.dispose();
      row.qtdeController.dispose();
      _loteRows.removeAt(index);
      setState(() {});
      return;
    }

    setState(() => _savingLoteIndexes.add(index));

    await widget.pvSeparacaoController.deletarLote(
      LoteSaidaModel(
        idFilial: widget.idFilial,
        idPrevenda: widget.idPrevenda,
        idProduto: widget.item.idProduto,
        lote: row.originalLote,
        validade: row.originalValidade,
        fabricacao: DateTime.now()
            .subtract(const Duration(days: 365))
            .toIso8601String()
            .substring(0, 10),
        qtde: 0,
      ),
    );

    if (!mounted) return;

    if (widget.pvSeparacaoController.error != null) {
      AppSnackBar.erro(
        context,
        widget.pvSeparacaoController.error ??
            'Não foi possível excluir o lote.',
      );
      setState(() => _savingLoteIndexes.remove(index));
      return;
    }

    final atualizados = widget.pvSeparacaoController
        .lotesDoProduto(widget.item.idProduto)
        .where((e) => e.lote.isNotEmpty && e.qtde > 0)
        .toList();

    for (final r in _loteRows) {
      r.loteController.dispose();
      r.validadeController.dispose();
      r.qtdeController.dispose();
    }
    _loteRows
      ..clear()
      ..addAll(
        sortLotes(
          atualizados,
        ).map((l) => _LoteRow.fromModel(model: l, decQtde: widget.decQtde)),
      );
    _lastValidLoteQtde
      ..clear()
      ..addEntries(
        List.generate(
          _loteRows.length,
          (i) => MapEntry(i, _loteRows[i].qtdeController.text),
        ),
      );
    widget.item.lotesaida
      ..clear()
      ..addAll(atualizados);

    setState(() => _savingLoteIndexes.remove(index));
    AppSnackBar.sucesso(context, 'Lote removido.');
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
                  child: InfoRow(
                    label: 'Código:',
                    value: '${widget.item.idProduto}',
                  ),
                ),
                Expanded(
                  child: InfoRow(label: 'Unidade:', value: widget.item.und),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InfoRow(
                    label: 'Preço:',
                    value: NumeroFormatar.moeda(widget.item.preco.toString()),
                  ),
                ),
                Expanded(
                  child: InfoRow(
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
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InfoRow(
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
                    child: InfoRow(
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
                    child: InfoRow(label: 'Localização:', value: _wmsFormatado),
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
                    enabled: widget.romaneio != 2 && !widget.isSalvando,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d,]')),
                      DecimalMaxDigitsFormatter(widget.decQtde),
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
            if (widget.item.produto.controlelote == 1) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  initiallyExpanded: false,
                  title: Text(
                    'Lotes # ${_loteRows.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: widget.romaneio == 2 ? null : _adicionarLote,
                        icon: const Icon(Icons.add),
                      ),
                    ),
                    if (_loteRows.isEmpty)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Nenhum lote informado.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    else
                      Column(
                        children: [
                          for (var i = 0; i < _loteRows.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildLoteRow(i),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoteRow(int index) {
    final row = _loteRows[index];
    final saving = _savingLoteIndexes.contains(index);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: row.loteController,
                  decoration: const InputDecoration(
                    labelText: 'Lote',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  enabled: widget.romaneio != 2 && !saving,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: row.validadeController,
                  decoration: const InputDecoration(
                    labelText: 'Validade',
                    hintText: 'DD/MM/AAAA',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  enabled: widget.romaneio != 2 && !saving,
                  inputFormatters: [DateDdMmYyyyFormatter()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: row.qtdeController,
                  decoration: InputDecoration(
                    labelText: 'Qtde',
                    border: OutlineInputBorder(),
                    isDense: true,
                    prefixIcon: IconButton(
                      onPressed: widget.romaneio == 2 || saving
                          ? null
                          : () => _salvarLote(index),
                      icon: saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              Icons.save_rounded,
                              size: 24,
                              color: widget.romaneio == 2
                                  ? Colors.grey
                                  : AppColors.primary,
                            ),
                    ),
                  ),
                  enabled: widget.romaneio != 2 && !saving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d,]')),
                    DecimalMaxDigitsFormatter(widget.decQtde),
                  ],
                  onTap: () => row.qtdeController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: row.qtdeController.text.length,
                  ),
                  onChanged: (value) => _onLoteQtdeChanged(index, value),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: widget.romaneio == 2 || saving
                    ? null
                    : () => _deletarLote(index),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
