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
}
