import 'package:equatable/equatable.dart';

class StatusSummaryModel extends Equatable {
  final String name;
  final double value;

  StatusSummaryModel({required this.name, required this.value});

  factory StatusSummaryModel.fromJson(Map<String, dynamic> json) {
    return StatusSummaryModel(
      name: (json['name'] as String?) ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
      };

  @override
  List<Object> get props => [name, value];
}