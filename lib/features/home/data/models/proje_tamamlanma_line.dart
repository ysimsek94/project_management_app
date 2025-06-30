

import 'package:json_annotation/json_annotation.dart';

part 'proje_tamamlanma_line.g.dart';

@JsonSerializable()
class ProjeTamamlanmaLine {
  final int departmanId;
  final String departmanAdi;
  final String? projeAdi;
  final String? kategoriAdi;
  final double toplamProjeTutari;
  final double gerceklesenNakdiYuzde;
  final double gerceklesenFizikiYuzde;

  ProjeTamamlanmaLine({
    required this.departmanId,
    required this.departmanAdi,
    this.projeAdi,
    this.kategoriAdi,
    required this.toplamProjeTutari,
    required this.gerceklesenNakdiYuzde,
    required this.gerceklesenFizikiYuzde,
  });

  factory ProjeTamamlanmaLine.fromJson(Map<String, dynamic> json) =>
      _$ProjeTamamlanmaLineFromJson(json);

  Map<String, dynamic> toJson() => _$ProjeTamamlanmaLineToJson(this);
}