import 'package:flutter/material.dart';

import '../../../models/auditoria/auditoria_model.dart';
import 'auditoria_card.dart';
import 'auditoria_stat.dart';

class AuditoriaResumoCard extends StatelessWidget {
  const AuditoriaResumoCard({
    super.key,
    required this.auditoria,
    required this.hasAuditoria,
    required this.formatQtd,
  });

  final AuditoriaLogisticaModel auditoria;
  final bool hasAuditoria;
  final String Function(double) formatQtd;

  @override
  Widget build(BuildContext context) {
    return AuditoriaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AuditoriaStat(
                  label: 'Und',
                  value: auditoria.undvenda.trim().isNotEmpty
                      ? auditoria.undvenda
                      : '-',
                  labelFontSize: 13,
                  valueFontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AuditoriaStat(
                  label: 'Fator',
                  value: auditoria.fator.toString(),
                  labelFontSize: 13,
                  valueFontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AuditoriaStat(
                  label: 'Emb',
                  value: auditoria.qtembala.toString(),
                  labelFontSize: 13,
                  valueFontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AuditoriaStat(
                  label: 'Saldo',
                  value: hasAuditoria ? formatQtd(auditoria.saldo) : '-',
                  labelFontSize: 13,
                  valueFontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AuditoriaStat(
                  label: 'Reserva',
                  value: hasAuditoria ? formatQtd(auditoria.reserva) : '-',
                  labelFontSize: 13,
                  valueFontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AuditoriaStat(
                  label: 'Qtde Separada',
                  value: hasAuditoria ? formatQtd(auditoria.qtse) : '-',
                  labelFontSize: 13,
                  valueFontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: AuditoriaStat(
                  label: 'Qtde em Carga',
                  value: hasAuditoria ? formatQtd(auditoria.qtcc) : '-',
                  labelFontSize: 13,
                  valueFontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AuditoriaStat(
                  label: 'Qtde sem Carga',
                  value: hasAuditoria ? formatQtd(auditoria.qtsc) : '-',
                  labelFontSize: 13,
                  valueFontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
