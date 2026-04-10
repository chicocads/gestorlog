import 'package:flutter/material.dart';
import '../../../app/routes.dart';
import '../../../controllers/prevenda/prevenda_controller.dart';
import '../../../core/widgets/list_state_builder.dart';
import '../../../services/prevenda/request_prevenda.dart';
import 'pventrega_itens_view.dart';
import 'widgets/pventrega_card.dart';
import 'widgets/pventrega_filtro.dart';

class PvEntregaListView extends StatefulWidget {
  const PvEntregaListView({
    super.key,
    required this.controller,
    this.carregamento = 0,
  });

  final PreVendaController controller;
  final int carregamento;

  @override
  State<PvEntregaListView> createState() => _PvEntregaListViewState();
}

class _PvEntregaListViewState extends State<PvEntregaListView> {
  int _entregue = 0;
  final _scrollController = ScrollController();
  final _prevendaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _buscar());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _prevendaController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.controller.buscarMais();
    }
  }

  Future<void> _buscar() async {
    final deps = AppScope.of(context);
    await widget.controller.buscar(
      RequestPreVenda.empty().copyWith(
        idFilial: deps.filialController.selecionado.codigo != 0
            ? deps.filialController.selecionado.codigo
            : deps.parametroController.parametro.idFilial,
        numero: int.tryParse(_prevendaController.text) ?? 0,
        carregamento: widget.carregamento,
        entregue: _entregue,
        romaneio: 9,
        status: 2,
      ),
    );
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
                const Text('Entrega de Carga'),
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
          PvEntregaFiltroBarra(
            carregamento: widget.carregamento,
            prevendaController: _prevendaController,
            onBuscar: _buscar,
            entregueSelecionado: _entregue,
            onEntregueChanged: (e) => setState(() => _entregue = e),
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
                      'Nenhuma entrega encontrada\npara o periodo selecionado.',
                  emptyIcon: Icons.local_shipping_outlined,
                  builder: () => ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 60),
                    itemCount:
                        ctrl.itens.length + (ctrl.temMaisPaginas ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == ctrl.itens.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final pv = ctrl.itens[index];
                      return PvEntregaCard(
                        prevenda: pv,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PvEntregaItensView(prevenda: pv),
                          ),
                        ),
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
