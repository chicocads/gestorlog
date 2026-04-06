import 'package:flutter/material.dart';
import '../../controllers/parametro_controller.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/app_snack_bar.dart';
import '../../core/widgets/app_int_field.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/form_body.dart';

class ParametroView extends StatefulWidget {
  const ParametroView({
    super.key,
    required this.controller,
    required this.isAdmin,
  });

  final ParametroController controller;
  final bool isAdmin;

  @override
  State<ParametroView> createState() => _ParametroViewState();
}

class _ParametroViewState extends State<ParametroView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idCadsCtrl;
  late final TextEditingController _idPdaCtrl;
  late final TextEditingController _idFilialCtrl;
  late final TextEditingController _urlCtrl;
  late final TextEditingController _idInventarioCtrl;
  late final TextEditingController _decPrecoCtrl;
  late final TextEditingController _decQtdeCtrl;

  bool _saving = false;
  bool _obscureUrl = true;

  @override
  void initState() {
    super.initState();
    final p = widget.controller.parametro;
    _idCadsCtrl = TextEditingController(text: p.idCads.toString());
    _idPdaCtrl = TextEditingController(text: p.idPda.toString());
    _idFilialCtrl = TextEditingController(text: p.idFilial.toString());
    _idInventarioCtrl = TextEditingController(text: p.idInventario.toString());
    _urlCtrl = TextEditingController(text: p.url);
    _decPrecoCtrl = TextEditingController(text: p.decPreco.toString());
    _decQtdeCtrl = TextEditingController(text: p.decQtde.toString());
  }

  @override
  void dispose() {
    _idCadsCtrl.dispose();
    _idPdaCtrl.dispose();
    _idFilialCtrl.dispose();
    _idInventarioCtrl.dispose();
    _urlCtrl.dispose();
    _decPrecoCtrl.dispose();
    _decQtdeCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await widget.controller.save(
      widget.controller.parametro.copyWith(
        idCads: int.parse(_idCadsCtrl.text.trim()),
        idPda: int.parse(_idPdaCtrl.text.trim()),
        idFilial: int.parse(_idFilialCtrl.text.trim()),
        idInventario: int.parse(_idInventarioCtrl.text.trim()),
        url: _urlCtrl.text.trim(),
        decPreco: int.parse(_decPrecoCtrl.text.trim()),
        decQtde: int.parse(_decQtdeCtrl.text.trim()),
      ),
    );

    if (!mounted) return;
    setState(() => _saving = false);

    if (widget.controller.error != null) {
      AppSnackBar.erro(context, widget.controller.error!);
    } else {
      AppSnackBar.sucesso(context, 'Parâmetros salvos com sucesso!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        if (widget.controller.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Parâmetros')),
          body: FormBody(
            formKey: _formKey,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppIntField(
                      controller: _idCadsCtrl,
                      label: 'ID CADS',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppIntField(controller: _idPdaCtrl, label: 'ID PDA'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppIntField(
                      controller: _idFilialCtrl,
                      label: 'ID Filial',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppIntField(
                      controller: _idInventarioCtrl,
                      label: 'ID Inventário',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppIntField(
                      controller: _decPrecoCtrl,
                      label: 'Dec. Preço',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppIntField(
                      controller: _decQtdeCtrl,
                      label: 'Dec. Qtde',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlCtrl,
                obscureText: _obscureUrl,
                decoration: InputDecoration(
                  labelText: 'URL do servidor',
                  hintText: 'http://endereco:porta',
                  suffixIcon: widget.isAdmin
                      ? IconButton(
                          icon: Icon(
                            _obscureUrl
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _obscureUrl = !_obscureUrl),
                        )
                      : null,
                ),
                keyboardType: TextInputType.url,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe a URL.' : null,
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: AppStrings.save,
                icon: Icons.save_rounded,
                isLoading: _saving,
                onPressed: _salvar,
              ),
            ],
          ),
        );
      },
    );
  }
}
