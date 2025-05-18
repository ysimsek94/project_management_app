import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_cubit.dart';
import '../bloc/task_state.dart';
import '../widgets/task_list_view.dart';

class LastTasksList extends StatelessWidget {
  const LastTasksList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoadSuccess) {
          if (state.tasks.isEmpty) {
            return const Center(child: Text("Son talepler bulunamadı."));
          }
          return TaskListView(
            tasks: state.tasks,
            onTap: null,
          );
        } else if (state is TaskFailure) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
