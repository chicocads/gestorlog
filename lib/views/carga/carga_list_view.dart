import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../controllers/carga/carga_controller.dart';
import '../../controllers/hsaida/hsaida_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/functions/geolocalizacao.dart';
import '../../core/utils/app_snack_bar.dart';
import '../../core/utils/data_formatar.dart';
import '../../core/widgets/list_state_builder.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/carga/carga_model.dart';
import '../../services/carga/request_carga_despesa.dart';
import '../../services/carga/request_carga_consulta.dart';
import '../../services/carga/request_carga_km.dart';
import '../../services/hsaida/request_hsaida.dart';
import '../entrega/hsaida/hsentrega_list_view.dart';
import 'widgets/carga_card.dart';
import 'widgets/carga_despesa_bottom_sheets.dart';
import 'widgets/carga_filtro.dart';
import 'widgets/carga_km_bottom_sheet.dart';

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
  final Set<String> _salvandoDespesa = {};
  final Set<String> _salvandoKm = {};

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

  String _keyCarga(CargaModel carga) => '${carga.idFilial}__${carga.idCarga}';

  String _dataAtualIso() => DataFormatar.formatYYMMDD(DateTime.now());

  Future<CargaDespesaDraft?> _abrirLancamentoDespesa(CargaModel carga) async {
    return showModalBottomSheet<CargaDespesaDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => CargaDespesaBottomSheet(cargaId: carga.idCarga),
    );
  }

  Future<CargaKmDraft?> _abrirInformarKm(CargaModel carga) async {
    return showModalBottomSheet<CargaKmDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => CargaKmBottomSheet(
        cargaId: carga.idCarga,
        kmSaida: carga.kmSaida,
        kmChegada: carga.kmChegada,
      ),
    );
  }

  Future<void> _abrirConsultaDespesas(CargaModel carga) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => CargaDespesasBottomSheet(cargaId: carga.idCarga),
    );
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
      RequestCargaConsulta.empty().copyWith(
        data1: DataFormatar.formatYYMMDD(d1),
        data2: DataFormatar.formatYYMMDD(d2),
        idFilial: deps.filialController.selecionado.codigo != 0
            ? deps.filialController.selecionado.codigo
            : deps.parametroController.parametro.idFilial,
        idCarga: int.tryParse(_numeroController.text) ?? 0,
        frota: deps.parametroController.parametro.idFrota,
        status: StatusCarregamento.entregando.value,
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
      confirmText: 'Aplicar',
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
            final total = widget.controller.totalRegistros > 0
                ? widget.controller.totalRegistros
                : widget.controller.itens.length;
            final suffix =
                widget.controller.totalRegistros > 0 ||
                    !widget.controller.temMaisPaginas
                ? ''
                : '+';
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Cargas'),
                if (total > 0) ...[
                  const SizedBox(width: 8),
                  CountBadge(count: total, suffix: suffix),
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
                    itemBuilder: (itemContext, index) {
                      if (index == ctrl.itens.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final carga = ctrl.itens[index];
                      final key = _keyCarga(carga);
                      return CargaCard(
                        carregamento: carga,
                        isLancandoDespesa: _salvandoDespesa.contains(key),
                        onInformarKm: _salvandoKm.contains(key)
                            ? null
                            : () async {
                                if (_salvandoKm.contains(key)) return;
                                final draft = await _abrirInformarKm(carga);
                                if (draft == null) return;
                                if (!context.mounted) return;
                                setState(() => _salvandoKm.add(key));
                                try {
                                  final deps = AppScope.of(context);
                                  final baseUrl = deps
                                      .parametroController
                                      .parametro
                                      .url
                                      .trim();
                                  if (baseUrl.isEmpty) {
                                    if (!context.mounted) return;
                                    AppSnackBar.erro(
                                      context,
                                      'Configure a URL da API antes de salvar.',
                                    );
                                    return;
                                  }
                                  await deps.carregamentoService.salvarKm(
                                    baseUrl: baseUrl,
                                    request: CargaKmRequest(
                                      idFilial: carga.idFilial,
                                      idCarga: carga.idCarga,
                                      kmSaida: draft.kmSaida,
                                      kmChegada: draft.kmChegada,
                                    ),
                                  );
                                  widget.controller.atualizarKm(
                                    idFilial: carga.idFilial,
                                    idCarga: carga.idCarga,
                                    kmSaida: draft.kmSaida,
                                    kmChegada: draft.kmChegada,
                                  );
                                  if (!context.mounted) return;
                                  AppSnackBar.sucesso(
                                    context,
                                    'KM informado com sucesso.',
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  AppSnackBar.erro(
                                    context,
                                    'Erro ao salvar KM: $e',
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() => _salvandoKm.remove(key));
                                  }
                                }
                              },
                        onLancamentoDespesa: () async {
                          if (_salvandoDespesa.contains(key)) return;
                          setState(() => _salvandoDespesa.add(key));
                          try {
                            final draft = await _abrirLancamentoDespesa(carga);
                            if (draft == null) return;

                            if (!context.mounted) return;
                            final deps = AppScope.of(context);
                            final baseUrl = deps
                                .parametroController
                                .parametro
                                .url
                                .trim();
                            if (baseUrl.isEmpty) {
                              if (!context.mounted) return;
                              AppSnackBar.erro(
                                context,
                                'Configure a URL da API antes de salvar.',
                              );
                              return;
                            }

                            await deps.cargaDespesaService.inserir(
                              baseUrl: baseUrl,
                              request: CargaDespesaRequest(
                                id: 0,
                                idfilial: carga.idFilial,
                                idcarga: carga.idCarga,
                                data: _dataAtualIso(),
                                descricao: draft.descricao,
                                valor: draft.valor,
                              ),
                            );

                            if (!context.mounted) return;
                            AppSnackBar.sucesso(
                              context,
                              'Despesa lançada com sucesso.',
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            AppSnackBar.erro(
                              context,
                              'Erro ao salvar despesa: $e',
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _salvandoDespesa.remove(key));
                            }
                          }
                        },
                        onVerDespesas: () => _abrirConsultaDespesas(carga),
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
                            itemContext,
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
