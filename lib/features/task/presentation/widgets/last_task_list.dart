import 'package:flutter/material.dart';
import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';
import '../widgets/task_list_view.dart';

class LastTasksList extends StatelessWidget {
  final List<TaskListItemModel> tasks;
  final void Function(TaskListItemModel)? onTap;

  const LastTasksList({
    Key? key,
    required this.tasks,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text("Son talepler bulunamadı."));
    }
    return TaskListView(
      tasks: tasks,
      onTap: onTap,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
