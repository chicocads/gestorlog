import 'package:flutter/material.dart';

import '../widgets/inventario_tab_placeholder.dart';

class InventarioColetadosTab extends StatelessWidget {
  const InventarioColetadosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const InventarioTabPlaceholder(
      icon: Icons.fact_check_outlined,
      titulo: 'Coletados',
    );
  }
}
