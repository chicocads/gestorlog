import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/utils/data_formatar.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/utils/string_sanitizer.dart';
import '../../../models/cadastro/produto_model.dart';
import '../../../models/inventario/inventario_model.dart';
import '../../../services/cadastro/produto/produto_local_service.dart';
import '../../../services/inventario/inventario_local_service.dart';
import '../../widget/scanner_view.dart';

class InventarioColetaTab extends StatefulWidget {
  const InventarioColetaTab({super.key});

  @override
  State<InventarioColetaTab> createState() => _InventarioColetaTabState();
}

class _InventarioColetaTabState extends State<InventarioColetaTab> {
  final _codigoController = TextEditingController();
  final _codigoFocus = FocusNode();
  final _nomeProdutoManualController = TextEditingController();
  final _nomeProdutoManualFocus = FocusNode();
  final _pecasController = TextEditingController(text: '0');
  final _qtdeController = TextEditingController(text: '1');
  final _qtdeFocus = FocusNode();
  final _loteController = TextEditingController();
  final _validadeController = TextEditingController();
  final _produtoLocalService = ProdutoLocalService();
  final _inventarioLocalService = InventarioLocalService();

  bool _buscandoProduto = false;
  ProdutoModel? _produtoColetado;
  bool _produtoNaoCadastrado = false;
  bool _somarMais1EVoltarCodigo = false;
  String _ultimoCodigoLancado = '';
  String _ultimaQtdeLancada = '';

  bool get _controlePecasAtivo =>
      AppScope.of(context).parametroController.parametro.controlePecas == 1;

  bool get _deveColetarLoteValidade => _produtoColetado?.controlelote == 1;

  int get _decQtde =>
      AppScope.of(context).parametroController.parametro.decQtde;

  @override
  void dispose() {
    _codigoController.dispose();
    _codigoFocus.dispose();
    _nomeProdutoManualController.dispose();
    _nomeProdutoManualFocus.dispose();
    _pecasController.dispose();
    _qtdeController.dispose();
    _qtdeFocus.dispose();
    _loteController.dispose();
    _validadeController.dispose();
    super.dispose();
  }

