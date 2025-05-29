// login_request_model.dart
import 'package:json_annotation/json_annotation.dart';
part 'login_request_model.g.dart';

@JsonSerializable()
class LoginRequestModel {
  final String tcKimlikNo;
  final String password;
  final String serviceUserName;
  final String servicePassword;

  LoginRequestModel({
    required this.tcKimlikNo,
    required this.password,
    required this.serviceUserName,
    required this.servicePassword,
  });

  Map<String, dynamic> toJson() => {
    'tcKimlikNo': tcKimlikNo,
    'password': password,
    'serviceUserName': serviceUserName,
    'servicePassword': servicePassword,
  };
}