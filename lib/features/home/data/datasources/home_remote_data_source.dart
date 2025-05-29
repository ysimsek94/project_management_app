import '../models/dashboard_task_model.dart';
import '../models/status_summary_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<DashboardTaskModel>> fetchDashboardTasks();
  Future<List<StatusSummaryModel>> fetchStatusSummary();

}
