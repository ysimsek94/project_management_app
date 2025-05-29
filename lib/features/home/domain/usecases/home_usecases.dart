// lib/features/home/domain/usecases/home_usecases.dart
import '../repositories/home_repository.dart';
import '../../data/models/dashboard_task_model.dart';
import '../../data/models/status_summary_model.dart';

class HomeUseCases {
  final HomeRepository repository;
  HomeUseCases(this.repository);

  /// Dashboard kartları için görevleri getirir
  Future<List<DashboardTaskModel>> getDashboardTasks() =>
      repository.getDashboardTasks();

  /// Durum adetleri için özet veriyi getirir
  Future<List<StatusSummaryModel>> getStatusSummary() =>
      repository.getStatusSummary();
}