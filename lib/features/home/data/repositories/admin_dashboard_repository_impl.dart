

import '../../domain/repositories/admin_dashboard_repository.dart';
import '../../data/datasources/admin_dashboard_remote_data_source.dart';
import '../../data/models/proje_adet_model.dart';
import '../../data/models/chart_dashboard_data.dart';
import '../../data/models/faliyet_line.dart';

/// Concrete implementation of DashboardRepository using the remote data source.
class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  final AdminDashboardRemoteDataSource remoteDataSource;

  AdminDashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProjeAdetModel>> fetchProjectStatusCounts() {
    return remoteDataSource.getProjeAdet();
  }

  @override
  Future<ChartDashboardData> fetchProjectAmountChart() {
    return remoteDataSource.getProjeTutarPie();
  }

  @override
  Future<List<FaliyetLine>> fetchActivityStatusByDepartment() {
    return remoteDataSource.getFaaliyetTamamlandiBar();
  }

  @override
  Future<ProjectVsActivity> fetchProjectVsActivitySummary() {
    return remoteDataSource.getFaaliyetProjeDonut();
  }
}