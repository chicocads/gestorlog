import 'package:flutter/material.dart';

import 'tabs/inventario_coleta_tab.dart';
import 'tabs/inventario_coletados_tab.dart';
import 'tabs/inventario_produtos_tab.dart';
import 'tabs/inventario_total_tab.dart';

class InventarioView extends StatefulWidget {
  const InventarioView({super.key});

  @override
  State<InventarioView> createState() => _InventarioViewState();
}

class _InventarioViewState extends State<InventarioView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _produtosTabKey = GlobalKey<InventarioProdutosTabState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChanged)
      ..dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _baixarProdutosNoAppBar() async {
    await _produtosTabKey.currentState?.baixarProdutos();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final mostrandoAcaoProdutos = _tabController.index == 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conferência de Inventário'),
        elevation: 1,
        actions: [
          if (mostrandoAcaoProdutos)
            IconButton(
              onPressed: _produtosTabKey.currentState?.sincronizando == true
                  ? null
                  : _baixarProdutosNoAppBar,
              tooltip: 'Baixar produtos',
              icon: _produtosTabKey.currentState?.sincronizando == true
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download_outlined),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Produtos', icon: Icon(Icons.inventory_2_outlined)),
            Tab(text: 'Coleta', icon: Icon(Icons.qr_code_scanner_outlined)),
            Tab(text: 'Coletados', icon: Icon(Icons.fact_check_outlined)),
            Tab(text: 'Total', icon: Icon(Icons.calculate_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InventarioProdutosTab(key: _produtosTabKey),
          const InventarioColetaTab(),
          const InventarioColetadosTab(),
          const InventarioTotalTab(),
        ],
      ),
    );
  }
}
