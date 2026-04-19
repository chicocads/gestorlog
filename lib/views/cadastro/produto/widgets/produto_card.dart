import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/numero_formatar.dart';
import '../../../../core/widgets/info_row.dart';
import '../../../../models/cadastro/produto_model.dart';

class ProdutoCard extends StatelessWidget {
  const ProdutoCard({
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
    final saldo = NumeroFormatar.qtde(produto.saldo, decQtde: 2);
    final preco = NumeroFormatar.moeda(produto.precovenda.toString());

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
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
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InfoRow(
                label: 'EAN',
                value: produto.codigoalfa.isNotEmpty ? produto.codigoalfa : 'Não informado',
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
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.scale_outlined,
                      label: 'Saldo',
                      value: '$saldo ${produto.undvenda}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.attach_money_outlined,
                      label: 'Preço',
                      value: preco,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
