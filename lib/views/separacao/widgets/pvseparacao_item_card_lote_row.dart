part of 'pvseparacao_item_card.dart';

class _LoteRow {
  _LoteRow({
    required this.loteController,
    required this.validadeController,
    required this.qtdeController,
    required this.originalLote,
    required this.originalValidade,
  });

  factory _LoteRow.fromModel({
    required LoteSaidaModel model,
    required int decQtde,
  }) {
    final qtde = model.qtde.toStringAsFixed(
      model.qtde.truncateToDouble() == model.qtde ? 0 : decQtde,
    );
    final validadeRaw = model.validade.trim();
    final validadeText = validadeRaw.isEmpty
        ? ''
        : validadeRaw.contains('/')
            ? validadeRaw
            : () {
                try {
                  return DataFormatar.formatDate(DateTime.parse(validadeRaw));
                } catch (_) {
                  return validadeRaw;
                }
              }();
    return _LoteRow(
      loteController: TextEditingController(text: model.lote),
      validadeController: TextEditingController(text: validadeText),
      qtdeController: TextEditingController(text: qtde.replaceAll('.', ',')),
      originalLote: model.lote,
      originalValidade: model.validade,
    );
  }

  factory _LoteRow.empty() {
    return _LoteRow(
      loteController: TextEditingController(),
      validadeController: TextEditingController(),
      qtdeController: TextEditingController(),
      originalLote: '',
      originalValidade: '',
    );
  }

  final TextEditingController loteController;
  final TextEditingController validadeController;
  final TextEditingController qtdeController;
  final String originalLote;
  final String originalValidade;

  _LoteRow copyWithSavedKey({required String lote, required String validade}) {
    return _LoteRow(
      loteController: loteController,
      validadeController: validadeController,
      qtdeController: qtdeController,
      originalLote: lote,
      originalValidade: validade,
    );
  }
}

