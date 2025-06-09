import 'package:json_annotation/json_annotation.dart';

part 'proje_adet_model.g.dart';

@JsonSerializable()
class ProjeAdetModel {
  @JsonKey(defaultValue: '')
  final String departmanAdi;

  @JsonKey(defaultValue: '')
  final String durumAdi;

  final int? adet;

  ProjeAdetModel({
    required this.departmanAdi,
    required this.durumAdi,
    this.adet,
  });

  factory ProjeAdetModel.fromJson(Map<String, dynamic> json) =>
      _$ProjeAdetModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjeAdetModelToJson(this);
}