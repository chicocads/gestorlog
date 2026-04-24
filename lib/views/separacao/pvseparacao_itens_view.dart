import 'package:flutter/material.dart';
import '../../controllers/separacao/pvseparacao_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_snack_bar.dart';
import '../../core/utils/numero_formatar.dart';
import '../../core/functions/separacao_lotes_utils.dart';
import '../../models/Separacao/separacao_model.dart';
import '../../models/diversos/lote_saida_model.dart';
import '../../models/prevenda/prevenda_model.dart';
import '../../app/routes.dart';
import '../../services/separacao/request_separacao.dart';
import '../widget/scanner_view.dart';
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

  bool get _bloqueado =>
      widget.prevenda.romaneio == 2 || widget.prevenda.status == StatusPV.fechado;

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

    for (final item in widget.prevenda.itens) {
      if (item.produto.controlelote != 1) continue;
      if (item.lotesaida.isNotEmpty) continue;
      if (item.lote.trim().isEmpty && item.validade.trim().isEmpty) continue;
      item.lotesaida.add(
        LoteSaidaModel(
          idFilial: widget.prevenda.idFilial,
          idPrevenda: widget.prevenda.idPrevenda,
          idProduto: item.idproduto,
          lote: item.lote,
          validade: item.validade,
          fabricacao: DateTime.now()
              .subtract(const Duration(days: 365))
              .toIso8601String()
              .substring(0, 10),
          qtde: item.qtde,
        ),
      );
    }

    final decQtde = AppScope.of(context).parametroController.parametro.decQtde;
    final registros = widget.pvseparacaoController.itens;
    final mapa = <String, double>{
      for (final r in registros) '${r.ordem}_${r.idproduto}': r.qtde,
    };
    for (var i = 0; i < widget.prevenda.itens.length; i++) {
      final item = widget.prevenda.itens[i];
      final key = '${item.ordem}_${item.idproduto}';
      final qtdeLocal = mapa[key];

      // Prioriza o valor salvo localmente para refletir a última edição do usuário.
      if (qtdeLocal != null) {
        _qtdeControllers[i].text = NumeroFormatar.qtde(
          qtdeLocal,
          decQtde: decQtde,
        );
        continue;
      }

      // Se não houver valor local, usa o valor vindo da API.
      if (item.qtdesep > 0) {
        _qtdeControllers[i].text = NumeroFormatar.qtde(
          item.qtdesep,
          decQtde: decQtde,
        );
        continue;
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
      pecas: item.pecas,
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
      final salvo = await widget.pvseparacaoController.buscar(
        loja: widget.prevenda.idFilial,
        numero: widget.prevenda.idPrevenda,
        ordem: item.ordem,
        idproduto: item.idproduto,
      );
      if (!mounted) return;
      final decQtde = AppScope.of(
        context,
      ).parametroController.parametro.decQtde;
      final textoFormatado = NumeroFormatar.qtde(
        salvo?.qtde ?? qtde,
        decQtde: decQtde,
      );
      _qtdeControllers[index].text = textoFormatado;
      if (digitado) {
        AppSnackBar.sucesso(context, 'Quantidade salva com sucesso.');
      }
    }
    if (item.produto.controlelote == 1) {
      await widget.pvseparacaoController.listarLotes(
        widget.prevenda.idFilial,
        widget.prevenda.idPrevenda,
      );
      if (!mounted) return;
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

  void _abrirScanner() {
    showBarcodeScannerBottomSheet(context).then((rawValue) {
      if (!mounted) return;
      if (rawValue == null || rawValue.isEmpty) return;
      _processarBarcode(rawValue, incrementar: true);
    });
  }

  void _toggleLeitor() {
    if (_bloqueado) return;
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
    if (_bloqueado) {
      AppSnackBar.erro(
        context,
        'Pedido finalizado. Não é possível alterar quantidades.',
      );
      return;
    }
    final codigo = barcode.trim();
    if (codigo.isEmpty) return;
    _processarBarcode(codigo, incrementar: true, manterFocoBarcode: true);
    _barcodeController.clear();
  }

  void _onBarcodeChanged(String value) {
    final codigo = value.trim();
    final somenteDigitos =
        codigo.isNotEmpty && codigo.codeUnits.every((c) => c >= 48 && c <= 57);
    if (codigo.length == 13 && somenteDigitos) {
      _onBarcodeSubmitted(codigo);
    }
  }

  void _processarBarcode(
    String barcode, {
    bool incrementar = false,
    bool manterFocoBarcode = false,
  }) {
    if (_bloqueado) {
      AppSnackBar.erro(
        context,
        'Pedido finalizado. Não é possível alterar quantidades.',
      );
      return;
    }
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
      final decQtde = AppScope.of(
        context,
      ).parametroController.parametro.decQtde;
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
        _qtdeControllers[index].text = NumeroFormatar.qtde(
          nova,
          decQtde: decQtde,
        );
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
        final localLotes = widget.pvseparacaoController.lotesDoProduto(
          item.idproduto,
        );
        final lotes = mergeLotesForItem(
          item: item,
          idFilial: widget.prevenda.idFilial,
          idPrevenda: widget.prevenda.idPrevenda,
          localLotes: localLotes,
        );
        final somaLotes = sumQtdeLotes(lotes);
        if (scaleByDecimals(somaLotes, decQtde) !=
            scaleByDecimals(qtde, decQtde)) {
          _destacarItem(i);
          AppSnackBar.erro(
            context,
            'Produto "${item.produto.nome}": soma dos lotes (${NumeroFormatar.qtde(somaLotes, decQtde: decQtde)}) deve ser igual ao separado (${NumeroFormatar.qtde(qtde, decQtde: decQtde)}).',
          );
          return;
        }
      }

      final localLotes = widget.pvseparacaoController.lotesDoProduto(
        item.idproduto,
      );
      final lotes = mergeLotesForItem(
        item: item,
        idFilial: widget.prevenda.idFilial,
        idPrevenda: widget.prevenda.idPrevenda,
        localLotes: localLotes,
      );
      itensConferidos.add(
        RequestSeparacaoItem(
          ordem: item.ordem,
          idproduto: item.idproduto,
          qtdesep: qtde,
          lotesaida: lotes,
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
        Navigator.of(context).pop(true);
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('PV Nº ${widget.prevenda.idPrevenda}'),
                      const SizedBox(width: 8),
                      Text(
                        '# ${itens.length}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
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
            onPressed: _bloqueado ? null : _toggleLeitor,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bloqueado ? null : _abrirScanner,
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
                        _finalizando || _bloqueado
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
                      _apagando || _bloqueado
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
                    separatorBuilder: (_, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final idx = _sortedIndices[i];
                      final item = itens[idx];
                      final idFilial = widget.prevenda.idFilial;
                      final idPrevenda = widget.prevenda.idPrevenda;
                      final localLotes = widget.pvseparacaoController
                          .lotesDoProduto(item.idproduto);
                      final lotes = mergeLotesForItem(
                        item: item,
                        idFilial: idFilial,
                        idPrevenda: idPrevenda,
                        localLotes: localLotes,
                      );
                      return PvSeparacaoItemCard(
                        key: _cardKeys[idx],
                        idFilial: idFilial,
                        idPrevenda: idPrevenda,
                        item: item,
                        pvSeparacaoController: widget.pvseparacaoController,
                        lotes: lotes,
                        qtdeController: _qtdeControllers[idx],
                        qtdeFocusNode: _qtdeFocusNodes[idx],
                        highlighted: _highlightedIndex == idx,
                        onSalvar: () => _salvarQtde(idx, true),
                        onQtdeExcedida: () => _mostrarAlertaQtdeExcedida(
                          itens[idx].produto.nome,
                          itens[idx].qtde,
                        ),
                        isSalvando: _salvandoIndex == idx,
                        romaneio: _bloqueado ? 2 : widget.prevenda.romaneio,
                        decQtde: AppScope.of(
                          context,
                        ).parametroController.parametro.decQtde,
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
          enabled: !_bloqueado,
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
