import '../models/chart_dashboard_data.dart';
import '../models/faliyet_line.dart';
import '../models/proje_adet_model.dart';
import '../models/proje_request_model.dart';

/// Abstract data source for Admin Dashboard API calls
abstract class AdminDashboardRemoteDataSource {
  Future<List<ProjeAdetModel>> getProjeAdet(ProjeRequestModel request);
  Future<ChartDashboardData> getProjeTutarPie(ProjeRequestModel request);
  Future<List<FaliyetLine>> getFaaliyetTamamlandiBar();
  Future<List<PieData>> getFaaliyetProjeDonut();
}
