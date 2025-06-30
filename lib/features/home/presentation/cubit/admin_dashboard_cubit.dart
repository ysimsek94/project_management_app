

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/features/home/data/models/proje_request_model.dart';
import '../../data/models/proje_adet_model.dart';
import '../../data/models/chart_dashboard_data.dart';
import '../../data/models/faliyet_line.dart';
import '../../domain/usecases/admin_dashboard_usecase.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final AdminDashboardDataUseCases _getDashboardDataUseCase;

  AdminDashboardCubit(this._getDashboardDataUseCase) : super(AdminDashboardLoading());

  Future<void> loadAll() async {
    emit(AdminDashboardLoading());
    try {
      // UseCase; adapt method names as in your implementation
      final List<ProjeAdetModel> statusList = await _getDashboardDataUseCase.getProjectStatusList(ProjeRequestModel.empty());
      final ChartDashboardData chartData = await _getDashboardDataUseCase.getChartDashboardData(ProjeRequestModel.empty());
      final List<FaliyetLine> activityByDept = await _getDashboardDataUseCase.getActivityByDepartment();
      final List<PieData> projectVsActivity = await _getDashboardDataUseCase.getProjectVsActivity();

      emit(AdminDashboardLoaded(
        projectStatusList: statusList,
        chartData: chartData,
        activityByDept: activityByDept,
        projectVsActivity: projectVsActivity,
      ));
    } catch (error) {
      emit(AdminDashboardError(error.toString()));
    }
  }
}