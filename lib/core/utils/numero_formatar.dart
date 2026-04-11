import 'package:intl/intl.dart';

class NumeroFormatar {
  NumeroFormatar._();

  static String moeda(String? value, {String simbolo = ''}) {
    if (value!.isEmpty) {
      return '0,00';
    } else {
      //'R\$'
      NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: 'pt_BR',
        name: simbolo,
      );
      double valor = double.parse(value);
      return formatter.format(valor).toString().trim();
    }
  }

  static String numero(String? value, int casas) {
    if (value!.isEmpty) {
      return '0,00';
    } else {
      double? valor = double.parse(value);
      int? valor2 = valor.toInt();
      late NumberFormat formatter;
      if (casas == 0) {
        if ((valor - valor2.toDouble()) == 0) {
          formatter = NumberFormat('0');
        }
      } else {
        String dec = '0.'.padRight((casas + 2), '0');
        formatter = NumberFormat(dec);
      }
      return formatter.format(valor).toString().trim().replaceAll('.', ',');
    }
  }

  static String qtde(double value, {required int decQtde}) {
    final hasDecimals = value.truncateToDouble() != value;
    return numero(value.toString(), hasDecimals ? decQtde : 0);
  }
}
