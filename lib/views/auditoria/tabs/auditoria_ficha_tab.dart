import 'package:flutter/material.dart';

class AuditoriaFichaTab extends StatelessWidget {
  const AuditoriaFichaTab({
    super.key,
    required this.produtoLabel,
    required this.resultado,
  });

  final Widget? produtoLabel;
  final Widget resultado;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        if (produtoLabel != null) ...[
          produtoLabel!,
          const SizedBox(height: 10),
        ],
        resultado,
      ],
    );
  }
}

