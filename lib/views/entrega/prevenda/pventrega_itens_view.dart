import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/prevenda/prevenda_model.dart';
import '../widgets/entrega_resumo_card.dart';
import 'widgets/pventrega_item_card.dart';

class PvEntregaItensView extends StatelessWidget {
  const PvEntregaItensView({super.key, required this.prevenda});

  final PreVendaModel prevenda;

  bool get _entregue => prevenda.entregue == 1;

  @override
  Widget build(BuildContext context) {
    final itens = prevenda.itens;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PV Nº ${prevenda.idPrevenda}'),
            Text(
              prevenda.cliente.nome.isNotEmpty
                  ? prevenda.cliente.nome
                  : 'Cliente ${prevenda.idCliente}',
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
            carregamento: prevenda.carregamento,
            rcaId: prevenda.idColabor,
            rcaNome: prevenda.colaborador.nome,
            data: prevenda.data,
            dtEntrega: prevenda.dtEntrega,
            valor: prevenda.valor,
            itensCount: prevenda.itens.length,
            volume: prevenda.volume,
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      return PvEntregaItemCard(item: itens[i]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
