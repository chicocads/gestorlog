class DateFormatter {
  DateFormatter._();

  static String format(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year;
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }

  static String formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  /// Formata como "20260403" (yyyyMMdd)
  static String toYmd(DateTime date) {
    final y = date.year.toString();
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y$m$d';
  }

  static String _offsetString(DateTime date) {
    final offset = date.timeZoneOffset;
    final h = offset.inHours.abs().toString().padLeft(2, '0');
    final min = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final sign = offset.isNegative ? '-' : '+';
    return '$sign$h$min';
  }

  /// Formata como "2026-03-01T00:00:00.000-0700"
  static String toIsoWithOffset(DateTime date) {
    final y = date.year;
    final mo = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final h = date.hour.toString().padLeft(2, '0');
    final mi = date.minute.toString().padLeft(2, '0');
    final s = date.second.toString().padLeft(2, '0');
    final ms = date.millisecond.toString().padLeft(3, '0');
    return ('$y-$mo-${d}T$h:$mi:$s.$ms${_offsetString(date)}').replaceAll(
      "+0000",
      "-0700",
    );
  }

  /// Início do dia: "2026-03-01T00:00:00.000-0700"
  static String startOfDayIso(DateTime date) =>
      toIsoWithOffset(DateTime(date.year, date.month, date.day, 0, 0, 0, 0));

  /// Fim do dia: "2026-03-17T23:59:59.000-0700"
  static String endOfDayIso(DateTime date) =>
      toIsoWithOffset(DateTime(date.year, date.month, date.day, 23, 59, 59, 0));
}
