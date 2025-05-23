import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}

@JsonSerializable()
class LoginResponseModel {
  final String token;
  final String username;
  final String adSoyad;
  /// Kullanıcının sahip olduğu roller
  final List<String> roles;

  LoginResponseModel({required this.token, required this.username,required this.adSoyad, required this.roles});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  /// JSON sıralamasını sağlar
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}