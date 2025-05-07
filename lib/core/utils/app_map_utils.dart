

import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';

/// Bu yardımcı sınıf, harita tabanlı işlemleri merkezi bir yerden yürütmek için kullanılır.
/// Şu an için, belirtilen konumu varsayılan harita uygulamasında açmayı destekler.
class MapUtils {
  /// Verilen [point] koordinatlarını Google Haritalar'da açar.
  /// Kullanıcının cihazında yüklü bir harita uygulaması olması gerekir.
  ///
  /// [point] : Gösterilecek konumun enlem ve boylam bilgilerini içerir.
  /// Hata durumunda bir istisna fırlatır.
  static Future<void> openInMaps(LatLng point) async {
    // Google Maps arama URL'si oluşturuluyor.
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${point.latitude},${point.longitude}');
    // URL'nin açılabilir olup olmadığını kontrol et.
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // URL açılamazsa hata fırlat.
      throw 'Harita açılamadı: $url';
    }
  }
}