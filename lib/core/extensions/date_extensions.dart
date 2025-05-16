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
  String get yMd =>
      "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

  /// Saat ve dakikayı "HH:mm" formatında döner
  String get hm => DateFormat('HH:mm').format(this);
}