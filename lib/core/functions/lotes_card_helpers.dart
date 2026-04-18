import '../../models/diversos/lote_saida_model.dart';

bool sameLotes(List<LoteSaidaModel> a, List<LoteSaidaModel> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  final sa =
      a.map((e) => '${e.idProduto}|${e.lote}|${e.validade}|${e.qtde}').toSet();
  final sb =
      b.map((e) => '${e.idProduto}|${e.lote}|${e.validade}|${e.qtde}').toSet();
  return sa.length == sb.length && sa.containsAll(sb);
}

List<LoteSaidaModel> sortLotes(List<LoteSaidaModel> lotes) {
  final list = [...lotes];
  list.sort((a, b) {
    final c = a.lote.compareTo(b.lote);
    if (c != 0) return c;
    return a.validade.compareTo(b.validade);
  });
  return list;
}

double sumLotesExcept(List<String> values, int exceptIndex) {
  var total = 0.0;
  for (var i = 0; i < values.length; i++) {
    if (i == exceptIndex) continue;
    final v = double.tryParse(values[i].replaceAll(',', '.')) ?? 0.0;
    total += v;
  }
  return total;
}

double chooseMax(double separado, double pedido) =>
    separado > 0 ? separado : pedido;

