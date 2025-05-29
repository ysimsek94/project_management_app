// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) =>
    LoginResponseModel(
      token: json['token'] as String,
      username: json['username'] as String,
      rolList:
          (json['rolList'] as List<dynamic>).map((e) => e as String).toList(),
      kullaniciId: (json['kullaniciId'] as num).toInt(),
      tcKimlikNo: json['tcKimlikNo'] as String,
    );

Map<String, dynamic> _$LoginResponseModelToJson(LoginResponseModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'username': instance.username,
      'rolList': instance.rolList,
      'kullaniciId': instance.kullaniciId,
      'tcKimlikNo': instance.tcKimlikNo,
    };
