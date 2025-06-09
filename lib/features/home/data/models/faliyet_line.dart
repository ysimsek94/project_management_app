import 'package:json_annotation/json_annotation.dart';

import 'faliyet_model.dart';

part 'faliyet_line.g.dart';

@JsonSerializable(explicitToJson: true)
class FaliyetLine {
  final FaliyetModel faaliyet;

  @JsonKey(defaultValue: '')
  final String durumu;

  @JsonKey(defaultValue: '')
  final String faaliyetTuru;

  @JsonKey(defaultValue: '')
  final String mahalle;

  @JsonKey(defaultValue: '')
  final String projeAdi;

  @JsonKey(defaultValue: '')
  final String departmanAdi;

  FaliyetLine({
    required this.faaliyet,
    required this.durumu,
    required this.faaliyetTuru,
    required this.mahalle,
    required this.projeAdi,
    required this.departmanAdi,
  });

  factory FaliyetLine.fromJson(Map<String, dynamic> json) =>
      _$FaliyetLineFromJson(json);

  Map<String, dynamic> toJson() => _$FaliyetLineToJson(this);
}