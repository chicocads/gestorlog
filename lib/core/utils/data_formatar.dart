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

    if (v.length < 19) return raw;
    if (v.codeUnitAt(4) != 45) return raw;
    if (v.codeUnitAt(7) != 45) return raw;
    if (v.codeUnitAt(10) != 84) return raw;
    if (v.codeUnitAt(13) != 58) return raw;
    if (v.codeUnitAt(16) != 58) return raw;

    final y = v.substring(0, 4);
    final mo = v.substring(5, 7);
    final d = v.substring(8, 10);
    final h = v.substring(11, 13);
    final mi = v.substring(14, 16);
    final s = v.substring(17, 19);
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
    if (parts[2].length != 4) return null;
    if (y < 1900 || m < 1 || m > 12 || d < 1 || d > 31) return null;
    final dt = DateTime(y, m, d);
    if (dt.year != y || dt.month != m || dt.day != d) return null;
    return dt;
  }

  static DateTime? parseDdMmYyOrYyyy(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final rawY = parts[2].trim();
    final yParsed = int.tryParse(rawY);
    if (d == null || m == null || yParsed == null) return null;

    final int y;
    if (rawY.length == 2) {
      y = 2000 + yParsed;
    } else if (rawY.length == 4) {
      y = yParsed;
    } else {
      return null;
    }

    if (y < 1900 || m < 1 || m > 12 || d < 1 || d > 31) return null;
    final dt = DateTime(y, m, d);
    if (dt.year != y || dt.month != m || dt.day != d) return null;
    return dt;
  }

  static String toIsoDateFromDdMmYyyy(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '';
    final dt = parseDdMmYyOrYyyy(v);
    if (dt == null) return v;
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String formatDateShort(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = (date.year % 100).toString().padLeft(2, '0');
    return '$d/$m/$y';
  }

  static String toIsoDate(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '';

    if (v.contains('/')) {
      return toIsoDateFromDdMmYyyy(v);
    }

    final dt = DateTime.tryParse(v);
    if (dt != null) {
      return dt.toIso8601String().substring(0, 10);
    }

    if (v.length >= 10 && v.codeUnitAt(4) == 45 && v.codeUnitAt(7) == 45) {
      return v.substring(0, 10);
    }

    return v;
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
