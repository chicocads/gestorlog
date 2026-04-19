import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/http/file_download.dart';
import '../../core/utils/app_snack_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/error_banner.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _loginCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _loginFocus = FocusNode();
  bool _senhaVisivel = false;
  bool _atualizando = false;
  double _progressoDownload = 0;
  static const _versao = 'v1.0.0+1';

  @override
  void dispose() {
    _loginCtrl.dispose();
    _senhaCtrl.dispose();
    _loginFocus.dispose();
    super.dispose();
  }

  static const _urlApk =
      'http://cadsma.dyndns.info:8082/GestorService/Download/app-gestorlog.apk';

  Future<bool> _temInternet() async {
    try {
      final result = await InternetAddress.lookup(
        'one.one.one.one',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  Future<void> _atualizarApp() async {
    setState(() {
      _atualizando = true;
      _progressoDownload = 0;
    });
    try {
      final file = await FileDownload.instance.downloadFile(
        _urlApk,
        forcar: true,
        receiveTimeout: const Duration(minutes: 5),
        onProgress: (p) => setState(() => _progressoDownload = p),
      );
      if (!mounted) return;
      AppSnackBar.sucesso(context, 'Download concluido. Instalando...');
      await OpenFilex.open(file.path);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.erro(context, 'Erro ao baixar atualizacao: $e');
    } finally {
      if (mounted) setState(() => _atualizando = false);
    }
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;

    final login = _loginCtrl.text.trim().toUpperCase();
    final senha = _senhaCtrl.text.trim();
    final now = DateTime.now();
    final senhaAdmin =
        '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${(now.year % 100).toString().padLeft(2, '0')}';

    if (login == 'ADMIN' && senha == senhaAdmin) {
      await Navigator.pushNamed(context, AppRoutes.parametros, arguments: true);
      _loginCtrl.clear();
      _senhaCtrl.clear();
      _loginFocus.requestFocus();
      return;
    }

    final conectado = await _temInternet();
    if (!mounted) return;
    if (!conectado) {
      AppSnackBar.erro(context, 'Sem internet. Ative a internet e tente novamente.');
      return;
    }

    final ok = await AppScope.of(context).usuarioController.login(
          login,
          senha,
        );

    if (!mounted) return;

    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName,style: TextStyle(fontSize: 26,
        fontWeight: FontWeight.bold,),
                        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () {
              SystemNavigator.pop();
              exit(0);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_cads.png', height: 150),
            ],
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ListenableBuilder(
                listenable: AppScope.of(context).usuarioController,
                builder: (context, _) {
                  final usuarioController =
                      AppScope.of(context).usuarioController;
                  final isLoading = usuarioController.isLoading;
                  final erro = usuarioController.error;

                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/inventario.ico',
                          width: 72,
                          height: 72,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _loginCtrl,
                          focusNode: _loginFocus,
                          enabled: !isLoading,
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            TextInputFormatter.withFunction(
                              (old, new_) => new_.copyWith(
                                text: new_.text.toUpperCase(),
                                selection: new_.selection,
                              ),
                            ),
                          ],
                          decoration: const InputDecoration(
                            labelText: AppStrings.login,
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          textInputAction: TextInputAction.next,
                          onTap: () => _loginCtrl.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _loginCtrl.text.length,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? AppStrings.loginObrigatorio
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _senhaCtrl,
                          enabled: !isLoading,
                          obscureText: !_senhaVisivel,
                          decoration: InputDecoration(
                            labelText: AppStrings.senha,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _senhaVisivel
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _senhaVisivel = !_senhaVisivel,
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          onTap: () => _senhaCtrl.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _senhaCtrl.text.length,
                          ),
                          onFieldSubmitted: (_) => _entrar(),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? AppStrings.senhaObrigatoria
                              : null,
                        ),
                        if (erro != null) ...[
                          const SizedBox(height: 16),
                          ErrorBanner(message: erro),
                        ],
                        const SizedBox(height: 28),
                        CustomButton(
                          label: AppStrings.entrar,
                          isLoading: isLoading,
                          onPressed: _entrar,
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          height: 44,
                          width: double.infinity,
                          child: _atualizando
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LinearProgressIndicator(
                                      value: _progressoDownload > 0
                                          ? _progressoDownload
                                          : null,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _progressoDownload > 0
                                          ? 'Baixando... ${(_progressoDownload * 100).toStringAsFixed(0)}%'
                                          : 'Conectando...',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                )
                              : OutlinedButton.icon(
                                  onPressed: _atualizarApp,
                                  icon: const Icon(Icons.system_update),
                                  label: const Text('Atualizar App'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          _versao,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
