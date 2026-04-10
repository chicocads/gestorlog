import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../controllers/separacao/pvseparacao_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_snack_bar.dart';
import '../../models/Separacao/separacao_model.dart';
import '../../models/lote_saida_model.dart';
import '../../models/prevenda/prevenda_model.dart';
import '../../models/prevenda/prevenda2_model.dart';
import '../../app/routes.dart';
import '../../services/separacao/request_separacao.dart';
import 'widgets/pvseparacao_item_card.dart';

class PvSeparacaoItensView extends StatefulWidget {
  const PvSeparacaoItensView({
    super.key,
    required this.prevenda,
    required this.pvseparacaoController,
  });

  final PreVendaModel prevenda;
  final PvSeparacaoController pvseparacaoController;

  @override
  State<PvSeparacaoItensView> createState() => _PvSeparacaoItensViewState();
}

class _PvSeparacaoItensViewState extends State<PvSeparacaoItensView> {
  late final List<TextEditingController> _qtdeControllers;
  late final List<FocusNode> _qtdeFocusNodes;
  late final List<GlobalKey> _cardKeys;
  late final List<int> _sortedIndices;
  final _scrollController = ScrollController();
  final _barcodeController = TextEditingController();
  final _barcodeFocus = FocusNode();
  int? _highlightedIndex;
  bool _mostrandoLeitor = false;
  int? _salvandoIndex;
  bool _apagando = false;
  bool _finalizando = false;
  bool _finalizado = false;

  int _pow10(int exp) {
    var v = 1;
    for (var i = 0; i < exp; i++) {
      v *= 10;
    }
    return v;
  }

  int _scaleQtde(double value, int decQtde) {
    final factor = _pow10(decQtde);
    return (value * factor).round();
  }

  List<LoteSaidaModel> _mergedLotesDoItem(PreVenda2Model item) {
    final idFilial = widget.prevenda.idFilial;
    final idPrevenda = widget.prevenda.idPrevenda;

    final apiLotes = item.lotesaida.isNotEmpty
        ? item.lotesaida
            .map(
              (e) => e.copyWith(
                idFilial: idFilial,
                idPrevenda: idPrevenda,
                idProduto: item.idproduto,
              ),
            )
            .toList()
        : (item.lote.trim().isNotEmpty || item.validade.trim().isNotEmpty)
            ? [
                LoteSaidaModel(
                  idFilial: idFilial,
                  idPrevenda: idPrevenda,
                  idProduto: item.idproduto,
                  lote: item.lote,
                  validade: item.validade,
                  qtde: item.qtdesep > 0 ? item.qtdesep : 0.0,
                ),
              ]
            : const <LoteSaidaModel>[];

    final localLotes = widget.pvseparacaoController.lotesDoProduto(item.idproduto);
    final mergedMap = <String, LoteSaidaModel>{
      for (final l in apiLotes) '${l.lote}__${l.validade}': l,
      for (final l in localLotes) '${l.lote}__${l.validade}': l,
    };
    return mergedMap.values.toList();
  }

  double _sumLotesDoItem(PreVenda2Model item) {
    final lotes = _mergedLotesDoItem(item);
    return lotes.fold(0.0, (sum, l) => sum + l.qtde);
  }

