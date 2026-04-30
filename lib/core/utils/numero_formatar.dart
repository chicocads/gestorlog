import 'package:intl/intl.dart';

class NumeroFormatar {
  NumeroFormatar._();

  static double? tryParse(String raw) {
    var v = raw.trim();
    if (v.isEmpty) return null;
    v = v.replaceAll(' ', '');

    if (v.contains(',')) {
      final normalized = v.replaceAll('.', '').replaceAll(',', '.');
      return double.tryParse(normalized);
    }

    if (v.contains('.')) {
      final parts = v.split('.');
      if (parts.length >= 2) {
        final firstOk = parts.first.isNotEmpty && parts.first.length <= 3;
        final groupsOk =
            parts.skip(1).every((p) => p.isNotEmpty && p.length == 3);
        if (firstOk && groupsOk) {
          return double.tryParse(parts.join());
        }
      }
    }

    return double.tryParse(v);
  }

  static double parseOrZero(String raw) => tryParse(raw) ?? 0.0;

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
