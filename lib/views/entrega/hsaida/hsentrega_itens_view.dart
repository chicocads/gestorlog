import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/data_formatar.dart';
import '../../../models/hsaida/hsaida_model.dart';
import '../widgets/entrega_resumo_card.dart';
import 'widgets/hsentrega_item_card.dart';

class HsEntregaItensView extends StatelessWidget {
  const HsEntregaItensView({super.key, required this.hsaida});

  final HSaidaModel hsaida;

  bool get _entregue => hsaida.entregue == 1;

  @override
  Widget build(BuildContext context) {
    final itens = hsaida.dsaidaList;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saída Nº ${hsaida.idPrevenda}'),
            Text(
              hsaida.cliente.nome.isNotEmpty
                  ? hsaida.cliente.nome
                  : 'Cliente ${hsaida.idCliente}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          EntregaResumoCard(
            entregue: _entregue,
            carregamento: hsaida.carregamento,
            rcaId: hsaida.idColabor,
            rcaNome: hsaida.colaborador.nome,
            data: DataFormatar.formatDate(DateTime.parse(hsaida.data)),
            dtEntrega: DataFormatar.format(DateTime.parse(hsaida.dtEntrega)),
            valor: hsaida.vnota,
            itensCount: hsaida.dsaidaList.length,
            volume: hsaida.volume,
          ),
          Expanded(
            child: itens.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum item encontrado.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 60),
                    itemCount: itens.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      return HsEntregaItemCard(item: itens[i]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
