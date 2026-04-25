import '../../models/hsaida/lote_saida_model.dart';
import '../../models/prevenda/prevenda2_model.dart';

List<LoteSaidaModel> mergeLotesForItem({
  required PreVenda2Model item,
  required int idFilial,
  required int idPrevenda,
  required List<LoteSaidaModel> localLotes,
}) {
  final allowZeroQtde = item.produto.controlelote == 1;
  final apiLotes = item.lotesaida.isNotEmpty
      ? item.lotesaida
            .map(
              (e) => e.copyWith(
                idFilial: idFilial,
                idPrevenda: idPrevenda,
                idProduto: item.idProduto,
              ),
            )
            .where(
              (e) =>
                  e.lote.trim().isNotEmpty &&
                  (allowZeroQtde ? e.qtde >= 0 : e.qtde > 0),
            )
            .toList()
      : (item.lote.trim().isNotEmpty || item.validade.trim().isNotEmpty) &&
            (allowZeroQtde || item.qtdesep > 0)
      ? [
          LoteSaidaModel(
            idFilial: idFilial,
            idPrevenda: idPrevenda,
            idProduto: item.idProduto,
            lote: item.lote,
            validade: item.validade,
            fabricacao: DateTime.now()
                .subtract(const Duration(days: 365))
                .toIso8601String()
                .substring(0, 10),
            qtde: item.qtde,
          ),
        ]
      : const <LoteSaidaModel>[];

  final mergedMap = <String, LoteSaidaModel>{
    for (final l in apiLotes) '${l.lote}__${l.validade}': l,
    for (final l in localLotes.where(
      (e) => e.lote.trim().isNotEmpty && e.qtde > 0,
    ))
      '${l.lote}__${l.validade}': l,
  };
  return mergedMap.values.toList()..removeWhere(
    (e) =>
        e.lote.trim().isEmpty || e.qtde < 0 || (!allowZeroQtde && e.qtde <= 0),
  );
}

double sumQtdeLotes(List<LoteSaidaModel> lotes) =>
    lotes.fold(0.0, (sum, l) => sum + l.qtde);

int scaleByDecimals(double value, int decQtde) {
  var factor = 1;
  for (var i = 0; i < decQtde; i++) {
    factor *= 10;
  }
  return (value * factor).round();
}
