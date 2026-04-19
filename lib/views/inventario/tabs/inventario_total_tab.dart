import 'package:flutter/material.dart';

import '../widgets/inventario_tab_placeholder.dart';

class InventarioTotalTab extends StatelessWidget {
  const InventarioTotalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const InventarioTabPlaceholder(
      icon: Icons.calculate_outlined,
      titulo: 'Total',
    );
  }
}
