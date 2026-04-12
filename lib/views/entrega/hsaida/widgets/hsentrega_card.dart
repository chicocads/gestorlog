import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/data_formatar.dart';
import '../../../../core/utils/numero_formatar.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../models/hsaida/hsaida_model.dart';

class HsEntregaCard extends StatelessWidget {
  const HsEntregaCard({
    super.key,
    required this.hsaida,
    this.onTap,
    this.onConfirmarEntrega,
    this.confirmandoEntrega = false,
  });

  final HSaidaModel hsaida;
  final VoidCallback? onTap;
  final VoidCallback? onConfirmarEntrega;
  final bool confirmandoEntrega;

  bool get _entregue => hsaida.entregue == 1;

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
                height: 80,
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
                          'N\u00ba ${hsaida.idPrevenda}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (_entregue) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.check_circle,
                            size: 24,
                            color: AppColors.success,
                          ),
                        ],
                        const Spacer(),
                        StatusBadge(label: _entregueLabel, color: _statusColor),
                        if (!_entregue && onConfirmarEntrega != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            iconSize: 48,
                            padding: const EdgeInsets.all(16),
                            onPressed: confirmandoEntrega
                                ? null
                                : onConfirmarEntrega,
                            icon: confirmandoEntrega
                                ? const SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Icon(Icons.check_circle_outline, color: AppColors.primary),
                            tooltip: 'Confirmar entrega',
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cliente: ${hsaida.idCliente}'
                      '${hsaida.cliente.nome.isNotEmpty ? ' - ${hsaida.cliente.nome}' : ' - CLIENTE INDEFINIDO'}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rca: ${hsaida.idColabor}'
                      '${hsaida.colaborador.nome.isNotEmpty ? ' - ${hsaida.colaborador.nome.padRight(30).substring(0, 30)}' : ' - RCA INDEFINIDO'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (hsaida.cliente.endereco.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${hsaida.cliente.endereco}'
                        '${hsaida.cliente.bairro.isNotEmpty ? ' - ${hsaida.cliente.bairro.padRight(30).substring(0, 20)}' : ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (hsaida.cliente.cidade.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        '${hsaida.cliente.cidade.padRight(30).substring(0, 20).trim()}'
                        '${hsaida.cliente.uf.isNotEmpty ? '/${hsaida.cliente.uf}' : ''}'
                        '${hsaida.cliente.fone.isNotEmpty ? ' - Fone: ${hsaida.cliente.fone}' : ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (hsaida.cliente.refEntrega.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        'Ref: ${hsaida.cliente.refEntrega}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          DataFormatar.formatDate(DateTime.parse(hsaida.data)),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (hsaida.entregue == 1) ...[
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
                            DataFormatar.formatEntrega(hsaida.dtEntrega),
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
                          NumeroFormatar.moeda(
                            hsaida.vnota.toString(),
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
