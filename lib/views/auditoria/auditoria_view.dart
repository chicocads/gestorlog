import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_snack_bar.dart';
import '../../core/utils/data_formatar.dart';
import '../../core/utils/numero_formatar.dart';
import '../../core/utils/string_sanitizer.dart';
import '../../models/auditoria/auditoria_model.dart';
import '../../services/auditoria/request_alterar_barra_produto.dart';
import '../../services/auditoria/request_dado_fisico_produto.dart';
import '../../services/auditoria/request_endereco_produto.dart';
import '../widget/scanner_view.dart';
import 'tabs/auditoria_dado_fisico_tab.dart';
import 'tabs/auditoria_endereco_tab.dart';
import 'widgets/auditoria_codigo_row.dart';
import 'widgets/auditoria_codigos_barra_card.dart';
import 'widgets/auditoria_dado_fisico_card.dart';
import 'widgets/auditoria_endereco_card.dart';
import 'widgets/auditoria_produto_bottom_sheet.dart';
import 'tabs/auditoria_ficha_tab.dart';
import 'widgets/auditoria_produto_label.dart';
import 'widgets/auditoria_resumo_card.dart';
import 'tabs/auditoria_lotes_tab.dart';
import 'widgets/auditoria_card.dart';

class AuditoriaView extends StatefulWidget {
  const AuditoriaView({super.key});

  @override
  State<AuditoriaView> createState() => _AuditoriaViewState();
}

class _AuditoriaViewState extends State<AuditoriaView> {
  final _codigoController = TextEditingController();
  final _codigoFocus = FocusNode();
  final _eanController = TextEditingController();
  final _dun14Controller = TextEditingController();
  final _localizacaoController = TextEditingController();
  String? _ultimoCodigoScanner;

  final _apanhaRuaController = TextEditingController();
  final _apanhaBlcController = TextEditingController();
  final _apanhaModController = TextEditingController();
  final _apanhaNivController = TextEditingController();
  final _apanhaAptController = TextEditingController();

  final _pulmaoRuaController = TextEditingController();
  final _pulmaoBlcController = TextEditingController();
  final _pulmaoModController = TextEditingController();
  final _pulmaoNivController = TextEditingController();
  final _pulmaoAptController = TextEditingController();

  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();
  final _larguraController = TextEditingController();
  final _comprimentoController = TextEditingController();

  bool _buscando = false;
  bool _salvandoCodigoBarra = false;
  bool _salvandoEndereco = false;
  bool _salvandoDadoFisico = false;
  AuditoriaLogisticaModel? _auditoria;

  @override
  void initState() {
    super.initState();
    _focarCodigo();
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _codigoFocus.dispose();
    _eanController.dispose();
    _dun14Controller.dispose();
    _localizacaoController.dispose();
    _apanhaRuaController.dispose();
    _apanhaBlcController.dispose();
    _apanhaModController.dispose();
    _apanhaNivController.dispose();
    _apanhaAptController.dispose();
    _pulmaoRuaController.dispose();
    _pulmaoBlcController.dispose();
    _pulmaoModController.dispose();
    _pulmaoNivController.dispose();
    _pulmaoAptController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    _larguraController.dispose();
    _comprimentoController.dispose();
    super.dispose();
  }

  void _limparCampos() {
    _eanController.clear();
    _dun14Controller.clear();
    _localizacaoController.clear();
    _apanhaRuaController.clear();
    _apanhaBlcController.clear();
    _apanhaModController.clear();
    _apanhaNivController.clear();
    _apanhaAptController.clear();
    _pulmaoRuaController.clear();
    _pulmaoBlcController.clear();
    _pulmaoModController.clear();
    _pulmaoNivController.clear();
    _pulmaoAptController.clear();
    _pesoController.clear();
    _alturaController.clear();
    _larguraController.clear();
    _comprimentoController.clear();
  }

