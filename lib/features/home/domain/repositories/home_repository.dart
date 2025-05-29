import '../../data/models/dashboard_task_model.dart';
import '../../data/models/status_summary_model.dart';

abstract class HomeRepository {
  Future<List<DashboardTaskModel>> getDashboardTasks();
  Future<List<StatusSummaryModel>> getStatusSummary();
}