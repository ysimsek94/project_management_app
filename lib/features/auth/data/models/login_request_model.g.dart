// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestModel _$LoginRequestModelFromJson(Map<String, dynamic> json) =>
    LoginRequestModel(
      tcKimlikNo: json['tcKimlikNo'] as String,
      password: json['password'] as String,
      serviceUserName: json['serviceUserName'] as String,
      servicePassword: json['servicePassword'] as String,
    );

Map<String, dynamic> _$LoginRequestModelToJson(LoginRequestModel instance) =>
    <String, dynamic>{
      'tcKimlikNo': instance.tcKimlikNo,
      'password': instance.password,
      'serviceUserName': instance.serviceUserName,
      'servicePassword': instance.servicePassword,
    };
