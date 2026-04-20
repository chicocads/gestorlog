import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/utils/data_formatar.dart';
import '../../../core/utils/numero_formatar.dart';
import '../../../core/widgets/info_row.dart';
import '../../../core/widgets/list_state_builder.dart';
import '../../../services/inventario/inventario_local_service.dart';

class InventarioColetadosTab extends StatefulWidget {
  const InventarioColetadosTab({super.key});

  @override
  State<InventarioColetadosTab> createState() => _InventarioColetadosTabState();
}

class _InventarioColetadosTabState extends State<InventarioColetadosTab> {
  static const _pageSize = 50;

  final _service = InventarioLocalService();
  final _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _temMais = true;
  String? _error;
  List<InventarioColetadoItem> _itens = const [];
  int _offset = 0;

  int get _decQtde =>
      AppScope.of(context).parametroController.parametro.decQtde;

  String _formatValidade(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '';
    if (v.contains('/')) return v;
    final dt = DateTime.tryParse(v);
    if (dt == null) return raw;
    return DataFormatar.formatDate(dt);
  }

  @override
  void initState() {
    super.initState();
    _carregar();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_temMais || _isLoading || _isLoadingMore) return;
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      _carregarMais();
    }
  }

  Future<void> _carregar() async {
    setState(() {
      _isLoading = true;
      _isLoadingMore = false;
      _temMais = true;
      _error = null;
      _itens = const [];
      _offset = 0;
    });

    try {
      final itens = await _service.listarColetadosComNome(
        limit: _pageSize,
        offset: 0,
      );
      if (!mounted) return;
      setState(() {
        _itens = itens;
        _offset = itens.length;
        _temMais = itens.length == _pageSize;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Erro ao carregar coletados: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _carregarMais() async {
    if (_isLoading || _isLoadingMore || !_temMais) return;
    setState(() => _isLoadingMore = true);

    try {
      final novos = await _service.listarColetadosComNome(
        limit: _pageSize,
        offset: _offset,
      );
      if (!mounted) return;
      setState(() {
        _itens = [..._itens, ...novos];
        _offset = _itens.length;
        _temMais = novos.length == _pageSize;
      });
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao carregar mais itens: $e');
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _excluirItem(InventarioColetadoItem item) async {
    final id = item.inventario.id;
    if (id <= 0) return;
    await _service.excluirPorId(id);
    if (!mounted) return;
    setState(() {
      _itens = _itens.where((e) => e.inventario.id != id).toList();
      _offset = _itens.length;
    });
    AppSnackBar.sucesso(context, 'Item excluído.');
  }

  Future<void> _confirmarExcluir(InventarioColetadoItem item) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir item?'),
        content: Text(
          '${item.nomeProduto}\nCódigo: ${item.inventario.produto}\nLote: ${item.inventario.lote}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmado != true) return;

    try {
      await _excluirItem(item);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao excluir: $e');
    }
  }

  Widget _buildCard(InventarioColetadoItem item) {
    final inv = item.inventario;
    final labelWidth = 62.0;
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.nomeProduto.isNotEmpty ? item.nomeProduto : 'Sem nome',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _confirmarExcluir(item),
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.error,
                  tooltip: 'Excluir',
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: InfoRow(
                    label: 'Código',
                    value: inv.produto.toString(),
                    labelWidth: labelWidth,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InfoRow(
                    label: 'EAN:',
                    value: inv.codigoBarra,
                    labelWidth: labelWidth,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InfoRow(
                    label: 'Peças',
                    value: inv.pecas.toString(),
                    labelWidth: labelWidth,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InfoRow(
                    label: 'Qtde',
                    value: NumeroFormatar.qtde(inv.qtde, decQtde: _decQtde),
                    labelWidth: labelWidth,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InfoRow(
                    label: 'Lote',
                    value: inv.lote,
                    labelWidth: labelWidth,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InfoRow(
                    label: 'Validade',
                    value: _formatValidade(inv.validade),
                    labelWidth: labelWidth,
                  ),
                ),
              ],
            ),
            if (!item.produtoCadastrado)
              InfoRow(
                label: 'Nome (inv)',
                value: inv.nomePro,
                labelWidth: labelWidth,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListStateBuilder(
        isLoading: _isLoading,
        error: _error,
        isEmpty: _itens.isEmpty,
        emptyMessage: 'Nenhum item coletado no inventário.',
        emptyIcon: Icons.fact_check_outlined,
        builder: () => ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
          itemCount: _itens.length + (_isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < _itens.length) return _buildCard(_itens[index]);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
