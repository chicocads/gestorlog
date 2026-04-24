class StringSanitizer {
  StringSanitizer._();

  static bool isDigits(String value) {
    if (value.isEmpty) return false;
    for (final unit in value.codeUnits) {
      if (unit < 48 || unit > 57) return false;
    }
    return true;
  }

  static String digitsOnly(String value) {
    if (value.isEmpty) return '';
    final b = StringBuffer();
    for (final unit in value.codeUnits) {
      if (unit >= 48 && unit <= 57) b.writeCharCode(unit);
    }
    return b.toString();
  }

  static bool isValidEan13(String value) => isValidGtin(value, length: 13);

  static bool isValidEan(String value) {
    final digits = digitsOnly(value.trim());
    if (digits.length != 13 && digits.length != 14) return false;
    return isValidGtin(digits, length: digits.length);
  }

  static bool isValidDun14(String value) => isValidGtin(value, length: 14);

  static bool isValidGtin(
    String value, {
    required int length,
  }) {
    final digits = digitsOnly(value.trim());
    if (digits.length != length) return false;
    if (!isDigits(digits)) return false;

    var sum = 0;
    for (var i = 0; i < length - 1; i++) {
      final index = length - 2 - i;
      final digit = digits.codeUnitAt(index) - 48;
      final weight = i.isEven ? 3 : 1;
      sum += digit * weight;
    }

    final expected = (10 - (sum % 10)) % 10;
    final actual = digits.codeUnitAt(length - 1) - 48;
    return expected == actual;
  }
}
