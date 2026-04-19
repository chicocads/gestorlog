import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../controllers/inventario/inventario_produto_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/list_state_builder.dart';
import '../../../services/cadastro/produto/produto_local_service.dart';
import '../../../services/cadastro/produto/request_produto.dart';
import '../../cadastro/produto/widgets/produto_filtro.dart';
import '../widgets/inventario_produto_card.dart';

class InventarioProdutosTab extends StatefulWidget {
  const InventarioProdutosTab({super.key});

  @override
  State<InventarioProdutosTab> createState() => _InventarioProdutosTabState();
}

class _InventarioProdutosTabState extends State<InventarioProdutosTab> {
  final _scrollController = ScrollController();
  final _codigoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _localService = ProdutoLocalService();
  late final _controller = InventarioProdutoController(_localService);

  bool _sincronizando = false;
  int _produtosBaixados = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _buscar());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _codigoController.dispose();
    _nomeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.consultarMais();
    }
  }

  Future<void> _buscar() async {
    await _controller.consultar(
      termoCodigoBarra: _codigoController.text,
      termoNome: _nomeController.text,
    );

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
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              ProdutoFiltro(
                codigoController: _codigoController,
                nomeController: _nomeController,
                onBuscar: _buscar,
              ),
              Expanded(
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    return ListStateBuilder(
                      isLoading: _controller.isLoading && _controller.itens.isEmpty,
                      error: _controller.itens.isEmpty ? _controller.error : null,
                      isEmpty: _controller.itens.isEmpty,
                      emptyMessage:
                          'Nenhum produto encontrado no banco local.',
                      emptyIcon: Icons.inventory_2_outlined,
                      builder: () => ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                        itemCount:
                            _controller.itens.length +
                            (_controller.temMaisPaginas ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _controller.itens.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
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
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: _sincronizando ? null : _baixarProdutos,
            backgroundColor: AppColors.primary,
            icon: _sincronizando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.download_outlined),
            label: Text(_sincronizando ? 'Baixando...' : 'Baixar'),
          ),
        ),
      ],
    );
  }
}
