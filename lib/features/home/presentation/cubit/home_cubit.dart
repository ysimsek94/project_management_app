import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/dashboard_task_model.dart';
import '../../data/models/status_summary_model.dart';
import '../../domain/usecases/home_usecases.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeUseCases useCases;
  HomeCubit(this.useCases) : super(HomeInitial());

  /// Yalnızca dashboard görevlerini çeker
  Future<List<DashboardTaskModel>> _loadDashboardTasks() {
    return useCases.getDashboardTasks();
  }

  /// Yalnızca durum özetlerini çeker
  Future<List<StatusSummaryModel>> _loadStatusSummaries() {
    return useCases.getStatusSummary();
  }

  /// Sadece dashboard görevlerini çeker
  Future<void> fetchDashboardTasks() async {
    emit(DashboardLoading());
    try {
      final tasks = await _loadDashboardTasks();
      emit(HomeTasksLoaded(tasks));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  /// Sadece durum özetlerini çeker
  Future<void> fetchStatusSummaries() async {
    emit(SummariesLoading());
    try {
      final summaries = await _loadStatusSummaries();
      emit(HomeSummariesLoaded(summaries));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}