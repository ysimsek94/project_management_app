import '../../data/models/proje_request_model.dart';
import '../../domain/repositories/admin_dashboard_repository.dart';
import '../../data/models/proje_adet_model.dart';
import '../../data/models/chart_dashboard_data.dart';
import '../../data/models/faliyet_line.dart';

/// UseCase for fetching all data needed by the Admin Dashboard.
class AdminDashboardDataUseCases {
  final AdminDashboardRepository _repository;

  AdminDashboardDataUseCases(this._repository);

  /// Returns the list of project status counts for the info cards.
  Future<List<ProjeAdetModel>> getProjectStatusList(ProjeRequestModel request) {
    return _repository.fetchProjectStatusCounts(request);
  }

  /// Returns the data needed for the pie chart of project amounts.
  Future<ChartDashboardData> getChartDashboardData(ProjeRequestModel request) {
    return _repository.fetchProjectAmountChart(request);
  }

  /// Returns the list of activity completion status grouped by department.
  Future<List<FaliyetLine>> getActivityByDepartment() {
    return _repository.fetchActivityStatusByDepartment();
  }

  /// Returns the summary counts for project vs activity donut chart.
  Future<List<PieData>> getProjectVsActivity() {
    return _repository.fetchProjectVsActivitySummary();
  }
}