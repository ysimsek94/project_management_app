import 'package:json_annotation/json_annotation.dart';
import 'package:project_management_app/features/map/data/models/proje_model.dart';

part 'proje_line_model.g.dart';

@JsonSerializable()
class ProjeLineModel {
  final ProjeModel proje;
  final String firmaAdi;
  final String durumu;
  final String? faliyetTuru;
  final String projeKategori;
  final String? projeAltKategori;
  final String departmanAdi;
  final String paraBirimi;
  final double? nakdiYuzde;
  final double? fizikiYuzde;

  ProjeLineModel({
    required this.proje,
    required this.firmaAdi,
    required this.durumu,
    this.faliyetTuru,
    required this.projeKategori,
    this.projeAltKategori,
    required this.departmanAdi,
    required this.paraBirimi,
    this.nakdiYuzde,
    this.fizikiYuzde,
  });

  factory ProjeLineModel.fromJson(Map<String, dynamic> json) =>
      _$ProjeLineModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjeLineModelToJson(this);
}
