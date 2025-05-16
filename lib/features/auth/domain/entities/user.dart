import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final String token;
  final String adSoyad;
  final List<String> roles;

  const User({
    required this.username,
    required this.adSoyad,
    required this.roles,
    required this.token,
  });

  @override
  List<Object?> get props => [username, token, adSoyad, roles];
}