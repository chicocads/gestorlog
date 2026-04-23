import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../controllers/prevenda/prevenda_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/data_formatar.dart';
import '../../core/widgets/list_state_builder.dart';
import '../../models/prevenda/prevenda_model.dart';
import '../../services/prevenda/request_prevenda.dart';
import 'pvseparacao_itens_view.dart';
import 'widgets/pvseparacao_card.dart';
import 'widgets/pvseparacao_filtro.dart';

class PvSeparacaoListView extends StatefulWidget {
  const PvSeparacaoListView({super.key, required this.controller});

  final PreVendaController controller;

  @override
  State<PvSeparacaoListView> createState() => _PvSeparacaoListViewState();
}

class _PvSeparacaoListViewState extends State<PvSeparacaoListView> {
  DateTime? _data1;
  DateTime? _data2;
  StatusPV _status = StatusPV.orcamento;
  final _scrollController = ScrollController();
  final _cargaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _data1 = DateTime.now().subtract(const Duration(days: 90));
    _data2 = DateTime.now();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _buscar());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cargaController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.controller.buscarMais();
    }
  }

  Future<void> _buscar() async {
    final hoje = DateTime.now();
    final d1 = _data1 ?? DateTime(1990);
    final d2 = _data2 ?? hoje;
    final deps = AppScope.of(context);
    await widget.controller.buscar(
      RequestPreVenda.empty().copyWith(
        data1: DataFormatar.startOfDayIso(d1),
        data2: DataFormatar.endOfDayIso(d2),
        idFilial: deps.filialController.selecionado.codigo != 0
            ? deps.filialController.selecionado.codigo
            : deps.parametroController.parametro.idFilial,
        carregamento: int.tryParse(_cargaController.text) ?? 0,
        status: _status.value,
        idSeparador: deps.parametroController.parametro.idPda == 0
            ? deps.usuarioController.usuario.idfuncionario
            : deps.parametroController.parametro.idPda,
        romaneio: 0,
      ),
    );
  }

  Future<void> _selecionarPeriodo() async {
    final hoje = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: _data1 ?? hoje.subtract(const Duration(days: 10)),
        end: _data2 ?? hoje,
      ),
      initialEntryMode: DatePickerEntryMode.calendar,
      locale: const Locale('pt', 'BR'),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (range == null) return;
    setState(() {
      _data1 = range.start;
      _data2 = range.end;
    });
    _buscar();
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
                const Text('Separação de Carga'),
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
          PvSeparacaoFiltroBarra(
            data1: _data1,
            data2: _data2,
            onTap: _selecionarPeriodo,
            cargaController: _cargaController,
            onBuscar: _buscar,
            statusSelecionado: _status,
            onStatusChanged: (s) => setState(() => _status = s),
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
                      'Nenhuma pré-venda encontrada\npara o período selecionado.',
                  emptyIcon: Icons.receipt_long_outlined,
                  builder: () => ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
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
                      return PvSeparacaoCard(
                        prevenda: pv,
                        onTap: () async {
                          if (pv.status == StatusPV.cancelado) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'PV cancelada. Não é possível separar itens.',
                                ),
                              ),
                            );
                            return;
                          }
                          final finalizou = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PvSeparacaoItensView(
                                prevenda: pv,
                                pvseparacaoController:
                                    AppScope.of(context).conferenciaController,
                              ),
                            ),
                          );
                          if (!context.mounted) return;
                          if (finalizou == true) {
                            widget.controller.removerDaLista(
                              loja: pv.idFilial,
                              numero: pv.idPrevenda,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Separação finalizada com sucesso.'),
                              ),
                            );
                          }
                        },
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
