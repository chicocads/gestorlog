import 'package:flutter/material.dart';

import '../../../models/auditoria/auditoria_model.dart';

class AuditoriaEnderecoTab extends StatelessWidget {
  const AuditoriaEnderecoTab({
    super.key,
    required this.buscando,
    required this.auditoria,
    required this.enderecoCard,
  });

  final bool buscando;
  final AuditoriaLogisticaModel? auditoria;
  final Widget Function() enderecoCard;

  @override
  Widget build(BuildContext context) {
    if (buscando) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [enderecoCard()],
    );
  }
}
