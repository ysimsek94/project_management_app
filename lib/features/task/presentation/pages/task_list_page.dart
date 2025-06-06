import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/extensions/date_extensions.dart';
import 'package:project_management_app/core/extensions/role_extensions.dart';
import 'package:project_management_app/core/preferences/AppPreferences.dart';
import 'package:project_management_app/core/widgets/app_custom_app_bar.dart';
import 'package:project_management_app/features/task/domain/usecases/task_usecases.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_cubit.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_state.dart';
import 'package:project_management_app/features/task/presentation/pages/task_add_page.dart';
import '../../data/models/task_list_item_model.dart';
import '../../data/models/task_request_model.dart';
import '../widgets/task_list_view.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../widgets/date_picker_section.dart';

class TaskListPage extends StatefulWidget {
  final TaskUseCases taskUsecases;

  const TaskListPage({
    super.key,
    required this.taskUsecases,
  });

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  DateTime _selectedDate = DateTime.now();
  late TaskCubit _taskCubit;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskCubit = TaskCubit(widget.taskUsecases)
      ..getTaskList(DateTime.now().yMd);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _taskCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _taskCubit,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Görev Listesi",
          showBackButton: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Non-expandable widgets grouped in a Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_selectedDate.monthName}, ${_selectedDate.day}",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      if (context.hasRole('admin'))
                        AppButton(
                          title: "+ Add Task",
                          onClick: () {
                            final cubit = _taskCubit;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: _taskCubit,
                                  child: const TaskAddPage(),
                                ),
                              ),
                            ).then((value) {
                              if (value == true) {
                                cubit.getTaskList(_selectedDate.yMd);
                              }
                            });
                          },
                          minWidth: 45,
                          height: 35,
                        ),
                    ],
                  ),
                  AppSizes.gapH12,
                  SizedBox(
                    height: 100,
                    child: DatePickerSection(
                      currentDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() => _selectedDate = date);
                        _taskCubit.getTaskList(date.yMd);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Theme.of(context).primaryColor, size: 18),
                      AppSizes.gapH8,
                      const Text("Tüm Görevler - ",
                          style: TextStyle(fontSize: 14)),
                      Text(
                        _selectedDate.dMy,
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                  AppSizes.gapH16,
                  AppTextField(
                    hint: 'Görev ara...',
                    prefixIcon: Icons.search,
                    borderRadius: 12,
                    textEditingController: _searchController,
                    onChange: (value) {
                      _taskCubit.search(value);
                    },
                  ),
                  AppSizes.gapH16,
                ],
              ),
              // Expandable widget
              Expanded(
                child: BlocBuilder<TaskCubit, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoadInProgress) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskLoadSuccess) {
                      final tasks = state.tasks;
                      if (tasks.isEmpty) {
                        return const Center(
                          child: Text(
                            "Görev bulunamadı",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () =>
                            _taskCubit.getTaskList(_selectedDate.yMd),
                        child: TaskListView(
                          tasks: tasks,
                          onTap: (taskItem) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: _taskCubit,
                                  child: TaskAddPage(task: taskItem),
                                ),
                              ),
                            ).then((value) {
                              if (value == true) {
                                _taskCubit.getTaskList(_selectedDate.yMd);
                              }
                            });
                          },
                        ),
                      );
                    } else if (state is TaskFailure) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.message),
                            AppSizes.gapH8,
                            ElevatedButton(
                              onPressed: () =>
                                  _taskCubit.getTaskList(_selectedDate.dMy),
                              child: const Text("Tekrar Dene"),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
