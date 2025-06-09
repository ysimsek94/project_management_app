import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';
import '../../../task/presentation/bloc/task_cubit.dart';
import '../../../task/presentation/bloc/task_state.dart';
import '../../data/models/status_summary_model.dart';
import '../../domain/usecases/home_usecases.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeUseCases useCases;
  final TaskCubit taskCubit; // TaskCubit’i parametre olarak alın

  HomeCubit(this.useCases, this.taskCubit) : super(const HomeInitial());



  /// Yalnızca durum özetlerini çeker
  Future<List<StatusSummaryModel>> _loadStatusSummaries() {
    return useCases.getStatusSummary();
  }
  /// Yalnızca faaliyet özetlerini çeker
  Future<List<StatusSummaryModel>> _loadFaiyetStatusSummaries() {
    return useCases.getFaliyetStatusSummary();
  }

  /// Tüm verileri (görevler, durum özetleri, faaliyet özetleri) tek seferde yükler
  Future<void> initialize() async {
    emit(HomeLoading());
    try {
      // 1) TaskCubit’in şu anki state’indeki görevleri alın:
      final taskState = taskCubit.state;
      List<TaskListItemModel> tasksFromTaskCubit = [];
      if (taskState is TaskLoadSuccess) {
        // TaskModel listesini TaskListItemModel listesine dönüştürün
        tasksFromTaskCubit = List<TaskListItemModel>.from(taskState.tasks);
      } else {
        // Eğer henüz TaskCubit görevleri yüklemedi ise, isterseniz bekleyin:
        await Future.delayed(const Duration(milliseconds: 100));
        return initialize(); // Biraz sonra tekrar deneyin
      }
      final summaries = await _loadStatusSummaries();
      final faaliyetSummaries = await _loadFaiyetStatusSummaries();
      emit(HomeDataLoaded(tasksFromTaskCubit, summaries, faaliyetSummaries));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}