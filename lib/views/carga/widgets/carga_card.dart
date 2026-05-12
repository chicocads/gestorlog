import 'package:flutter/material.dart';
import 'package:gestorlog/core/utils/numero_formatar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/data_formatar.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/carga/carga_model.dart';

class CargaCard extends StatelessWidget {
  const CargaCard({
    super.key,
    required this.carregamento,
    this.onTap,
    this.onLancamentoDespesa,
    this.onVerDespesas,
    this.isLancandoDespesa = false,
  });

  final CargaModel carregamento;
  final VoidCallback? onTap;
  final VoidCallback? onLancamentoDespesa;
  final VoidCallback? onVerDespesas;
  final bool isLancandoDespesa;

  Color get _statusColor => switch (carregamento.status) {
    StatusCarregamento.aberto => AppColors.warning,
    StatusCarregamento.fechado => AppColors.success,
    StatusCarregamento.entregando => AppColors.entrega,
    StatusCarregamento.encerrado => AppColors.primary,
  };

  String get _statusLabel => switch (carregamento.status) {
    StatusCarregamento.aberto => 'Aberto',
    StatusCarregamento.fechado => 'Fechado',
    StatusCarregamento.entregando => 'Entregando',
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
                          'Nº ${carregamento.idCarga}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        if (onLancamentoDespesa != null) ...[
                          IconButton(
                            onPressed:
                                isLancandoDespesa ? null : onLancamentoDespesa,
                            icon: isLancandoDespesa
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.attach_money_outlined),
                            tooltip: 'Lançar despesa',
                          ),
                          if (onVerDespesas != null) ...[
                            const SizedBox(width: 2),
                            IconButton(
                              onPressed: onVerDespesas,
                              icon: const Icon(Icons.receipt_long_outlined),
                              tooltip: 'Ver despesas',
                            ),
                          ],
                          const SizedBox(width: 6),
                        ],
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
                          DataFormatar.formatDate(
                            DateTime.parse(carregamento.data),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          NumeroFormatar.moeda(
                            carregamento.vTotal.toString(),
                            simbolo: 'R\$',
                          ),
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
