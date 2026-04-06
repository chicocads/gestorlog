import 'package:flutter/foundation.dart';

/// Base para todos os controllers do projeto.
/// Gerencia [isLoading] e [error], eliminando boilerplate repetido.
abstract class BaseController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Executa [action] assíncrona gerenciando loading e erro automaticamente.
  Future<void> runAsync(Future<void> Function() action) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpa o erro atual e notifica listeners.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Executa [action] síncrona gerenciando loading e erro automaticamente.
  void runSync(void Function() action) {
    _isLoading = true;
    notifyListeners();
    try {
      action();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
