import 'package:flutter/material.dart';

import 'tabs/inventario_coleta_tab.dart';
import 'tabs/inventario_coletados_tab.dart';
import 'tabs/inventario_produtos_tab.dart';
import 'tabs/inventario_total_tab.dart';

class InventarioView extends StatelessWidget {
  const InventarioView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Conferência de Inventário'),
          elevation: 1,
          bottom: const TabBar(
            isScrollable: false,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Produtos', icon: Icon(Icons.inventory_2_outlined)),
              Tab(text: 'Coleta', icon: Icon(Icons.qr_code_scanner_outlined)),
              Tab(text: 'Coletados', icon: Icon(Icons.fact_check_outlined)),
              Tab(text: 'Total', icon: Icon(Icons.calculate_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const InventarioProdutosTab(),
            const InventarioColetaTab(),
            const InventarioColetadosTab(),
            const InventarioTotalTab(),
          ],
        ),
      ),
    );
  }
}
