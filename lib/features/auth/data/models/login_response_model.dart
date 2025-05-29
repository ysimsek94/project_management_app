// login_response_model.dart
import 'package:json_annotation/json_annotation.dart';
part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final String token;
  final String username;
  final List<String> rolList;
  final int kullaniciId;
  final String tcKimlikNo;

  LoginResponseModel({
    required this.token,
    required this.username,
    required this.rolList,
    required this.kullaniciId,
    required this.tcKimlikNo,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}