import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/prevenda/prevenda_model.dart';

class PvSeparacaoCard extends StatelessWidget {
  const PvSeparacaoCard({super.key, required this.prevenda, this.onTap});

  final PreVendaModel prevenda;
  final VoidCallback? onTap;

  bool get _temRomaneio => prevenda.romaneio == 1;

  Color get _statusColor => switch (prevenda.status) {
    StatusPV.orcamento => AppColors.warning,
    StatusPV.confirmado => AppColors.success,
    StatusPV.fechado => AppColors.primary,
    StatusPV.cancelado => AppColors.error,
  };

  String get _statusLabel => switch (prevenda.status) {
    StatusPV.orcamento => 'Orçamento',
    StatusPV.confirmado => 'Confirmado',
    StatusPV.fechado => 'Fechado',
    StatusPV.cancelado => 'Cancelado',
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: _temRomaneio ? const Color(0xFFE0F2F1) : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Indicador de status
              Container(
                width: 4,
                height: 52,
                decoration: BoxDecoration(
                  color: _statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),

              // Informações principais
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Nº ${prevenda.idPrevenda}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        StatusBadge(label: _statusLabel, color: _statusColor),
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