  Future<void> _destacarItem(int index) async {
    setState(() => _highlightedIndex = index);
    final ctx = _cardKeys[index].currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 250),
        alignment: 0.1,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final itens = widget.prevenda.itens;
    _qtdeControllers = List.generate(
      itens.length,
      (_) => TextEditingController(),
    );
    _qtdeFocusNodes = List.generate(itens.length, (_) => FocusNode());
    _cardKeys = List.generate(itens.length, (_) => GlobalKey());
    _sortedIndices = List.generate(itens.length, (i) => i)
      ..sort((a, b) {
        final pa = itens[a].produto;
        final pb = itens[b].produto;
        int cmp;
        cmp = pa.wmsrua.compareTo(pb.wmsrua);
        if (cmp != 0) return cmp;
        cmp = pa.wmsmod.compareTo(pb.wmsmod);
        if (cmp != 0) return cmp;
        cmp = pa.wmsniv.compareTo(pb.wmsniv);
        if (cmp != 0) return cmp;
        cmp = pa.wmsapt.compareTo(pb.wmsapt);
        if (cmp != 0) return cmp;
        cmp = pa.wmsgvt.compareTo(pb.wmsgvt);
        if (cmp != 0) return cmp;
        return pa.nome.compareTo(pb.nome);
      });
    Future.microtask(_carregarQtdeGravada);
  }

  @override
  void dispose() {
    for (final c in _qtdeControllers) {
      c.dispose();
    }
    for (final f in _qtdeFocusNodes) {
      f.dispose();
    }
    _scrollController.dispose();
    _barcodeController.dispose();
    _barcodeFocus.dispose();
    super.dispose();
  }

  Future<void> _carregarQtdeGravada() async {
    await widget.pvseparacaoController.listar(
      widget.prevenda.idFilial,
      numero: widget.prevenda.idPrevenda,
    );
    await widget.pvseparacaoController.listarLotes(
      widget.prevenda.idFilial,
      widget.prevenda.idPrevenda,
    );
    if (!mounted) return;
    final registros = widget.pvseparacaoController.itens;
    final mapa = <String, double>{
      for (final r in registros) '${r.ordem}_${r.idproduto}': r.qtde,
    };
    for (var i = 0; i < widget.prevenda.itens.length; i++) {
      final item = widget.prevenda.itens[i];
      // Se a API já retornou qtdesep > 0, usa esse valor (já separado anteriormente)
      if (item.qtdesep > 0) {
        _qtdeControllers[i].text = _formatQtde(item.qtdesep);
        continue;
      }
      // Caso contrário, usa o valor do banco local
      final key = '${item.ordem}_${item.idproduto}';
      final qtde = mapa[key];
      if (qtde != null) {
        _qtdeControllers[i].text = _formatQtde(qtde);
      }
    }
    setState(() {});
  }

  Future<void> _salvarQtde(int index, bool digitado) async {
    final controller = _qtdeControllers[index];
    final texto = controller.text.trim();
    if (texto.isEmpty) {
      AppSnackBar.erro(context, 'Informe a quantidade para salvar.');
      return;
    }
    final qtde = double.tryParse(texto.replaceAll(',', '.'));
    if (qtde == null) {
      AppSnackBar.erro(context, 'Quantidade inválida.');
      return;
    }
    if (qtde < 0) {
      AppSnackBar.erro(context, 'Quantidade não pode ser negativa.');
      return;
    }
    final item = widget.prevenda.itens[index];
    if (qtde > item.qtde) {
      _mostrarAlertaQtdeExcedida(item.produto.nome, item.qtde);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _salvandoIndex = index);
    final separacao = SeparacaoModel(
      loja: widget.prevenda.idFilial,
      numero: widget.prevenda.idPrevenda,
      ordem: item.ordem,
      idproduto: item.idproduto,
      qtde: qtde,
    );
    await widget.pvseparacaoController.gravar(separacao);
    if (!mounted) return;
    if (widget.pvseparacaoController.error != null) {
      AppSnackBar.erro(
        context,
        widget.pvseparacaoController.error ??
            'Não foi possível salvar a quantidade.',
      );
    } else {
      final textoFormatado = _formatQtde(qtde);
      _qtdeControllers[index].text = textoFormatado;
      if (digitado) {
        AppSnackBar.sucesso(context, 'Quantidade salva com sucesso.');
      }
    }
    if (mounted) {
      setState(() => _salvandoIndex = null);
    }
  }

  void _mostrarAlertaQtdeExcedida(String nomeProduto, double qtdePedida) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quantidade Excedida'),
        content: Text(
          'A quantidade separada do produto "$nomeProduto" '
          'já atingiu o limite do pedido (${qtdePedida.toStringAsFixed(qtdePedida.truncateToDouble() == qtdePedida ? 0 : 2)}).',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatQtde(double value) {
    final hasDecimals = value.truncateToDouble() != value;
    final formatted = value.toStringAsFixed(
      hasDecimals ? AppScope.of(context).parametroController.parametro.decQtde : 0,
    );
    return formatted.replaceAll('.', ',');
  }

  void _abrirScanner() {
    bool scanned = false;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Stack(
          children: [
            MobileScanner(
              onDetect: (capture) {
                if (scanned) return;
                final rawValue = capture.barcodes.firstOrNull?.rawValue;
                if (rawValue == null || rawValue.isEmpty) return;
                scanned = true;
                Navigator.of(context).pop();
                _processarBarcode(rawValue, incrementar: true);
              },
            ),
            Center(
              child: Container(
                width: 240,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Align(
              alignment: Alignment(0, 0.85),
              child: Text(
                'Aponte para o código de barra',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLeitor() {
    setState(() {
      _mostrandoLeitor = !_mostrandoLeitor;
      if (_mostrandoLeitor) {
        _barcodeController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _barcodeFocus.requestFocus();
        });
      } else {
        _barcodeFocus.unfocus();
      }
    });
  }

  void _onBarcodeSubmitted(String barcode) {
    final codigo = barcode.trim();
    if (codigo.isEmpty) return;
    _processarBarcode(codigo, incrementar: true, manterFocoBarcode: true);
    _barcodeController.clear();
  }

  void _onBarcodeChanged(String value) {
    final codigo = value.trim();
    if (codigo.length == 13 && RegExp(r'^\d{13}$').hasMatch(codigo)) {
      _onBarcodeSubmitted(codigo);
    }
  }

  void _processarBarcode(
    String barcode, {
    bool incrementar = false,
    bool manterFocoBarcode = false,
  }) {
    final itens = widget.prevenda.itens;
    final int index;
    if (barcode.length < 8) {
      final codigo = int.tryParse(barcode);
      index = codigo == null
          ? -1
          : itens.indexWhere((item) => item.idproduto == codigo);
    } else {
      index = itens.indexWhere(
        (item) =>
            item.produto.codigoalfa == barcode || item.produto.dun14 == barcode,
      );
    }
    if (index == -1) {
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Produto não encontrado'),
          content: Text(
            'O produto com código "$barcode" não consta nesta pré-venda.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (incrementar) {
      final current =
          double.tryParse(_qtdeControllers[index].text.replaceAll(',', '.')) ??
          0;
      final nova = current + 1;
      if (nova > itens[index].qtde) {
        _mostrarAlertaQtdeExcedida(
          itens[index].produto.nome,
          itens[index].qtde,
        );
      } else {
        _qtdeControllers[index].text = _formatQtde(nova);
        _salvarQtde(index, false);
      }
    }

    setState(() => _highlightedIndex = index);

    final sortedPos = _sortedIndices.indexOf(index);
    // Estima a posição de scroll (altura média do card + separador)
    const estimatedCardHeight = 260.0;
    final targetOffset = (sortedPos * estimatedCardHeight).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController
        .animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
        .then((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final ctx = _cardKeys[index].currentContext;
            if (ctx != null) {
              Scrollable.ensureVisible(
                ctx,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: 0.1,
              ).then((_) {
                if (manterFocoBarcode) {
                  _barcodeFocus.requestFocus();
                } else {
                  _qtdeFocusNodes[index].requestFocus();
                }
              });
            }
          });
        });

    //    AppSnackBar.sucesso(
    //      context,
    //      'Produto encontrado: ${itens[index].produto.nome}',
    //    );
  }

  void _confirmarFinalizarSeparacao() {
    // Monta os itens conferidos (apenas os que possuem quantidade informada)
    final deps = AppScope.of(context);
    final idSeparador = deps.parametroController.parametro.idPda > 0
        ? deps.parametroController.parametro.idPda
        : widget.prevenda.separador > 0
        ? widget.prevenda.separador
        : deps.usuarioController.usuario.idfuncionario > 0
        ? deps.usuarioController.usuario.idfuncionario
        : 0;

    if (idSeparador == 0) {
      AppSnackBar.erro(
        context,
        'Separador não identificado. Não é possível finalizar a separação.',
      );
      return;
    }

    final itensConferidos = <RequestSeparacaoItem>[];
    final decQtde = deps.parametroController.parametro.decQtde;
    for (var i = 0; i < widget.prevenda.itens.length; i++) {
      final texto = _qtdeControllers[i].text.trim();
      if (texto.isEmpty) continue;
      final qtde = double.tryParse(texto.replaceAll(',', '.'));
      if (qtde == null || qtde <= 0) continue;
      final item = widget.prevenda.itens[i];

      if (item.produto.controlelote == 1) {
        final somaLotes = _sumLotesDoItem(item);
        if (_scaleQtde(somaLotes, decQtde) != _scaleQtde(qtde, decQtde)) {
          _destacarItem(i);
          AppSnackBar.erro(
            context,
            'Produto "${item.produto.nome}": soma dos lotes (${_formatQtde(somaLotes)}) deve ser igual ao separado (${_formatQtde(qtde)}).',
          );
          return;
        }
      }

      itensConferidos.add(
        RequestSeparacaoItem(
          ordem: item.ordem,
          idproduto: item.idproduto,
          qtdesep: qtde,
        ),
      );
    }

    if (itensConferidos.isEmpty) {
      AppSnackBar.erro(context, 'Nenhum item foi separado.');
      return;
    }

    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Finalizar Separação'),
        content: Text(
          'Deseja finalizar a separação da PV Nº ${widget.prevenda.idPrevenda}?\n\n'
          '${itensConferidos.length} de ${widget.prevenda.itens.length} itens separados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    ).then((confirmado) async {
      if (confirmado != true || !mounted) return;
      setState(() => _finalizando = true);

      final request = RequestSeparacao(
        idFilial: widget.prevenda.idFilial,
        idPrevenda: widget.prevenda.idPrevenda,
        idSeparador: idSeparador,
        romaneio: 2,
        itens: itensConferidos,
      );

      await widget.pvseparacaoController.finalizarSeparacao(
        baseUrl: AppScope.of(context).parametroController.parametro.url,
        request: request,
      );

      if (!mounted) return;
      if (widget.pvseparacaoController.error != null) {
        AppSnackBar.erro(
          context,
          widget.pvseparacaoController.error ??
              'Não foi possível finalizar a separação.',
        );
        setState(() => _finalizando = false);
      } else {
        // Limpa dados locais após envio bem-sucedido
        await widget.pvseparacaoController.limpar(
          widget.prevenda.idFilial,
          numero: widget.prevenda.idPrevenda,
        );
        if (!mounted) return;
        AppSnackBar.sucesso(context, 'Separação finalizada com sucesso.');
        setState(() {
          _finalizando = false;
          _finalizado = true;
        });
      }
    });
  }

  void _confirmarApagarSeparacao() {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Apagar Separação'),
        content: Text(
          'Deseja apagar toda a separação da PV Nº ${widget.prevenda.idPrevenda}? '
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    ).then((confirmado) async {
      if (confirmado != true || !mounted) return;
      setState(() => _apagando = true);
      await widget.pvseparacaoController.limpar(
        widget.prevenda.idFilial,
        numero: widget.prevenda.idPrevenda,
      );
      if (!mounted) return;
      if (widget.pvseparacaoController.error != null) {
        AppSnackBar.erro(
          context,
          widget.pvseparacaoController.error ??
              'Não foi possível apagar a separação.',
        );
      } else {
        for (final c in _qtdeControllers) {
          c.clear();
        }
        AppSnackBar.sucesso(
          context,
          'Quantidade separada apagada com sucesso.',
        );
      }
      if (mounted) setState(() => _apagando = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final itens = widget.prevenda.itens;

    return Scaffold(
      appBar: AppBar(
        title: _mostrandoLeitor
            ? _buildCampoBarcodeInline()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PV Nº ${widget.prevenda.idPrevenda}'),
                  Text(
                    widget.prevenda.cliente.nome.isNotEmpty
                        ? widget.prevenda.cliente.nome
                        : 'Cliente ${widget.prevenda.idCliente}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_mostrandoLeitor ? Icons.close : Icons.keyboard),
            tooltip: _mostrandoLeitor
                ? 'Fechar campo'
                : 'Digitar código de barra',
            onPressed: _toggleLeitor,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirScanner,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _finalizando ||
                            _finalizado ||
                            widget.prevenda.romaneio == 2
                        ? null
                        : _confirmarFinalizarSeparacao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: _finalizando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_circle_outline, size: 20),
                    label: const Text(
                      'Finalizar Separação',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed:
                      _apagando || _finalizado || widget.prevenda.romaneio == 2
                      ? null
                      : _confirmarApagarSeparacao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: _apagando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.delete_outline, size: 20),
                  label: const Text(
                    'Apagar Qtde',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: itens.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum item encontrado.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 60),
                    itemCount: itens.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final idx = _sortedIndices[i];
                      final item = itens[idx];
                      final idFilial = widget.prevenda.idFilial;
                      final idPrevenda = widget.prevenda.idPrevenda;
                      final apiLotes = item.lotesaida.isNotEmpty
                          ? item.lotesaida
                              .map(
                                (e) => e.copyWith(
                                  idFilial: idFilial,
                                  idPrevenda: idPrevenda,
                                  idProduto: item.idproduto,
                                ),
                              )
                              .toList()
                          : (item.lote.trim().isNotEmpty ||
                                  item.validade.trim().isNotEmpty)
                              ? [
                                  LoteSaidaModel(
                                    idFilial: idFilial,
                                    idPrevenda: idPrevenda,
                                    idProduto: item.idproduto,
                                    lote: item.lote,
                                    validade: item.validade,
                                    qtde: item.qtdesep > 0 ? item.qtdesep : 0.0,
                                  ),
                                ]
                              : const <LoteSaidaModel>[];
                      final localLotes = widget.pvseparacaoController
                          .lotesDoProduto(item.idproduto);
                      final mergedMap = <String, LoteSaidaModel>{
                        for (final l in apiLotes) '${l.lote}__${l.validade}': l,
                        for (final l in localLotes)
                          '${l.lote}__${l.validade}': l,
                      };
                      return PvSeparacaoItemCard(
                        key: _cardKeys[idx],
                        idFilial: idFilial,
                        idPrevenda: idPrevenda,
                        item: item,
                        pvSeparacaoController: widget.pvseparacaoController,
                        lotes: mergedMap.values.toList(),
                        qtdeController: _qtdeControllers[idx],
                        qtdeFocusNode: _qtdeFocusNodes[idx],
                        highlighted: _highlightedIndex == idx,
                        onSalvar: () => _salvarQtde(idx, true),
                        onQtdeExcedida: () => _mostrarAlertaQtdeExcedida(
                          itens[idx].produto.nome,
                          itens[idx].qtde,
                        ),
                        isSalvando: _salvandoIndex == idx,
                        romaneio: widget.prevenda.romaneio,
                        decQtde:
                            AppScope.of(context).parametroController.parametro.decQtde,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampoBarcodeInline() {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _barcodeController,
          focusNode: _barcodeFocus,
          autofocus: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onChanged: _onBarcodeChanged,
          onSubmitted: _onBarcodeSubmitted,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Código de barras...',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Colors.white70),
              onPressed: () => _onBarcodeSubmitted(_barcodeController.text),
            ),
          ),
        ),
      ),
    );
  }
}
