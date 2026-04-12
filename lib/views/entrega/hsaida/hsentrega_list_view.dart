import 'package:flutter/material.dart';
import '../../../app/routes.dart';
import '../../../controllers/hsaida/hsaida_controller.dart';
import '../../../core/functions/geolocalizacao.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/widgets/list_state_builder.dart';
import '../../../models/hsaida/hsaida_model.dart';
import '../../../services/carga/request_pv_carga.dart';
import '../../../services/hsaida/request_hsaida.dart';
import 'hsentrega_itens_view.dart';
import 'widgets/hsentrega_card.dart';
import 'widgets/hsentrega_filtro.dart';

class HsEntregaListView extends StatefulWidget {
  const HsEntregaListView({
    super.key,
    required this.controller,
    this.carregamento = 0,
  });

  final HSaidaController controller;
  final int carregamento;

  @override
  State<HsEntregaListView> createState() => _HsEntregaListViewState();
}

class _HsEntregaListViewState extends State<HsEntregaListView> {
  int _entregue = 0;
  final Set<String> _confirmandoEntrega = {};
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
      RequestHSaida.empty().copyWith(
        idFilial: deps.filialController.selecionado.codigo != 0
            ? deps.filialController.selecionado.codigo
            : deps.parametroController.parametro.idFilial,
        numero: int.tryParse(_prevendaController.text) ?? 0,
        carregamento: widget.carregamento,
        entregue: _entregue,
        romaneio: 9,
        status: 1,
        tabAux: 1,
      ),
    );
  }

  String _keyEntrega(HSaidaModel hs) => '${hs.idFilial}__${hs.idPrevenda}';

  Future<void> _confirmarEntrega(HSaidaModel hs) async {
    final key = _keyEntrega(hs);
    if (_confirmandoEntrega.contains(key)) return;
    setState(() => _confirmandoEntrega.add(key));
    try {
      final coord = await obterCoordenadaGeograficaAtual();
      final request = PvCargaRequest(
        idfilial: hs.idFilial,
        idprevenda: hs.idPrevenda,
        situacao: 1,
        latitude: coord.latitude.toString(),
        longitude: coord.longitude.toString(),
        obs: 'Entrega confirmada via app',
        assintura: '',
      );

      await widget.controller.confirmarEntrega(request);

      if (!mounted) return;
      if (widget.controller.error != null) {
        AppSnackBar.erro(
          context,
          widget.controller.error ?? 'Não foi possível confirmar a entrega.',
        );
      } else {
        AppSnackBar.sucesso(context, 'Entrega confirmada com sucesso.');
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, e.toString());
    } finally {
      if (mounted) setState(() => _confirmandoEntrega.remove(key));
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
          HsEntregaFiltroBarra(
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
                      final hs = ctrl.itens[index];
                      return HsEntregaCard(
                        hsaida: hs,
                        onConfirmarEntrega: hs.entregue == 1
                            ? null
                            : () => _confirmarEntrega(hs),
                        confirmandoEntrega: _confirmandoEntrega.contains(
                          _keyEntrega(hs),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HsEntregaItensView(hsaida: hs),
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
