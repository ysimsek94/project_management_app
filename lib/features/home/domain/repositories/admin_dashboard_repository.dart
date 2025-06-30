import '../../data/models/proje_adet_model.dart';
import '../../data/models/chart_dashboard_data.dart';
import '../../data/models/faliyet_line.dart';
import '../../data/models/proje_request_model.dart';

/// Repository interface for fetching admin dashboard data.
abstract class AdminDashboardRepository {
  /// Fetches the count of projects per status.
  Future<List<ProjeAdetModel>> fetchProjectStatusCounts(ProjeRequestModel request);

  /// Fetches data for the project amount pie chart.
  Future<ChartDashboardData> fetchProjectAmountChart(ProjeRequestModel request);

  /// Fetches activity completion status grouped by department.
  Future<List<FaliyetLine>> fetchActivityStatusByDepartment();

  /// Fetches summary counts for the project vs. activity donut chart.
  Future<List<PieData>> fetchProjectVsActivitySummary();
}