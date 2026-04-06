import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/status_badge.dart';

class EntregaResumoCard extends StatelessWidget {
  const EntregaResumoCard({
    super.key,
    required this.entregue,
    required this.carregamento,
    required this.rcaId,
    required this.rcaNome,
    required this.data,
    required this.dtEntrega,
    required this.valor,
    required this.itensCount,
    required this.volume,
  });

  final bool entregue;
  final int carregamento;
  final int rcaId;
  final String rcaNome;
  final String data;
  final String dtEntrega;
  final double valor;
  final int itensCount;
  final int volume;

  @override
  Widget build(BuildContext context) {
    final entregaColor = entregue ? AppColors.success : AppColors.entrega;
    final rcaDescricao = rcaNome.isNotEmpty ? ' - $rcaNome' : '';

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: entregue ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: entregaColor, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                entregue ? Icons.check_circle : Icons.local_shipping_outlined,
                color: entregaColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Carregamento: $carregamento',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              StatusBadge(
                label: entregue ? 'Entregue' : 'Pendente',
                color: entregue ? AppColors.success : AppColors.warning,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Rca: $rcaId$rcaDescricao',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Data: $data',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              if (entregue) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.local_shipping_outlined,
                  size: 14,
                  color: entregaColor,
                ),
                const SizedBox(width: 2),
                Text(
                  dtEntrega,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '$itensCount itens',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              if (volume > 0) ...[
                const SizedBox(width: 12),
                Text(
                  '$volume volumes',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const Spacer(),
              Text(
                'R\$ ${valor.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
