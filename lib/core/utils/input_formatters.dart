import 'package:flutter/services.dart';

class DecimalMaxDigitsFormatter extends TextInputFormatter {
  DecimalMaxDigitsFormatter(this.maxDecimals);

  final int maxDecimals;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final sepIndex = text.indexOf(',');
    if (sepIndex != -1 && text.indexOf(',', sepIndex + 1) > sepIndex) {
      return oldValue;
    }

    if (sepIndex != -1 && text.length - sepIndex - 1 > maxDecimals) {
      return oldValue;
    }

    return newValue;
  }
}

class DateDdMmYyyyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final limited = digits.length > 8 ? digits.substring(0, 8) : digits;
    final b = StringBuffer();
    for (var i = 0; i < limited.length; i++) {
      if (i == 2 || i == 4) b.write('/');
      b.write(limited[i]);
    }
    final text = b.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upper = newValue.text.toUpperCase();
    if (upper == newValue.text) return newValue;
    return newValue.copyWith(text: upper);
  }
}
