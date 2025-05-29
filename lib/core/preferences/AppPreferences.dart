import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences (call this once at app start)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Set token
  static Future<void> setToken(String token) async {
    await _prefs?.setString('token', token);
  }

  static String? get token => _prefs?.getString('token');

  /// Set setKullaniciId
  static Future<void> setKullaniciId(int kullaniciId) async {
    await _prefs?.setInt('kullaniciId', kullaniciId);
  }

  static int? get kullaniciId => _prefs?.getInt('kullaniciId');

  /// Set username
  static Future<void> setUsername(String username) async {
    await _prefs?.setString('username', username);
  }

  static String? get username => _prefs?.getString('username');
  /// Set TcKimlikNo
  static Future<void> setTcKimlikNo(String tcKimlikNo) async {
    await _prefs?.setString('tcKimlikNo', tcKimlikNo);
  }

  static String? get tcKimlikNo => _prefs?.getString('tcKimlikNo');

  /// Set password
  static Future<void> setPassword(String password) async {
    await _prefs?.setString('password', password);
  }

  static String? get password => _prefs?.getString('password');

  /// Remove saved username and password
  static Future<void> removeCredentials() async {
    await _prefs?.remove('tcKimlikNo');
    await _prefs?.remove('password');
  }

  /// Set adSoyad
  static Future<void> setAdSoyad(String adSoyad) async {
    await _prefs?.setString('adSoyad', adSoyad);
  }

  static String? get adSoyad => _prefs?.getString('adSoyad');

  static Future<void> setRoles(List<String> roles) async {
    await _prefs?.setStringList('roles', roles);
  }

  static List<String>? get roles => _prefs?.getStringList('roles');

  /// Clear all saved preferences (for logout)
  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
