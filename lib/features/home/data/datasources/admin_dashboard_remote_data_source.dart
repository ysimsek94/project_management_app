import '../models/chart_dashboard_data.dart';
import '../models/faliyet_line.dart';
import '../models/proje_adet_model.dart';

/// Abstract data source for Admin Dashboard API calls
abstract class AdminDashboardRemoteDataSource {
  Future<List<ProjeAdetModel>> getProjeAdet();
  Future<ChartDashboardData> getProjeTutarPie();
  Future<List<FaliyetLine>> getFaaliyetTamamlandiBar();
  Future<ProjectVsActivity> getFaaliyetProjeDonut();
}