  void _preencherCampos(AuditoriaLogisticaModel auditoria) {
    _eanController.text = auditoria.codigoalfa.trim();
    _dun14Controller.text = auditoria.dun14.trim();
    _localizacaoController.text = auditoria.localizacao.trim();

    _apanhaRuaController.text = '${auditoria.wmsrua}';
    _apanhaBlcController.text = '${auditoria.wmsblc}';
    _apanhaModController.text = '${auditoria.wmsmod}';
    _apanhaNivController.text = '${auditoria.wmsniv}';
    _apanhaAptController.text = '${auditoria.wmsapt}';

    _pulmaoRuaController.text = '${auditoria.wmsrua2}';
    _pulmaoBlcController.text = '${auditoria.wmsblc2}';
    _pulmaoModController.text = '${auditoria.wmsmod2}';
    _pulmaoNivController.text = '${auditoria.wmsniv2}';
    _pulmaoAptController.text = '${auditoria.wmsapt2}';

    _pesoController.text = _formatDecimal(auditoria.peso);
    _alturaController.text = _formatDecimal(auditoria.altura);
    _larguraController.text = _formatDecimal(auditoria.largura);
    _comprimentoController.text = _formatDecimal(auditoria.comprimento);
  }

  void _focarCodigo({bool limpar = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (limpar) _codigoController.clear();
      _codigoFocus.requestFocus();
      _codigoController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _codigoController.text.length,
      );
    });
  }

  Future<void> _abrirPesquisaNome() async {
    final codigo = await showAuditoriaProdutoSearch(context);
    if (!mounted || codigo == null) return;
    _codigoController.text = codigo.toString();
    _buscarProduto();
  }

  void _abrirScanner() async {
    final rawValue = await showBarcodeScannerBottomSheet(context);
    if (!mounted) return;
    if (rawValue == null || rawValue.isEmpty) return;

    final codigo = StringSanitizer.digitsOnly(rawValue.trim());
    if (codigo.isEmpty) return;
    if (!_validarCodigoOuBarra(codigo)) {
      _focarCodigo(limpar: true);
      return;
    }

    final termoAtual = _codigoController.text.trim();
    final auditoriaAtual = _auditoria;
    final eanAtual = _eanController.text.trim();
    final dun14Atual = _dun14Controller.text.trim();
    if (auditoriaAtual != null &&
        termoAtual.isNotEmpty &&
        StringSanitizer.isDigits(termoAtual) &&
        termoAtual.length <= 10 &&
        StringSanitizer.isValidEan(codigo)) {
      if (codigo.length == 14 && dun14Atual.isEmpty) {
        _dun14Controller.text = codigo;
        _ultimoCodigoScanner = null;
        return;
      }
      if (eanAtual.isEmpty) {
        _eanController.text = codigo;
        _ultimoCodigoScanner = null;
        return;
      }
    }

    _ultimoCodigoScanner = codigo;
    _codigoController.text = codigo;
    _buscarProduto();
  }

  bool _validarCodigoOuBarra(String codigo) {
    final v = codigo.trim();
    if (v.isEmpty) return false;
    if (!StringSanitizer.isDigits(v)) return false;

    if (v.length <= 10) return true;

    if (v.length != 12 && v.length != 13 && v.length != 14) {
      _mostrarDialogoCodigoBarrasInvalido(
        'Código de barras deve ter 13 ou 14 dígitos.',
      );
      return false;
    }

    if (!StringSanitizer.isValidEan(v)) {
      _mostrarDialogoCodigoBarrasInvalido('Código de barras inválido.');
      return false;
    }
    return true;
  }

  void _mostrarDialogoCodigoBarrasInvalido(String mensagem) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Código de Barras Inválido'),
        content: Text(mensagem),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _buscarProduto() async {
    if (_buscando) return;

    final termo = _codigoController.text.trim();
    if (termo.isEmpty) return;

    if (!_validarCodigoOuBarra(termo)) return;

    final deps = AppScope.of(context);
    final baseUrl = deps.parametroController.parametro.url.trim();
    final idFilial = deps.filialController.selecionado.codigo != 0
        ? deps.filialController.selecionado.codigo
        : deps.parametroController.parametro.idFilial;

    if (baseUrl.isEmpty) {
      AppSnackBar.erro(context, 'Configure a URL da API antes de consultar.');
      return;
    }

    setState(() {
      _buscando = true;
      _auditoria = null;
      _limparCampos();
    });

    try {
      final auditoria = await deps.auditoriaService
          .consultarAuditoriaLogisticaPorCodigoBarras(
            baseUrl: baseUrl,
            idFilial: idFilial,
            chave: termo,
          );
      if (!mounted) return;
      setState(() {
        _auditoria = auditoria;
        _preencherCampos(auditoria);
        _autoPreencherCodigosComScanner(
          termoPesquisado: termo,
          auditoria: auditoria,
        );
      });
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao consultar auditoria: $e');
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  void _autoPreencherCodigosComScanner({
    required String termoPesquisado,
    required AuditoriaLogisticaModel auditoria,
  }) {
    final scanner = _ultimoCodigoScanner;
    if (scanner == null) return;
    if (scanner != termoPesquisado) return;

    final eanAtual = _eanController.text.trim();
    final dun14Atual = _dun14Controller.text.trim();

    if (scanner.length <= 10) {
      if (eanAtual.isEmpty) {
        _eanController.text = scanner;
      }
      _ultimoCodigoScanner = null;
      return;
    }

    final isDun14 = StringSanitizer.isValidDun14(scanner);
    if (isDun14 && eanAtual.isNotEmpty && dun14Atual.isEmpty) {
      _dun14Controller.text = scanner;
    }

    _ultimoCodigoScanner = null;
  }

  void _limparTela() {
    if (_buscando) return;
    setState(() {
      _auditoria = null;
      _codigoController.clear();
      _limparCampos();
    });
    _ultimoCodigoScanner = null;
    _focarCodigo();
  }

  Future<void> _salvarCodigosDeBarra() async {
    if (_salvandoCodigoBarra) return;

    final auditoria = _auditoria;
    if (auditoria == null) return;

    final ean = _eanController.text.trim();
    final dun14 = _dun14Controller.text.trim();

    if (ean.isNotEmpty && !StringSanitizer.isValidEan(ean)) {
      _mostrarDialogoCodigoBarrasInvalido('EAN inválido.');
      return;
    }

    if (dun14.isNotEmpty && !StringSanitizer.isValidDun14(dun14)) {
      _mostrarDialogoCodigoBarrasInvalido('DUN14 inválido.');
      return;
    }

    final deps = AppScope.of(context);
    final baseUrl = deps.parametroController.parametro.url.trim();
    if (baseUrl.isEmpty) {
      AppSnackBar.erro(context, 'Configure a URL da API antes de salvar.');
      return;
    }

    setState(() => _salvandoCodigoBarra = true);
    try {
      final ok = await deps.auditoriaService
          .alterarAuditoriaLogisticaCodigoBarraProduto(
            baseUrl: baseUrl,
            request: RequestAlterarCodigoBarraProduto(
              codigo: auditoria.codigo,
              codigoAlfa: ean,
              dun14: dun14,
            ),
          );
      if (!mounted) return;
      if (ok) {
        AppSnackBar.sucesso(context, 'Códigos de barra atualizados.');
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao salvar códigos de barra: $e');
    } finally {
      if (mounted) setState(() => _salvandoCodigoBarra = false);
    }
  }

  Future<void> _salvarEndereco() async {
    if (_salvandoEndereco) return;

    final auditoria = _auditoria;
    if (auditoria == null) return;

    final deps = AppScope.of(context);
    final baseUrl = deps.parametroController.parametro.url.trim();
    if (baseUrl.isEmpty) {
      AppSnackBar.erro(context, 'Configure a URL da API antes de salvar.');
      return;
    }

    final localizacao = _localizacaoController.text.trim();
    if (localizacao.length > 60) {
      AppSnackBar.erro(
        context,
        'Localização deve ter no máximo 60 caracteres.',
      );
      return;
    }

    int n(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;

    setState(() => _salvandoEndereco = true);
    try {
      final ok = await deps.auditoriaService
          .alterarAuditoriaLogisticaEnderecoPorCodigo(
            baseUrl: baseUrl,
            idProduto: auditoria.codigo,
            request: RequestAlterarEnderecoProduto(
              codigoalfa: _eanController.text.trim(),
              dun14: _dun14Controller.text.trim(),
              localizacao: localizacao,
              wmsrua: n(_apanhaRuaController),
              wmsblc: n(_apanhaBlcController),
              wmsmod: n(_apanhaModController),
              wmsniv: n(_apanhaNivController),
              wmsapt: n(_apanhaAptController),
              wmsgvt: 0,
              wmsrua2: n(_pulmaoRuaController),
              wmsblc2: n(_pulmaoBlcController),
              wmsmod2: n(_pulmaoModController),
              wmsniv2: n(_pulmaoNivController),
              wmsapt2: n(_pulmaoAptController),
              wmsgvt2: 0,
            ),
          );
      if (!mounted) return;
      if (ok) {
        AppSnackBar.sucesso(context, 'Endereço atualizado.');
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao salvar endereço: $e');
    } finally {
      if (mounted) setState(() => _salvandoEndereco = false);
    }
  }

  Future<void> _salvarDadoFisico() async {
    if (_salvandoDadoFisico) return;

    final auditoria = _auditoria;
    if (auditoria == null) return;

    final deps = AppScope.of(context);
    final baseUrl = deps.parametroController.parametro.url.trim();
    if (baseUrl.isEmpty) {
      AppSnackBar.erro(context, 'Configure a URL da API antes de salvar.');
      return;
    }

    final peso = NumeroFormatar.parseOrZero(_pesoController.text);
    final altura = NumeroFormatar.parseOrZero(_alturaController.text);
    final largura = NumeroFormatar.parseOrZero(_larguraController.text);
    final comprimento = NumeroFormatar.parseOrZero(_comprimentoController.text);

    if (peso < 0 || altura < 0 || largura < 0 || comprimento < 0) {
      AppSnackBar.erro(context, 'Valores não podem ser negativos.');
      return;
    }

    setState(() => _salvandoDadoFisico = true);
    try {
      final ok = await deps.auditoriaService
          .alterarAuditoriaLogisticaDadoFisicoPorCodigo(
            baseUrl: baseUrl,
            idProduto: auditoria.codigo,
            request: RequestDadoFisicoProduto(
              peso: peso,
              altura: altura,
              largura: largura,
              comprimento: comprimento,
            ),
          );
      if (!mounted) return;
      if (ok) {
        AppSnackBar.sucesso(context, 'Dados físicos atualizados.');
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao salvar dados físicos: $e');
    } finally {
      if (mounted) setState(() => _salvandoDadoFisico = false);
    }
  }

  String _formatQtd(double value) {
    if (!value.isFinite) return '0';
    final rounded = value.roundToDouble();
    if ((value - rounded).abs() < 0.000001) return rounded.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }

  String _formatDecimal(double value) {
    if (!value.isFinite) return '0';
    final rounded = value.roundToDouble();
    if ((value - rounded).abs() < 0.000001) {
      return rounded.toStringAsFixed(0).replaceAll('.', ',');
    }
    return value.toStringAsFixed(4).replaceAll('.', ',');
  }

  String _formatValidade(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '';
    if (v.contains('/')) return v;
    final dt = DateTime.tryParse(v);
    if (dt == null) return v;
    return DataFormatar.formatDtDDMMYY(dt);
  }

  Widget _buildResultado() {
    if (_buscando) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text(
              'Consultando produto...',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    final hasAuditoria = _auditoria != null;
    final auditoria = _auditoria ?? AuditoriaLogisticaModel.empty();
    final habilitado = _auditoria != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuditoriaResumoCard(
            auditoria: auditoria,
            hasAuditoria: hasAuditoria,
            formatQtd: _formatQtd,
          ),
          const SizedBox(height: 6),
          AuditoriaCodigosBarraCard(
            buscando: _buscando,
            salvando: _salvandoCodigoBarra,
            habilitado: habilitado,
            eanController: _eanController,
            dun14Controller: _dun14Controller,
            onSalvar: _salvarCodigosDeBarra,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auditoria = _auditoria;
    final bloqueado =
        _buscando || _salvandoCodigoBarra || _salvandoEndereco || _salvandoDadoFisico;
    final hasAuditoria = auditoria != null;

    return PopScope(
      canPop: !bloqueado,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (bloqueado) {
          FocusScope.of(context).unfocus();
          AppSnackBar.erro(
            context,
            'Aguarde finalizar a operação antes de sair.',
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Auditoria de Estoque'), elevation: 0),
        body: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuditoriaCodigoRow(
                      controller: _codigoController,
                      focusNode: _codigoFocus,
                      buscando: _buscando,
                      onBuscar: _buscarProduto,
                      onLimpar: _limparTela,
                      onAbrirPesquisaNome: _abrirPesquisaNome,
                      onAbrirScanner: _abrirScanner,
                    ),
                    if (!_buscando && _auditoria == null) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Informe o código e pesquise para iniciar a auditoria.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TabBar(
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(text: 'Ficha'),
                    Tab(text: 'Endereço'),
                    Tab(text: 'D.Físicos'),
                    Tab(text: 'Lotes'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  children: [
                    AuditoriaFichaTab(
                      produtoLabel: auditoria != null
                          ? AuditoriaProdutoLabel(auditoria: auditoria)
                          : null,
                      resultado: _buildResultado(),
                    ),
                    AuditoriaEnderecoTab(
                      buscando: _buscando,
                      auditoria: auditoria,
                      enderecoCard: () => AuditoriaEnderecoCard(
                        buscando: _buscando,
                        salvando: _salvandoEndereco,
                        habilitado: hasAuditoria,
                        localizacaoController: _localizacaoController,
                        apanhaRuaController: _apanhaRuaController,
                        apanhaBlcController: _apanhaBlcController,
                        apanhaModController: _apanhaModController,
                        apanhaNivController: _apanhaNivController,
                        apanhaAptController: _apanhaAptController,
                        pulmaoRuaController: _pulmaoRuaController,
                        pulmaoBlcController: _pulmaoBlcController,
                        pulmaoModController: _pulmaoModController,
                        pulmaoNivController: _pulmaoNivController,
                        pulmaoAptController: _pulmaoAptController,
                        onSalvar: _salvarEndereco,
                      ),
                    ),
                    AuditoriaDadoFisicoTab(
                      buscando: _buscando,
                      auditoria: auditoria,
                      dadoFisicoCard: () => AuditoriaDadoFisicoCard(
                        buscando: _buscando,
                        salvando: _salvandoDadoFisico,
                        habilitado: hasAuditoria,
                        pesoController: _pesoController,
                        alturaController: _alturaController,
                        larguraController: _larguraController,
                        comprimentoController: _comprimentoController,
                        onSalvar: _salvarDadoFisico,
                      ),
                    ),
                    AuditoriaLotesTab(
                      buscando: _buscando,
                      auditoria: auditoria,
                      cardBuilder: (child) => AuditoriaCard(child: child),
                      formatValidade: _formatValidade,
                      formatQtd: _formatQtd,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
