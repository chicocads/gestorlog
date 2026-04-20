import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../controllers/inventario/inventario_produto_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/list_state_builder.dart';
import '../../../services/cadastro/produto/produto_local_service.dart';
import '../../../services/cadastro/produto/request_produto.dart';
import '../widgets/inventario_produto_card.dart';

class InventarioProdutosTab extends StatefulWidget {
  const InventarioProdutosTab({
    super.key,
    this.sincronizandoNotifier,
  });

  final ValueNotifier<bool>? sincronizandoNotifier;

  @override
  State<InventarioProdutosTab> createState() => InventarioProdutosTabState();
}

class InventarioProdutosTabState extends State<InventarioProdutosTab> {
  final _scrollController = ScrollController();
  final _buscaController = TextEditingController();
  final _localService = ProdutoLocalService();
  late final _controller = InventarioProdutoController(_localService);
  late final ValueNotifier<bool> _sincronizandoNotifier;
  late final bool _ownsSincronizandoNotifier;

  bool _sincronizando = false;
  int _produtosBaixados = 0;

  bool get sincronizando => _sincronizando;

  @override
  void initState() {
    super.initState();
    _ownsSincronizandoNotifier = widget.sincronizandoNotifier == null;
    _sincronizandoNotifier = widget.sincronizandoNotifier ?? ValueNotifier(false);
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _buscar());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _buscaController.dispose();
    _controller.dispose();
    if (_ownsSincronizandoNotifier) {
      _sincronizandoNotifier.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.consultarMais();
    }
  }

  Future<void> _buscar() async {
    await _controller.consultar(termoBusca: _buscaController.text);

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  Future<void> _baixarProdutos() async {
    if (_sincronizando) return;

    final deps = AppScope.of(context);
    final baseUrl = deps.parametroController.parametro.url.trim();
    final idFilial = deps.filialController.selecionado.codigo != 0
        ? deps.filialController.selecionado.codigo
        : deps.parametroController.parametro.idFilial;

    if (baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configure a URL da API antes de baixar.')),
      );
      return;
    }

    setState(() {
      _sincronizando = true;
      _sincronizandoNotifier.value = true;
      _produtosBaixados = 0;
    });

    try {
      var pagina = 1;
      var limpouBaseLocal = false;

      while (true) {
        final resposta = await deps.produtoService.consultar(
          baseUrl: baseUrl,
          request: RequestProduto.empty().copyWith(
            paginaAtual: pagina.toString(),
            qtdTotal: '800',
            idFilial: idFilial,
            situacao: 1,
            saldo: 2,
          ),
        );

        if (!limpouBaseLocal) {
          await _localService.limpar();
          limpouBaseLocal = true;
        }

        await _localService.gravarTodos(resposta.itens);

        if (!mounted) return;

        setState(() {
          _produtosBaixados += resposta.itens.length;
        });

        if (resposta.itens.isEmpty || resposta.paginaAtual >= resposta.qtdPaginas) {
          break;
        }

        if (resposta.proximaPagina <= resposta.paginaAtual) {
          break;
        }
        pagina = resposta.proximaPagina;
      }

      await _buscar();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Download concluído. $_produtosBaixados produtos gravados no banco local.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao baixar produtos: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _sincronizando = false;
          _sincronizandoNotifier.value = false;
        });
      }
    }
  }

  Future<void> baixarProdutos() => _baixarProdutos();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            border: const Border(
              bottom: BorderSide(color: AppColors.primary, width: 0.5),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            children: [
              Row(
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
                  const SizedBox(width: 12),
                  ListenableBuilder(
                    listenable: _controller,
                    builder: (context, _) {
                      final total = _controller.totalItens;
                      return Text(
                        'Total: $total',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              return ListStateBuilder(
                isLoading: _controller.isLoading && _controller.itens.isEmpty,
                error: _controller.itens.isEmpty ? _controller.error : null,
                isEmpty: _controller.itens.isEmpty,
                emptyMessage: 'Nenhum produto encontrado no banco local.',
                emptyIcon: Icons.inventory_2_outlined,
                builder: () => ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  itemCount:
                      _controller.itens.length +
                      (_controller.temMaisPaginas ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _controller.itens.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: _controller.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const SizedBox.shrink(),
                        ),
                      );
                    }

                    final produto = _controller.itens[index];
                    return InventarioProdutoCard(
                      produto: produto,
                      onTap: () => _controller.selecionar(produto),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
