class DataFormatar {
  DataFormatar._();

  static String format(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year;
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }

  static String formatEntrega(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '';
    if (v.contains('/')) return v;

    final match = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})',
    ).firstMatch(v);
    if (match == null) return raw;

    final y = match.group(1)!;
    final mo = match.group(2)!;
    final d = match.group(3)!;
    final h = match.group(4)!;
    final mi = match.group(5)!;
    final s = match.group(6)!;
    return '$d/$mo/$y $h:$mi:$s';
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

  static DateTime? parseDdMmYyyy(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    if (y < 1 || m < 1 || m > 12 || d < 1 || d > 31) return null;
    final dt = DateTime(y, m, d);
    if (dt.year != y || dt.month != m || dt.day != d) return null;
    return dt;
  }

  static String toIsoDateFromDdMmYyyy(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '';
    final dt = parseDdMmYyyy(v);
    if (dt == null) return v;
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
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

  static String toIsoWithFixedOffset(DateTime date, {required String offset}) {
    final y = date.year.toString().padLeft(4, '0');
    final mo = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final h = date.hour.toString().padLeft(2, '0');
    final mi = date.minute.toString().padLeft(2, '0');
    final s = date.second.toString().padLeft(2, '0');
    final ms = date.millisecond.toString().padLeft(3, '0');
    return '$y-$mo-${d}T$h:$mi:$s.$ms$offset';
  }

  /// Formata como "2026-04-11T00:00:00" (yyyy-MM-ddT00:00:00)
  static String toIsoMidnight(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-${d}T00:00:00';
  }

  /// Início do dia: "2026-03-01T00:00:00.000-0700"
  static String startOfDayIso(DateTime date) =>
      toIsoWithOffset(DateTime(date.year, date.month, date.day, 0, 0, 0, 0));

  /// Fim do dia: "2026-03-17T23:59:59.000-0700"
  static String endOfDayIso(DateTime date) =>
      toIsoWithOffset(DateTime(date.year, date.month, date.day, 23, 59, 59, 0));
}
