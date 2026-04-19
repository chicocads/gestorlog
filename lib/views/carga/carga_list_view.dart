import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../controllers/carga/carga_controller.dart';
import '../../controllers/hsaida/hsaida_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/functions/geolocalizacao.dart';
import '../../core/utils/data_formatar.dart';
import '../../core/widgets/list_state_builder.dart';
import '../../services/carga/request_carga.dart';
import '../../services/hsaida/request_hsaida.dart';
import '../entrega/hsaida/hsentrega_list_view.dart';
import 'widgets/carga_card.dart';
import 'widgets/carga_filtro.dart';

class CargaListView extends StatefulWidget {
  const CargaListView({
    super.key,
    required this.controller,
    required this.hsaidaController,
  });

  final CarregamentoController controller;
  final HSaidaController hsaidaController;

  @override
  State<CargaListView> createState() => _CargaListViewState();
}

class _CargaListViewState extends State<CargaListView> {
  DateTime? _data1;
  DateTime? _data2;
  final _scrollController = ScrollController();
  final _numeroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _data1 = DateTime.now().subtract(const Duration(days: 90));
    _data2 = DateTime.now();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _validarGpsEBuscar());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.controller.buscarMais();
    }
  }

  Future<void> _validarGpsEBuscar() async {
    final podeEntrar = await validarGpsAtivoParaEntrega(context);
    if (!mounted) return;
    if (!podeEntrar) {
      Navigator.of(context).pop();
      return;
    }
    await _buscar();
  }

  Future<void> _buscar() async {
    final hoje = DateTime.now();
    final d1 = _data1 ?? DateTime(2020);
    final d2 = _data2 ?? hoje;
    final deps = AppScope.of(context);
    await widget.controller.buscar(
      RequestCarregamento.empty().copyWith(
        data1: DataFormatar.toYmd(d1),
        data2: DataFormatar.toYmd(d2),
        idFilial: deps.filialController.selecionado.codigo != 0
            ? deps.filialController.selecionado.codigo
            : deps.parametroController.parametro.idFilial,
        idCarga: int.tryParse(_numeroController.text) ?? 0,
        frota: deps.parametroController.parametro.idFrota,
        status: 1,
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
                const Text('Cargas'),
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
          CarregamentoFiltroBarra(
            data1: _data1,
            data2: _data2,
            onTap: _selecionarPeriodo,
            numeroController: _numeroController,
            onBuscar: _buscar,
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
                      'Nenhum carregamento encontrado\npara o período selecionado.',
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
                      final carga = ctrl.itens[index];
                      return CargaCard(
                        carregamento: carga,
                        onTap: () {
                          widget.hsaidaController.buscar(
                            RequestHSaida.empty().copyWith(
                              idFilial: carga.idFilial,
                              carregamento: carga.idCarga,
                              status: 2,
                              romaneio: 9,
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HsEntregaListView(
                                controller: widget.hsaidaController,
                                carregamento: carga.idCarga,
                              ),
                            ),
                          );
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
