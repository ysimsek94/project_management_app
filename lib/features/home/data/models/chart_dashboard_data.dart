import 'package:json_annotation/json_annotation.dart';

part 'chart_dashboard_data.g.dart';

/// Tek bir pie serisi verisi
@JsonSerializable()
class PieData {
  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: 0.0)
  final double value;

  PieData({
    required this.name,
    required this.value,
  });

  factory PieData.fromJson(Map<String, dynamic> json) =>
      _$PieDataFromJson(json);

  Map<String, dynamic> toJson() => _$PieDataToJson(this);
}

/// Proje tutar paylaşımı grafiği için root model
@JsonSerializable(explicitToJson: true)
class ChartDashboardData {
  final List<PieData> series;

  ChartDashboardData({required this.series});

  factory ChartDashboardData.fromJson(Map<String, dynamic> json) =>
      _$ChartDashboardDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChartDashboardDataToJson(this);
}

/// Proje vs Faaliyet donut grafiği için özet
@JsonSerializable()
class ProjectVsActivity {
  @JsonKey(defaultValue: 0)
  final int proje;

  @JsonKey(defaultValue: 0)
  final int faaliyet;

  ProjectVsActivity({
    required this.proje,
    required this.faaliyet,
  });

  factory ProjectVsActivity.fromJson(Map<String, dynamic> json) =>
      _$ProjectVsActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectVsActivityToJson(this);
}