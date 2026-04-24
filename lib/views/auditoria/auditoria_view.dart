import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_snack_bar.dart';
import '../../core/utils/data_formatar.dart';
import '../../core/utils/string_sanitizer.dart';
import '../../core/widgets/app_int_field.dart';
import '../../models/diversos/auditoria_model.dart';
import '../../services/auditoria/request_alterar_barra_produto.dart';
import '../../services/auditoria/request_endereco_produto.dart';
import '../widget/scanner_view.dart';
import 'tabs/auditoria_endereco_tab.dart';
import 'tabs/auditoria_ficha_tab.dart';
import 'tabs/auditoria_lotes_tab.dart';

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
  bool _buscando = false;
  bool _salvandoCodigoBarra = false;
  bool _salvandoEndereco = false;
  AuditoriaLogisticaModel? _auditoria;

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

    if (v.length != 13 && v.length != 14) {
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
      final ok = await deps.auditoriaService.alterarAuditoriaLogisticaCodigoBarraProduto(
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
      AppSnackBar.erro(context, 'Localização deve ter no máximo 60 caracteres.');
      return;
    }

    int n(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;

    setState(() => _salvandoEndereco = true);
    try {
      final ok = await deps.auditoriaService.alterarAuditoriaLogisticaEnderecoPorCodigo(
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

  Widget _buildCodigoRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _codigoController,
            focusNode: _codigoFocus,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onTap: () => selectAllText(_codigoController),
            onSubmitted: (_) => _buscarProduto(),
            onChanged: (value) {
              final v = value.trim();
              if (!StringSanitizer.isDigits(v)) return;
              if (v.length != 13 && v.length != 14) return;
              if (!StringSanitizer.isValidEan(v)) return;
              _buscarProduto();
            },
            decoration: InputDecoration(
              labelText: 'Código de barras',
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: IconButton(
                onPressed: _buscando ? null : _buscarProduto,
                icon: _buscando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                color: AppColors.primary,
                tooltip: 'Buscar',
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 48,
          height: 48,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: _buscando ? null : _limparTela,
              icon: const Icon(Icons.cleaning_services_outlined),
              color: Colors.white,
              tooltip: 'Limpar',
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 48,
          height: 48,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: _buscando ? null : _abrirScanner,
              icon: const Icon(Icons.qr_code_scanner_outlined),
              color: Colors.white,
              tooltip: 'Ler código',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnderecoEditor({
    required String titulo,
    required TextEditingController ruaController,
    required TextEditingController blcController,
    required TextEditingController modController,
    required TextEditingController nivController,
    required TextEditingController aptController,
  }) {
    final inputFormatters = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(3),
      TextInputFormatter.withFunction((oldValue, newValue) {
        final text = newValue.text;
        if (text.isEmpty) return newValue;
        final v = int.tryParse(text);
        if (v == null) return oldValue;
        if (v > 999) return oldValue;
        return newValue;
      }),
    ];

    Widget campo(
      String label,
      TextEditingController controller, {
      TextInputType keyboardType = TextInputType.number,
    }) {
      return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) selectAllText(controller);
        },
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onTap: () => selectAllText(controller),
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: campo('Rua', ruaController)),
            const SizedBox(width: 8),
            Expanded(child: campo('Blc', blcController)),
            const SizedBox(width: 8),
            Expanded(child: campo('Mod', modController)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: campo('Niv', nivController)),
            const SizedBox(width: 8),
            Expanded(child: campo('Apt', aptController)),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }

  String _formatQtd(double value) {
    if (!value.isFinite) return '0';
    final rounded = value.roundToDouble();
    if ((value - rounded).abs() < 0.000001) return rounded.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }

  String _formatValidade(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '';
    if (v.contains('/')) return v;
    final dt = DateTime.tryParse(v);
    if (dt == null) return v;
    return DataFormatar.formatDate(dt);
  }

  Widget _buildStat(
    String label,
    String value, {
    double labelFontSize = 11,
    double valueFontSize = 14,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: labelFontSize,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildProdutoLabel(AuditoriaLogisticaModel auditoria) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        '${auditoria.codigo} - ${auditoria.nome}',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildEnderecoCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) selectAllText(_localizacaoController);
                  },
                  child: TextField(
                    controller: _localizacaoController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [LengthLimitingTextInputFormatter(60)],
                    onTap: () => selectAllText(_localizacaoController),
                    decoration: const InputDecoration(
                      labelText: 'Localização',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: (_buscando || _salvandoEndereco || _auditoria == null)
                    ? null
                    : _salvarEndereco,
                icon: _salvandoEndereco
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                color: AppColors.primary,
                tooltip: 'Salvar',
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildEnderecoEditor(
            titulo: 'Endereço Apanha',
            ruaController: _apanhaRuaController,
            blcController: _apanhaBlcController,
            modController: _apanhaModController,
            nivController: _apanhaNivController,
            aptController: _apanhaAptController,
          ),
          const SizedBox(height: 10),
          _buildEnderecoEditor(
            titulo: 'Endereço Pulmão',
            ruaController: _pulmaoRuaController,
            blcController: _pulmaoBlcController,
            modController: _pulmaoModController,
            nivController: _pulmaoNivController,
            aptController: _pulmaoAptController,
          ),
        ],
      ),
    );
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStat(
                        'Und',
                        auditoria.undvenda.trim().isNotEmpty
                            ? auditoria.undvenda
                            : '-',
                        labelFontSize: 13,
                        valueFontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStat(
                        'Fator',
                        auditoria.fator.toString(),
                        labelFontSize: 13,
                        valueFontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildStat(
                        'Emb',
                        auditoria.qtembala.toString(),
                        labelFontSize: 13,
                        valueFontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStat(
                        'Saldo',
                        hasAuditoria ? _formatQtd(auditoria.saldo) : '-',
                        labelFontSize: 13,
                        valueFontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildStat(
                        'Reserva',
                        hasAuditoria ? _formatQtd(auditoria.reserva) : '-',
                        labelFontSize: 13,
                        valueFontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStat(
                        'Qtde Separada',
                        hasAuditoria ? _formatQtd(auditoria.qtse) : '-',
                        labelFontSize: 13,
                        valueFontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: _buildStat(
                        'Qtde em Carga',
                        hasAuditoria ? _formatQtd(auditoria.qtcc) : '-',
                        labelFontSize: 13,
                        valueFontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStat(
                        'Qtde sem Carga',
                        hasAuditoria ? _formatQtd(auditoria.qtsc) : '-',
                        labelFontSize: 13,
                        valueFontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Códigos de Barra',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: (_buscando ||
                              _salvandoCodigoBarra ||
                              _auditoria == null)
                          ? null
                          : _salvarCodigosDeBarra,
                      icon: _salvandoCodigoBarra
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      color: AppColors.primary,
                      tooltip: 'Salvar',
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (hasFocus) selectAllText(_eanController);
                        },
                        child: TextField(
                          controller: _eanController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onTap: () => selectAllText(_eanController),
                          decoration: const InputDecoration(
                            labelText: 'EAN',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (hasFocus) selectAllText(_dun14Controller);
                        },
                        child: TextField(
                          controller: _dun14Controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onTap: () => selectAllText(_dun14Controller),
                          decoration: const InputDecoration(
                            labelText: 'DUN14',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auditoria = _auditoria;
    return Scaffold(
      appBar: AppBar(title: const Text('Auditoria de Estoque'), elevation: 0),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCodigoRow(),
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
                labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: 'Ficha'),
                  Tab(text: 'Endereço'),
                  Tab(text: 'Lotes'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: [
                  AuditoriaFichaTab(
                    produtoLabel: auditoria != null ? _buildProdutoLabel(auditoria) : null,
                    resultado: _buildResultado(),
                  ),
                  AuditoriaEnderecoTab(
                    buscando: _buscando,
                    auditoria: auditoria,
                    enderecoCard: _buildEnderecoCard,
                  ),
                  AuditoriaLotesTab(
                    buscando: _buscando,
                    auditoria: auditoria,
                    cardBuilder: (child) => _buildCard(child: child),
                    formatValidade: _formatValidade,
                    formatQtd: _formatQtd,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
