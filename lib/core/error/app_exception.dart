/// Uygulama genelinde HTTP veya iş kuralı hatalarını temsil etmek için kullanılan özel bir exception sınıfıdır.
///
/// Bu sınıf, kullanıcıya gösterilecek anlamlı bir mesaj ve isteğe bağlı bir HTTP durum kodu taşır.
/// Böylece uygulama genelinde tutarlı ve merkezi bir hata yönetimi sağlanabilir.
class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}