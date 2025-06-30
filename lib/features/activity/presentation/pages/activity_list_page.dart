import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/core/extensions/date_extensions.dart';
import 'package:project_management_app/core/extensions/role_extensions.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/gorev_durum_enum.dart';
import '../../../../core/page/base_page.dart';
import '../../../../core/preferences/AppPreferences.dart';
import '../../../../core/widgets/app_custom_app_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../activity/presentation/widgets/date_picker_section.dart';
import '../../../kisi/data/models/kisi_model.dart';
import '../../../kisi/presentation/cubit/kisi_cubit.dart';
import '../../../kisi/presentation/cubit/kisi_state.dart';
import '../../data/models/faliyet_gorev_request_model.dart';
import '../../domain/usecases/activity_usecases.dart';
import '../bloc/activity_cubit.dart';
import '../bloc/activity_state.dart';
import '../widgets/activity_list_view.dart';
import 'activity_add_page.dart';

class ActivityListPage extends StatefulWidget {
  final ActivityUseCases actvityUseCases;

  const ActivityListPage({
    super.key,
    required this.actvityUseCases,
  });

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  int? _selectedUserId;
  DateTime _selectedDate = DateTime.now();
  late ActivityCubit _activtyCubit;
  final TextEditingController _searchController = TextEditingController();

  // Seçilen tarihi günceller ve bu tarihe göre görevleri yeniden yükler
  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _loadActivities();
  }

  // Widget oluşturulduğunda cubit'i başlatır ve ilk görev listesini yükler
  @override
  void initState() {
    super.initState();
    _activtyCubit = ActivityCubit(widget.actvityUseCases);
    _loadActivities();
  }

  // Görev listesini API'den çekmek için gerekli isteği başlatır
  void _loadActivities() {
    final req = _makeRequestModel();
    _activtyCubit.getActivityList(req);
  }

  // Görev listesi için istek modelini oluşturur, admin ise alternatif kullanıcı id'si kullanabilir
  FaliyetGorevRequestModel _makeRequestModel({int? overrideUserId}) {
    // Kullanıcı id'sini adminlik durumuna göre belirle
    final userId = context.isAdmin
        ? (overrideUserId ?? (_selectedUserId ?? 0))
        : (AppPreferences.kullaniciId ?? 0);
    // TaskListRequestModel objesini oluştur ve döndür
    return FaliyetGorevRequestModel(
      gorevId: 0,
      kullaniciId: userId,
      durum: GorevDurumEnum.none,
      baslangicTarihi: _selectedDate.yMd,
      baslangicTarihi1: null,
    );
  }

  // Yüklenme sürecini gösteren indikatör widget'ı
  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  // Hata durumunda gösterilecek mesaj ve tekrar dene butonunu içeren widget
  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          AppSizes.gapH8,
          ElevatedButton(
            onPressed: () {
              _loadActivities();
            },
            child: Text(
              "Tekrar Dene",
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  // Sayfa kapatılırken text controller ve cubit kaynaklarını temizler
  @override
  void dispose() {
    _searchController.dispose();
    _activtyCubit.close();
    super.dispose();
  }

  // Sayfanın ana görsel yapısını oluşturan build metodu
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _activtyCubit,
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
                      if (context.isAdmin)
                        AppButton(
                          title: "Kullanıcı Seç",
                          icon: Icons.people,
                          onClick: () async {
                            final result = await showModalBottomSheet<int?>(
                              context: context,
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (_) {
                                return BlocBuilder<KisiCubit, KisiState>(
                                  builder: (context, state) {
                                    if (state is KisiLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (state is KisiLoaded) {
                                      return UserSelectionBottomSheet(
                                        users: state.kisiler,
                                        selectedUserId: _selectedUserId,
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                );
                              },
                            );
                            // Eğer kullanıcı seçimi iptal edildiyse (result null) kullanıcıId'yi 0 olarak ata
                            final userId = result ?? 0;
                            setState(() {
                              _selectedUserId = userId;
                            });
                            _activtyCubit.getActivityList(_makeRequestModel(overrideUserId: userId));
                          },
                          height: 35,
                          borderRadius: 10,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                    ],
                  ),
                  AppSizes.gapH12,
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
                  AppSizes.gapH16,
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
                  AppSizes.gapH16,
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
                          _activtyCubit.search(value);
                        },
                        onSuffixIconTap: hasText
                            ? () {
                          _searchController.clear();
                          _activtyCubit.search('');
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
                      return _buildLoading();
                    } else if (state is ActivityLoadSuccess) {
                      final activities = state.activities;
                      if (activities.isEmpty) {
                        return Center(
                          child: Text(
                            "Görev bulunamadı",
                            style:
                            TextStyle(fontSize: 16.sp, color: Colors.grey),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async => _loadActivities(),
                        child: ActivityListView(
                          activities: activities,
                          onTap: (activityItem) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: _activtyCubit,
                                  child: ActivityAddPage(activity: activityItem),
                                ),
                              ),
                            ).then((value) {
                              if (value == true) {
                                _loadActivities();
                              }
                            });
                          },
                        ),
                      );
                    } else if (state is ActivityFailure) {
                      return _buildError(state.message);
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
  final List<KisiModel> users;

  /// Başlangıçta seçili gelen kullanıcı id’si (null ise hiç seçili yok)
  final int? selectedUserId;

  const UserSelectionBottomSheet({
    Key? key,
    required this.users,
    this.selectedUserId,
  }) : super(key: key);

  @override
  _UserSelectionBottomSheetState createState() =>
      _UserSelectionBottomSheetState();
}

class _UserSelectionBottomSheetState extends State<UserSelectionBottomSheet> {
  late int? _tempSelectedId;
  late TextEditingController _searchController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _tempSelectedId = widget.selectedUserId;
    _searchController = TextEditingController()
      ..addListener(() => setState(() => _searchText = _searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.users.where((u) {
      final full = '${u.adi} ${u.soyadi}'.toLowerCase();
      return full.contains(_searchText.toLowerCase());
    }).toList();

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Başlık, arama vs...
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Kullanıcı ara...',
                prefixIcon: Icon(Icons.search),
                // …
              ),
            ),
            SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final user = filtered[i];
                  return RadioListTile<int>(
                    title: Text('${user.adi} ${user.soyadi}'),
                    value: user.id,
                    groupValue: _tempSelectedId,
                    onChanged: (val) => setState(() => _tempSelectedId = val),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    type: ButtonType.outlined,
                    title: 'Temizle',
                    onClick: () => setState(() => _tempSelectedId = null),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    title: 'Uygula',
                    onClick: () => Navigator.of(context).pop(_tempSelectedId),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

