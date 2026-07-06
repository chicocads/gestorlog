import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/cadastro/produto_model.dart';
import '../../../services/cadastro/produto/produto_local_service.dart';

Future<int?> showAuditoriaProdutoSearch(BuildContext context) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => const _ProdutoSearchSheet(),
  );
}

class _ProdutoSearchSheet extends StatefulWidget {
  const _ProdutoSearchSheet();

  @override
  State<_ProdutoSearchSheet> createState() => _ProdutoSearchSheetState();
}

class _ProdutoSearchSheetState extends State<_ProdutoSearchSheet> {
  final _searchCtrl = TextEditingController();
  final _service = ProdutoLocalService();
  List<ProdutoModel> _produtos = [];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _buscar('');
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _buscar(String termo) async {
    setState(() => _carregando = true);
    try {
      final result = await _service.listar(
        termoNome: termo,
        limit: 50,
        offset: 0,
      );
      if (!mounted) return;
      setState(() => _produtos = result);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: TextField(
                controller: _searchCtrl,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                onChanged: _buscar,
                decoration: InputDecoration(
                  labelText: 'Pesquisar por nome',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            _buscar('');
                          },
                        )
                      : null,
                ),
              ),
            ),
            if (_carregando)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_produtos.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'Nenhum produto encontrado.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: _produtos.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final p = _produtos[i];
                    return ListTile(
                      dense: true,
                      title: Text(
                        p.nome,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Cód: ${p.codigo}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, p.codigo),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
