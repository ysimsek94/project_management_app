import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/preferences/AppPreferences.dart';
import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';
import 'package:project_management_app/features/task/data/models/task_request_model.dart';
import '../../../../core/constants/gorev_durum_enum.dart';
import '../../domain/usecases/task_usecases.dart';
import 'task_state.dart';
import '../../data/models/task_list_request_model.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskUseCases _taskUseCases;
  List<TaskListItemModel> _allTasks = [];

  TaskCubit(this._taskUseCases) : super(TaskInitial());

  Future<void> updateTask(TaskRequestModel task) async {
    emit(TaskOperationInProgress());
    try {
      await _taskUseCases.updateTask(task);
      emit(TaskUpdateSuccess("Görev Güncellendi."));
    } catch (e) {
      emit(TaskFailure('Görev güncellenemedi: ${e.toString()}'));
    }
  }

  // Future<Task> addTask(Task task) async {
  //   emit(TaskOperationInProgress());
  //   try {
  //     final createdTask = await _taskUseCases.addTask(task);
  //     emit(TaskCreateSuccess(createdTask));
  //     return createdTask;
  //   } catch (e) {
  //     emit(TaskFailure('Görev eklenemedi: ${e.toString()}'));
  //     rethrow;
  //   }
  // }

  Future<void> getTaskList(String date) async {
    emit(TaskLoadInProgress());
    try {
      final request = TaskListRequestModel(
          gorevId: 0,
          kullaniciId: AppPreferences.kullaniciId ?? 0,
          durum: GorevDurumEnum.none,
          baslangicTarihi: "2025-01-01T00:00:00",
          baslangicTarihi1: null);

      var tasks = await _taskUseCases.getTaskList(request);
      _allTasks = tasks; // tam listeyi saklıyoruz
      emit(TaskLoadSuccess(_allTasks)); // ekrana tam listeyi basıyoruz
    } catch (e) {
      emit(TaskFailure('Görevler yüklenemedi: $e'));
    }
  }
  Future<void> getAllTaskList() async {
    emit(TaskLoadInProgress());
    try {
      var tasks = await _taskUseCases.getAllTaskList();
      _allTasks = tasks; // tam listeyi saklıyoruz
      emit(TaskLoadSuccess(_allTasks)); // ekrana tam listeyi basıyoruz
    } catch (e) {
      emit(TaskFailure('Görevler yüklenemedi: $e'));
    }
  }
  Future<void> fetchLastTasks(TaskListRequestModel taskListRequestModel) async {
    emit(TaskLoadInProgress());
    try {
      final tasks =
          await _taskUseCases.getLastTasks(taskListRequestModel, count: 10);
      emit(TaskLoadSuccess(tasks));
    } catch (e) {
      emit(TaskFailure('Son görevler yüklenemedi: ${e.toString()}'));
    }
  }

  void search(String query) {
    // Küçük/büyük harf duyarsız filtre
    final filtered = _allTasks
        .where(
            (t) => (t.projeFazGorev.gorev ?? '').toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(TaskLoadSuccess(filtered));
  }
}
