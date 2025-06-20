import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/core/extensions/date_extensions.dart';
import 'package:project_management_app/core/extensions/role_extensions.dart';

import 'package:project_management_app/core/widgets/app_button.dart';
import 'package:project_management_app/features/task/domain/usecases/task_usecases.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_cubit.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_state.dart';
import 'package:project_management_app/features/task/presentation/pages/task_add_page.dart';

import '../../../../core/page/base_page.dart';
import '../widgets/task_list_view.dart';
import '../../../../core/constants/app_sizes.dart';
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
  bool get isAdmin => context.hasRole('admin');

  List<String> _selectedUsers = [];
  List<String> _users = ['Ali Yılmaz','Yusuf Şimşek','Bekir Yıldız','Emre Boz','Mehmet Yurdagul','Rıdvan Baş','Yusuf Sari','Burak Sar','Erman Tor']; // later fill from API

  DateTime _selectedDate = DateTime.now();
  late TaskCubit _taskCubit;
  final TextEditingController _searchController = TextEditingController();

  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    if (isAdmin) {
      _taskCubit.getAllTaskList();
    } else {
      _taskCubit.getTaskList(date.yMd);
    }
  }

  @override
  void initState() {
    super.initState();
    _taskCubit = TaskCubit(widget.taskUsecases);
    if (isAdmin) {
      // TODO: fetch user list into _users
      _selectedUsers = [];
      _taskCubit.getAllTaskList();
    } else {
      _taskCubit.getTaskList(DateTime.now().yMd);
    }
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
      child: BasePage(
        title: "Görev Listesi",
        showBackButton: false,
        child: Padding(
          padding: EdgeInsets.all(8.w),
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
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).textTheme.titleLarge?.color ??
                                  Colors.black87,
                        ),
                      ),
                      if (isAdmin)
                        AppButton(
                          title: "Kullanıcı Seç",
                          icon: Icons.people,
                          onClick: () async {
                            final result = await showModalBottomSheet<List<String>>(
                              context: context,
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              builder: (_) => UserSelectionBottomSheet(
                                users: _users,
                                selectedUsers: _selectedUsers,
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _selectedUsers = result;
                                if (_selectedUsers.isEmpty) {
                                  _taskCubit.getTaskList(_selectedDate.yMd);
                                } else {
                                  // _activityCubit.getActivityListByUsers(_selectedDate.yMd, _selectedUsers);
                                }
                              });
                            }
                          },
                          height: 35,
                          borderRadius: 10,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      // if (context.hasRole('admin'))
                      //   AppButton(
                      //     title: "+ Add Task",
                      //     onClick: () {
                      //       final cubit = _taskCubit;
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (_) => BlocProvider.value(
                      //             value: _taskCubit,
                      //             child: const TaskAddPage(),
                      //           ),
                      //         ),
                      //       ).then((value) {
                      //         if (value == true) {
                      //           cubit.getTaskList(_selectedDate.yMd);
                      //         }
                      //       });
                      //     },
                      //     minWidth: 45.w,
                      //     height: 35.h,
                      //   ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DatePickerSection(
                        currentDate: _selectedDate,
                        onDateSelected: (date) {
                          _updateSelectedDate(date);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Theme.of(context).primaryColor, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text("Tüm Görevler - ",
                          style: TextStyle(fontSize: 14.sp)),
                      GestureDetector(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            _updateSelectedDate(pickedDate);
                          }
                        },
                        child: Text(
                          _selectedDate.dMy,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  AnimatedBuilder(
                    animation: _searchController,
                    builder: (context, child) {
                      final hasText = _searchController.text.isNotEmpty;
                      return AppTextField(
                        hint: 'Görev ara...',
                        prefixIcon: Icons.search,
                        suffixIcon: hasText ? Icons.clear : null,
                        borderRadius: 12,
                        textEditingController: _searchController,
                        onChange: (value) {
                          _taskCubit.search(value);
                        },
                        onSuffixIconTap: hasText
                            ? () {
                                _searchController.clear();
                                _taskCubit.search('');
                              }
                            : null,
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
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
                        return Center(
                          child: Text(
                            "Görev bulunamadı",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.grey),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () => isAdmin
                            ? _taskCubit.getAllTaskList()
                            : _taskCubit.getTaskList(_selectedDate.yMd),
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
                                // Eğer yönetici ise tüm görev listesini yenile, değilse seçili tarihin görevlerini getir
                                if (isAdmin) {
                                  _taskCubit.getAllTaskList();
                                } else {
                                  _taskCubit.getTaskList(_selectedDate.yMd);
                                }
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
                              child: Text(
                                "Tekrar Dene",
                                style: TextStyle(fontSize: 14.sp),
                              ),
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

class UserSelectionBottomSheet extends StatefulWidget {
  final List<String> users;
  final List<String> selectedUsers;

  const UserSelectionBottomSheet({
    Key? key,
    required this.users,
    required this.selectedUsers,
  }) : super(key: key);

  @override
  _UserSelectionBottomSheetState createState() => _UserSelectionBottomSheetState();
}

class _UserSelectionBottomSheetState extends State<UserSelectionBottomSheet> {
  late List<String> _tempSelectedUsers;
  late TextEditingController _searchController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _tempSelectedUsers = List<String>.from(widget.selectedUsers);
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = widget.users
        .where((u) => u.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              'Kullanıcı Seç',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Kullanıcı ara...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  final isSelected = _tempSelectedUsers.contains(user);
                  return CheckboxListTile(
                    title: Text(user),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _tempSelectedUsers.add(user);
                        } else {
                          _tempSelectedUsers.remove(user);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    type: ButtonType.outlined,
                    onClick: () {
                      setState(() {
                        _tempSelectedUsers.clear();
                      });
                    },
                    title:'Temizle',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    onClick: () {
                      Navigator.of(context).pop(_tempSelectedUsers);
                    },
                    title:'Uygula',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
