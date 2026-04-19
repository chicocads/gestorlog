import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../controllers/cadastro/produto_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/string_sanitizer.dart';
import '../../../core/widgets/list_state_builder.dart';
import '../../../services/cadastro/produto/request_produto.dart';
import 'widgets/produto_card.dart';

class ProdutoView extends StatefulWidget {
  const ProdutoView({super.key, required this.controller});

  final ProdutoController controller;

  @override
  State<ProdutoView> createState() => _ProdutoViewState();
}

class _ProdutoViewState extends State<ProdutoView> {
  final _scrollController = ScrollController();
  final _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _buscar());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _buscaController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.controller.consultarMais();
    }
  }

  Future<void> _buscar() async {
    final termo = _buscaController.text.trim();
    final somenteDigitos = StringSanitizer.isDigits(termo);
    final codigo = somenteDigitos && termo.length <= 10 ? int.tryParse(termo) ?? 0 : 0;
    final termoBarra = somenteDigitos && termo.length > 10 ? termo : '';
    final termoNome = !somenteDigitos ? termo : '';

    final deps = AppScope.of(context);
    final idFilial = deps.filialController.selecionado.codigo != 0
        ? deps.filialController.selecionado.codigo
        : deps.parametroController.parametro.idFilial;

    await widget.controller.consultar(
      RequestProduto.empty().copyWith(
        paginaAtual: '1',
        qtdTotal: '50',
        idFilial: idFilial,
        codigo: codigo,
        codigoalfa: termoBarra,
        dun14: termoBarra,
        nome: termoNome,
        situacao: 1,
        saldo: 2, 
      ),
    );

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final total = widget.controller.itens.length;
            final suffix = widget.controller.temMaisPaginas ? '+' : '';
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Produtos'),
                if (total > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$total$suffix',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              border: const Border(
                bottom: BorderSide(color: AppColors.primary, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _buscaController,
                    keyboardType: TextInputType.text,
                    onSubmitted: (_) => _buscar(),
                    decoration: InputDecoration(
                      labelText: 'Código / Barra / Nome',
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                      isDense: true,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: _buscar,
                        icon: const Icon(Icons.search),
                        color: AppColors.primary,
                        tooltip: 'Buscar',
                      ),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                final ctrl = widget.controller;

                return ListStateBuilder(
                  isLoading: ctrl.isLoading && ctrl.itens.isEmpty,
                  error: ctrl.itens.isEmpty ? ctrl.error : null,
                  isEmpty: ctrl.itens.isEmpty,
                  emptyMessage:
                      'Nenhum produto encontrado\npara os filtros informados.',
                  emptyIcon: Icons.inventory_2_outlined,
                  builder: () => ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                    itemCount: ctrl.itens.length + (ctrl.temMaisPaginas ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == ctrl.itens.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final produto = ctrl.itens[index];
                      return ProdutoCard(
                        produto: produto,
                        onTap: () => ctrl.selecionar(produto),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
