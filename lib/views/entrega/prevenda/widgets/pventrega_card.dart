import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../models/prevenda/prevenda_model.dart';

class PvEntregaCard extends StatelessWidget {
  const PvEntregaCard({super.key, required this.prevenda, this.onTap});

  final PreVendaModel prevenda;
  final VoidCallback? onTap;

  bool get _entregue => prevenda.entregue == 1;

  Color get _statusColor => _entregue ? AppColors.success : AppColors.warning;

  String get _entregueLabel => _entregue ? 'Entregue' : 'Pendente';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: _entregue ? const Color(0xFFE8F5E9) : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 52,
                decoration: BoxDecoration(
                  color: _statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'N\u00ba ${prevenda.idPrevenda}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (_entregue) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColors.success,
                          ),
                        ],
                        const Spacer(),
                        StatusBadge(label: _entregueLabel, color: _statusColor),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cliente: ${prevenda.idCliente}'
                      '${prevenda.cliente.nome.isNotEmpty ? ' - ${prevenda.cliente.nome}' : ' - CLIENTE INDEFINIDO'}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rca: ${prevenda.idColabor}'
                      '${prevenda.colaborador.nome.isNotEmpty ? ' - ${prevenda.colaborador.nome}' : ' - RCA INDEFINIDO'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          prevenda.data,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (prevenda.dtEntrega.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 14,
                            color: _entregue
                                ? AppColors.success
                                : AppColors.entrega,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            prevenda.dtEntrega,
                            style: TextStyle(
                              fontSize: 12,
                              color: _entregue
                                  ? AppColors.textSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          'R\$ ${prevenda.valor.toStringAsFixed(2)}',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
