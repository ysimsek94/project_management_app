import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/extensions/date_extensions.dart';
import 'package:project_management_app/core/extensions/role_extensions.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_custom_app_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../activity/presentation/widgets/date_picker_section.dart';
import '../../domain/usecases/activity_usecases.dart';
import '../bloc/activity_cubit.dart';
import '../bloc/activity_state.dart';
import '../widgets/activity_list_view.dart';
import 'activity_add_page.dart';

class ActivityListPage extends StatefulWidget {
  final ActivityUseCases activityUseCases;

  const ActivityListPage({
    super.key,
    required this.activityUseCases,
  });

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  DateTime _selectedDate = DateTime.now();
  List<String> _selectedUsers = [];
  List<String> _users = ['Ali Yılmaz','Yusuf Şimşek','Bekir Yıldız','Emre Boz','Mehmet Yurdagul','Rıdvan Baş','Yusuf Sari','Burak Sar','Erman Tor']; // later fill from API
  late ActivityCubit _activityCubit;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activityCubit = ActivityCubit(widget.activityUseCases)
      ..getActivityList(DateTime.now().yMd);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _activityCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _activityCubit,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Faaliyet Listesi",
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (context.hasRole('admin'))
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
                                  _activityCubit.getActivityList(_selectedDate.yMd);
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
                    ],
                  ),
                  AppSizes.gapH12,
                  DatePickerSection(
                    currentDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                        _activityCubit.getActivityList(date.yMd);
                      }
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Theme.of(context).primaryColor, size: 18),
                      AppSizes.gapH8,
                      const Text("Tüm Faaliyetler - ",
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
                  AnimatedBuilder(
                    animation: _searchController,
                    builder: (context, child) {
                      final hasText = _searchController.text.isNotEmpty;
                      return AppTextField(
                        hint: 'Faaliyet ara...',
                        prefixIcon: Icons.search,
                        suffixIcon: hasText ? Icons.clear : null,
                        borderRadius: 12,
                        textEditingController: _searchController,
                        onChange: (value) {
                          _activityCubit.search(value);
                        },
                        onSuffixIconTap: hasText
                            ? () {
                                _searchController.clear();
                                _activityCubit.search('');
                              }
                            : null,
                      );
                    },
                  ),
                  AppSizes.gapH16,
                ],
              ),
              // Expandable widget
              Expanded(
                child: BlocBuilder<ActivityCubit, ActivityState>(
                  builder: (context, state) {
                    if (state is ActivityLoadInProgress) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ActivityLoadSuccess) {
                      final activities = state.activities;
                      if (activities.isEmpty) {
                        return const Center(
                          child: Text(
                            "Faaliyet bulunamadı",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () =>
                            _activityCubit.getActivityList(_selectedDate.yMd),
                        child: ActivityListView(
                          activities: activities,
                          onTap: (activityItem) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: _activityCubit,
                                  child: ActivityAddPage(activity: activityItem),
                                ),
                              ),
                            ).then((value) {
                              if (value == true) {
                                _activityCubit.getActivityList(_selectedDate.yMd);
                              }
                            });
                          },
                        ),
                      );
                    } else if (state is ActivityFailure) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.message),
                            AppSizes.gapH8,
                            ElevatedButton(
                              onPressed: () =>
                                  _activityCubit.getActivityList(_selectedDate.dMy),
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
