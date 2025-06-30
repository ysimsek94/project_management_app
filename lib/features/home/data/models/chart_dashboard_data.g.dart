// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PieData _$PieDataFromJson(Map<String, dynamic> json) => PieData(
      name: json['name'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PieDataToJson(PieData instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

ChartDashboardData _$ChartDashboardDataFromJson(Map<String, dynamic> json) =>
    ChartDashboardData(
      series: (json['series'] as List<dynamic>)
          .map((e) => PieData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChartDashboardDataToJson(ChartDashboardData instance) =>
    <String, dynamic>{
      'series': instance.series.map((e) => e.toJson()).toList(),
    };
