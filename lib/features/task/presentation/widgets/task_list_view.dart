import 'package:flutter/cupertino.dart';
import 'package:project_management_app/features/task/presentation/widgets/task_card.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/task.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task)? onTap;

  const TaskListView({required this.tasks, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => AppSizes.gapH8,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onTap: onTap != null ? () => onTap!(task) : null,
        );
      },
    );
  }
}