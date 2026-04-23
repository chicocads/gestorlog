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

    final commaIndex = text.indexOf(',');
    final dotIndex = text.indexOf('.');
    final int sepIndex;
    if (commaIndex == -1) {
      sepIndex = dotIndex;
    } else if (dotIndex == -1) {
      sepIndex = commaIndex;
    } else {
      sepIndex = commaIndex < dotIndex ? commaIndex : dotIndex;
    }

    if (sepIndex != -1) {
      final rest = text.substring(sepIndex + 1);
      if (rest.contains(',') || rest.contains('.')) {
        return oldValue;
      }
      if (text.length - sepIndex - 1 > maxDecimals) {
        return oldValue;
      }
    }

    return newValue;
  }
}

class DigitsCommaDotInputFormatter extends TextInputFormatter {
  const DigitsCommaDotInputFormatter({this.allowDecimalSeparator = true});

  final bool allowDecimalSeparator;

  bool _isDigit(int codeUnit) => codeUnit >= 48 && codeUnit <= 57;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final selectionEnd = newValue.selection.end;
    final b = StringBuffer();
    var removedBeforeSelection = 0;
    var seenSeparator = false;

    for (var i = 0; i < text.length; i++) {
      final codeUnit = text.codeUnitAt(i);
      if (_isDigit(codeUnit)) {
        b.writeCharCode(codeUnit);
        continue;
      }

      final isSeparator = codeUnit == 44 || codeUnit == 46;
      if (allowDecimalSeparator && isSeparator) {
        if (seenSeparator) {
          if (i < selectionEnd) removedBeforeSelection++;
          continue;
        }
        seenSeparator = true;
        b.write(',');
        continue;
      }

      if (i < selectionEnd) removedBeforeSelection++;
    }

    final filtered = b.toString();
    final newOffset = (selectionEnd - removedBeforeSelection).clamp(
      0,
      filtered.length,
    );

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

class DateDdMmYyyyFormatter extends TextInputFormatter {
  bool _isDigit(int codeUnit) => codeUnit >= 48 && codeUnit <= 57;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text;
    final bDigits = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      final codeUnit = raw.codeUnitAt(i);
      if (_isDigit(codeUnit)) {
        bDigits.writeCharCode(codeUnit);
      }
    }
    final digits = bDigits.toString();
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
