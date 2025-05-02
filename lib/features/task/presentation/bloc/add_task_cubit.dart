import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/task_usecases.dart';
import 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final TaskUseCases useCase;

  AddTaskCubit(this.useCase) : super(AddTaskInitial());

  // Future<void> submit(String title, String description, String status) async {
  //   emit(AddTaskLoading());
  //   try {
  //     await useCase.addTask(title: title, description: description, status: status);
  //     emit(AddTaskSuccess());
  //   } catch (e) {
  //     emit(AddTaskError("Görev eklenemedi: ${e.toString()}"));
  //   }
  // }
}