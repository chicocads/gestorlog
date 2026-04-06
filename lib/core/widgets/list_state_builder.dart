import 'package:flutter/material.dart';
import 'empty_state.dart';
import 'error_banner.dart';

/// Gerencia os três estados comuns de uma lista:
/// carregando → erro → vazio → conteúdo.
class ListStateBuilder extends StatelessWidget {
  const ListStateBuilder({
    super.key,
    required this.isLoading,
    required this.isEmpty,
    required this.builder,
    this.error,
    this.emptyMessage = 'Nenhum item encontrado.',
    this.emptyIcon,
  });

  final bool isLoading;
  final bool isEmpty;
  final Widget Function() builder;
  final String? error;
  final String emptyMessage;
  final IconData? emptyIcon;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ErrorBanner(message: error!),
      );
    }
    if (isEmpty) {
      return EmptyState(message: emptyMessage, icon: emptyIcon);
    }
    return builder();
  }
}