  void _focarQtde() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _qtdeFocus.requestFocus();
      _qtdeController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _qtdeController.text.length,
      );
    });
  }

  void _abrirScanner() {
    showBarcodeScannerBottomSheet(context).then((rawValue) {
      if (!mounted) return;
      if (rawValue == null || rawValue.isEmpty) return;

      final codigo = StringSanitizer.digitsOnly(rawValue.trim());
      if (codigo.isEmpty) return;
      if (!_validarCodigoBarra(codigo)) {
        _focarCodigo(limpar: true);
        return;
      }
      _codigoController.text = codigo;
      _buscarProduto(disparadoPorCodigo: true);
    });
  }

  bool _validarCodigoBarra(String codigo) {
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

    if (!StringSanitizer.isValidGtin(v, length: v.length)) {
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

  void _focarCodigo({bool limpar = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (limpar) {
        _codigoController.clear();
      }
      _codigoFocus.requestFocus();
      _codigoController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _codigoController.text.length,
      );
    });
  }

  bool _produtoColetadoCorrespondeAoCodigo(String codigoDigitado) {
    final produto = _produtoColetado;
    if (produto == null) return false;

    final codigo = codigoDigitado.trim();
    if (codigo.isEmpty) return false;

    if (codigo.length > 10) {
      final barra = codigo;
      return produto.codigoalfa.trim() == barra || produto.dun14.trim() == barra;
    }

    final cod = int.tryParse(codigo);
    if (cod == null) return false;
    return produto.codigo == cod;
  }

  Future<ProdutoModel?> _buscarProdutoSilent(String termo) async {
    ProdutoModel? produto;
    if (termo.length > 10) {
      produto = await _produtoLocalService.buscarPorCodigoBarra(termo);
    } else {
      final codigo = int.tryParse(termo);
      if (codigo != null) {
        produto = await _produtoLocalService.buscarPorCodigo(codigo);
      }
    }

    if (!mounted) return produto;
    setState(() {
      _produtoColetado = produto;
      _produtoNaoCadastrado = produto == null;
      _buscandoProduto = false;
    });
    if (produto != null) {
      _nomeProdutoManualController.text = produto.nome;
    }
    if (_somarMais1EVoltarCodigo) {
      _qtdeController.text = '1';
    }
    return produto;
  }

  Future<void> _buscarProduto({bool disparadoPorCodigo = false}) async {
    if (_buscandoProduto) return;
    final termo = _codigoController.text.trim();
    if (termo.isEmpty) return;

    if (!StringSanitizer.isDigits(termo)) {
      AppSnackBar.erro(context, 'Informe apenas números no código.');
      return;
    }
    if (!_validarCodigoBarra(termo)) {
      return;
    }

    setState(() {
      _buscandoProduto = true;
      _produtoNaoCadastrado = false;
      _produtoColetado = null;
      _nomeProdutoManualController.clear();
      _loteController.clear();
      _validadeController.clear();
    });

    try {
      ProdutoModel? produto;
      if (termo.length > 10) {
        produto = await _produtoLocalService.buscarPorCodigoBarra(termo);
      } else {
        final codigo = int.tryParse(termo);
        if (codigo != null) {
          produto = await _produtoLocalService.buscarPorCodigo(codigo);
        }
      }

      if (!mounted) return;
      setState(() {
        _produtoColetado = produto;
        _produtoNaoCadastrado = produto == null;
      });
      _nomeProdutoManualController.text = produto?.nome ?? '';
      if (_somarMais1EVoltarCodigo) {
        _qtdeController.text = '1';
      }
      if (produto == null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _nomeProdutoManualFocus.requestFocus();
        });
      } else if (produto != null && disparadoPorCodigo) {
        if (_somarMais1EVoltarCodigo &&
            !_controlePecasAtivo &&
            !_deveColetarLoteValidade) {
          await _salvarColeta(ignorarBuscandoProduto: true);
          if (!mounted) return;
          _focarCodigo(limpar: true);
          return;
        }
        if (_somarMais1EVoltarCodigo && _deveColetarLoteValidade) {
          _focarQtde();
        } else if (!_somarMais1EVoltarCodigo) {
          _focarQtde();
        }
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao buscar produto: $e');
    } finally {
      if (mounted) {
        setState(() {
          _buscandoProduto = false;
        });
      }
    }

    if (!mounted) return;
    if (_produtoNaoCadastrado) {
      AppSnackBar.erro(context, 'Produto não cadastrado.');
    }
  }

  double? _parseQtde(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return null;
    final normalized = v.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  int? _parseInt(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return null;
    return int.tryParse(v);
  }

  Future<void> _salvarColeta({bool ignorarBuscandoProduto = false}) async {
    final codigo = _codigoController.text.trim();
    if (codigo.isEmpty) {
      AppSnackBar.erro(context, 'Informe o código para coletar.');
      return;
    }
    if (!StringSanitizer.isDigits(codigo)) {
      AppSnackBar.erro(context, 'O código deve conter apenas números.');
      return;
    }
    if (!_validarCodigoBarra(codigo)) {
      _focarCodigo();
      return;
    }

    if (_buscandoProduto && !ignorarBuscandoProduto) return;
    if (!_produtoColetadoCorrespondeAoCodigo(codigo)) {
      setState(() {
        _buscandoProduto = true;
        _produtoNaoCadastrado = false;
        _produtoColetado = null;
      });
      try {
        await _buscarProdutoSilent(codigo);
      } catch (_) {
        if (mounted) {
          setState(() {
            _buscandoProduto = false;
          });
        }
      }
    }
    if (!mounted) return;
    
    if (_nomeProdutoManualController.text.isEmpty) {
      AppSnackBar.erro(context, 'Informe o nome para coletar.');
      return;
    }

    final pecas = _controlePecasAtivo ? _parseInt(_pecasController.text) : 0;
    if (_controlePecasAtivo) {
      if (pecas == null) {
        AppSnackBar.erro(context, 'Informe as peças.');
        return;
      }
      if (pecas <= 0) {
        AppSnackBar.erro(context, 'Peças deve ser maior que zero.');
        return;
      }
    }

    final qtde = _somarMais1EVoltarCodigo ? 1.0 : _parseQtde(_qtdeController.text);
    if (qtde == null) {
      AppSnackBar.erro(context, 'Informe a quantidade.');
      return;
    }
    if (qtde <= 0) {
      AppSnackBar.erro(context, 'Quantidade deve ser maior que zero.');
      return;
    }

    final produto = _produtoColetado;
    final nomeInformado = _nomeProdutoManualController.text.trim().toUpperCase();
    final codigoBarraCadastro = produto != null
        ? (produto.codigoalfa.trim().isNotEmpty
              ? produto.codigoalfa.trim()
              : produto.dun14.trim())
        : '';
    final codigoBarraInventario =
        codigoBarraCadastro.isNotEmpty ? codigoBarraCadastro : codigo;

    var lote = _loteController.text.trim();
    var validadeTxt = _validadeController.text.trim();
    var validade = '';

    if (_deveColetarLoteValidade) {
      if (lote.isEmpty) {
        AppSnackBar.erro(context, 'Informe o lote.');
        return;
      }
      if (validadeTxt.isEmpty) {
        AppSnackBar.erro(context, 'Informe a validade.');
        return;
      }
      if (DataFormatar.parseDdMmYyyy(validadeTxt) == null) {
        AppSnackBar.erro(context, 'Validade inválida (use DD/MM/AAAA).');
        return;
      }
      validade = DataFormatar.toIsoDateFromDdMmYyyy(validadeTxt);
    } else {
      lote = '';
    }

    final item = InventarioModel.empty().copyWith(
      produto: produto?.codigo ?? 0,
      codigoBarra: codigoBarraInventario,
      pecas: pecas ?? 0,
      qtde: qtde,
      lote: lote,
      validade: validade,
      nomePro: produto?.nome ?? nomeInformado,
    );

    try {
      await _inventarioLocalService.gravarOuSomar(item);
      if (!mounted) return;
      AppSnackBar.sucesso(context, 'Lançamento salvo com sucesso.');
      setState(() {
        _ultimoCodigoLancado = codigo;
        _ultimaQtdeLancada =
            _somarMais1EVoltarCodigo ? '1' : _qtdeController.text.trim();
        _codigoController.clear();
        _nomeProdutoManualController.clear();
        _pecasController.text = '0';
        _qtdeController.text = '1';
        _loteController.clear();
        _validadeController.clear();
        _produtoColetado = null;
        _produtoNaoCadastrado = false;
      });
      _focarCodigo();
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao salvar coleta: $e');
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
            onSubmitted: (_) => _buscarProduto(disparadoPorCodigo: true),
            onChanged: (value) {
              final v = value.trim();
              if (!StringSanitizer.isDigits(v)) return;
              if (v.length != 13 && v.length != 14) return;
              if (!StringSanitizer.isValidGtin(v, length: v.length)) return;
              _buscarProduto(disparadoPorCodigo: true);
            },
            decoration: InputDecoration(
              labelText: 'Código de barras',
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: IconButton(
                onPressed:
                    _buscandoProduto ? null : () => _buscarProduto(disparadoPorCodigo: true),
                icon: _buscandoProduto
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
              onPressed: _buscandoProduto ? null : _abrirScanner,
              icon: const Icon(Icons.qr_code_scanner_outlined),
              color: Colors.white,
              tooltip: 'Ler código',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProdutoStatusOuNome() {
    if (_buscandoProduto) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text(
              'Buscando produto...',
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

    final produto = _produtoColetado;
    if (produto != null) {
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
          '${produto.codigo} - ${produto.nome}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      );
    }

    return TextField(
      controller: _nomeProdutoManualController,
      focusNode: _nomeProdutoManualFocus,
      enabled: true,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        UpperCaseTextFormatter(),
        LengthLimitingTextInputFormatter(80),
      ],
      decoration: InputDecoration(
        labelText: 'Nome do produto',
        hintText: _produtoNaoCadastrado
            ? 'Digite o nome do produto'
            : 'Digite o nome (se não localizar)',
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  Widget _buildPecasQtdeRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _pecasController,
            enabled: _controlePecasAtivo,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Peças',
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _qtdeController,
            focusNode: _qtdeFocus,
            readOnly: _somarMais1EVoltarCodigo,
            keyboardType: TextInputType.numberWithOptions(
              decimal: _decQtde > 0,
            ),
            inputFormatters: _decQtde == 0
                ? [FilteringTextInputFormatter.digitsOnly]
                : [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final text = newValue.text;
                      for (final unit in text.codeUnits) {
                        final isDigit = unit >= 48 && unit <= 57;
                        final isComma = unit == 44;
                        if (!isDigit && !isComma) return oldValue;
                      }
                      return newValue;
                    }),
                    DecimalMaxDigitsFormatter(_decQtde),
                  ],
            decoration: const InputDecoration(
              labelText: 'Quantidade',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoteValidadeRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _loteController,
            enabled: _deveColetarLoteValidade,
            decoration: const InputDecoration(
              labelText: 'Lote',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _validadeController,
            enabled: _deveColetarLoteValidade,
            keyboardType: TextInputType.datetime,
            inputFormatters: [DateDdMmYyyyFormatter()],
            decoration: const InputDecoration(
              labelText: 'Validade',
              hintText: 'DD/MM/AAAA',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchAutoContagem() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Contagem rapida por código:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: _somarMais1EVoltarCodigo,
            onChanged: (v) => setState(() {
              _somarMais1EVoltarCodigo = v;
              if (v) _qtdeController.text = '1';
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildUltimoLancamento() {
    final codigo = _ultimoCodigoLancado.isNotEmpty ? _ultimoCodigoLancado : '-';
    final qtde = _ultimaQtdeLancada.isNotEmpty ? _ultimaQtdeLancada : '-';
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.history_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Último código: $codigo',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.20),
                ),
              ),
              child: Text(
                'Qtde: $qtde',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final podeSalvar =
        AppScope.of(context).parametroController.parametro.idInventario > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCodigoRow(),
          const SizedBox(height: 10),
          _buildProdutoStatusOuNome(),
          const SizedBox(height: 10),
          _buildPecasQtdeRow(),
          const SizedBox(height: 10),
          _buildLoteValidadeRow(),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: podeSalvar ? _salvarColeta : null,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Salvar'),
          ),
          const SizedBox(height: 50),
          _buildSwitchAutoContagem(),
          _buildUltimoLancamento(),
        ],
      ),
    );
  }
}
