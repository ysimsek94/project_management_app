import 'package:intl/intl.dart';
extension DateTimeExtension on DateTime {
  String get monthName {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return months[this.month - 1];
  }
}

extension DateFormatting on DateTime {
  String get dMy =>
      "${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-${year.toString().padLeft(4, '0')}";

  String get yMd =>
      "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

  /// Saat ve dakikayı "HH:mm" formatında döner
  String get hm => DateFormat('HH:mm').format(this);
}

extension StringToDateExtension on String {
  /// "dd-MM-yyyy" formatındaki string'i DateTime'a dönüştürür.
  /// Hatalıysa epoch (1970) döner veya null döner.
  DateTime? toDate({bool returnEpochIfInvalid = true}) {
    try {
      final parts = split('-');
      if (parts.length != 3) {
        if (returnEpochIfInvalid) return DateTime(0);
        return null;
      }

      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (day == null || month == null || year == null) {
        if (returnEpochIfInvalid) return DateTime(0);
        return null;
      }

      return DateTime(year, month, day);
    } catch (_) {
      if (returnEpochIfInvalid) return DateTime(0);
      return null;
    }
  }

  /// Geçersizse boş string döner, geçerliyse ISO8601 formatında döner
  String get toIsoOrEmpty {
    try {
      return toDate(returnEpochIfInvalid: false)?.toIso8601String() ?? '';
    } catch (_) {
      return '';
    }
  }

  /// Geçersizse boş string döner
  String get toDateOrEmpty {
    try {
      final date = toDate(returnEpochIfInvalid: false);
      return date?.dMy ?? '';
    } catch (_) {
      return '';
    }
  }
}