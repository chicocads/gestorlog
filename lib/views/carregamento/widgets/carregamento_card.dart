import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/carregamento/carregamento_model.dart';

class CarregamentoCard extends StatelessWidget {
  const CarregamentoCard({super.key, required this.carregamento, this.onTap});

  final CarregamentoModel carregamento;
  final VoidCallback? onTap;

  Color get _statusColor => switch (carregamento.status) {
    StatusCarregamento.aberto => AppColors.warning,
    StatusCarregamento.fechado => AppColors.success,
    StatusCarregamento.encerrado => AppColors.primary,
  };

  String get _statusLabel => switch (carregamento.status) {
    StatusCarregamento.aberto => 'Aberto',
    StatusCarregamento.fechado => 'Fechado',
    StatusCarregamento.encerrado => 'Encerrado',
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          'Nº ${carregamento.numero}',
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
                      'Motorista: ${carregamento.motorista.isNotEmpty ? carregamento.motorista : 'NÃO INFORMADO'}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Frota: ${carregamento.frota}'
                      '${carregamento.placa.isNotEmpty ? '  •  Placa: ${carregamento.placa}' : ''}',
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
                          DateFormatter.formatDate(
                            DateTime.parse(carregamento.data),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'R\$ ${carregamento.vTotal.toStringAsFixed(2)}',
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
