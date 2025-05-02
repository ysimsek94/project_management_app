import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final String status;
  final String? dueTime;
  final double? latitude;
  final double? longitude;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.dueTime,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [id, title, description, status, dueTime, latitude, longitude];
}