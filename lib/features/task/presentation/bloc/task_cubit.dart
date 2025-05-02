import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/task_usecases.dart';
import '../../domain/entities/task.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskUseCases _taskUseCases;
  List<Task> _allTasks = [];

  TaskCubit(this._taskUseCases) : super(TaskInitial());



  Future<void> deleteTask(int taskId) async {
    emit(TaskOperationInProgress());
    try {
      await _taskUseCases.deleteTask(taskId);
      emit(TaskDeleteSuccess(taskId));
    } catch (e) {
      emit(TaskFailure('Görev silinemedi: ${e.toString()}'));
    }
  }

  Future<void> updateTask(Task task) async {
    emit(TaskOperationInProgress());
    try {
     await _taskUseCases.updateTask(task);
      emit(TaskUpdateSuccess("Görev Güncellendi."));
    } catch (e) {
      emit(TaskFailure('Görev güncellenemedi: ${e.toString()}'));
    }
  }

  Future<Task> addTask(Task task) async {

    emit(TaskOperationInProgress());
    try {
      final createdTask = await _taskUseCases.addTask(task);
      emit(TaskCreateSuccess(createdTask));
      return createdTask;
    } catch (e) {
      emit(TaskFailure('Görev eklenemedi: ${e.toString()}'));
      rethrow;
    }
  }
  Future<void> getTaskList(String date) async {
    emit(TaskLoadInProgress());
    try {
      final tasks = await _taskUseCases.getTaskList(date);
      _allTasks = tasks;                    // tam listeyi saklıyoruz
      emit(TaskLoadSuccess(_allTasks));    // ekrana tam listeyi basıyoruz
    } catch (e) {
      emit(TaskFailure('Görevler yüklenemedi: $e'));
    }
  }

  void search(String query) {
    // Küçük/büyük harf duyarsız filtre
    final filtered = _allTasks
        .where((t) => t.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(TaskLoadSuccess(filtered));
  }
}
