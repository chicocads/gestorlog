import 'package:flutter/material.dart';

import '../widgets/inventario_tab_placeholder.dart';

class InventarioColetaTab extends StatelessWidget {
  const InventarioColetaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const InventarioTabPlaceholder(
      icon: Icons.qr_code_scanner_outlined,
      titulo: 'Coleta',
    );
  }
}
