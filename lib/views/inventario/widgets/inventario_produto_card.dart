import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/info_row.dart';
import '../../../models/cadastro/produto_model.dart';

class InventarioProdutoCard extends StatelessWidget {
  const InventarioProdutoCard({
    super.key,
    required this.produto,
    this.onTap,
  });

  final ProdutoModel produto;
  final VoidCallback? onTap;

  bool get _temWms => produto.wmsrua > 0;

  String get _wmsFormatado {
    final partes = <String>[
      if (produto.wmsrua != 0) 'Rua: ${produto.wmsrua}',
      if (produto.wmsblc != 0) 'Blc: ${produto.wmsblc}',
      if (produto.wmsmod != 0) 'Mod: ${produto.wmsmod}',
      if (produto.wmsniv != 0) 'Niv: ${produto.wmsniv}',
      if (produto.wmsapt != 0) 'Apt: ${produto.wmsapt}',
      if (produto.wmsgvt != 0) 'Gvt: ${produto.wmsgvt}',
    ];
    return partes.join(' | ');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                produto.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              InfoRow(
                label: 'EAN',
                value: produto.codigoalfa.isNotEmpty
                    ? produto.codigoalfa
                    : 'Não informado',
              ),
              InfoRow(
                label: 'DUN14',
                value: produto.dun14.isNotEmpty ? produto.dun14 : 'Não informado',
              ),
              InfoRow(
                label: 'Marca',
                value: produto.marca.isNotEmpty ? produto.marca : 'Não informada',
              ),
              InfoRow(
                label: 'Local',
                value: _temWms
                    ? _wmsFormatado
                    : (produto.localizacao.trim().isNotEmpty
                          ? produto.localizacao
                          : 'Não informado'),
              ),
              InfoRow(
                label: 'Seção',
                value: '${produto.secao}/${produto.grupo}/${produto.sgrupo}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
