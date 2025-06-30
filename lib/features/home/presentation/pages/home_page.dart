import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/core/constants/app_sizes.dart';
import 'package:project_management_app/core/constants/gorev_durum_enum.dart';
import 'package:project_management_app/features/home/domain/usecases/admin_dashboard_usecase.dart';
import 'package:project_management_app/features/task/domain/usecases/task_usecases.dart';
import 'package:project_management_app/features/task/presentation/pages/task_list_page.dart';
import 'package:project_management_app/injection.dart';
import '../../../../core/page/base_page.dart';
import '../../../../core/preferences/AppPreferences.dart';
import '../../../activity/domain/usecases/activity_usecases.dart';
import '../../../activity/presentation/bloc/activity_cubit.dart';
import '../../../activity/presentation/pages/activity_list_page.dart';
import '../../../map/presentation/pages/map_page.dart';
import 'package:project_management_app/features/map/presentation/cubit/map_cubit.dart';
import '../../../task/presentation/bloc/task_cubit.dart';
import 'package:project_management_app/core/extensions/theme_extensions.dart';
import 'package:project_management_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:project_management_app/core/extensions/role_extensions.dart';
import '../../../task/presentation/bloc/task_state.dart';
import '../../../task/presentation/pages/task_add_page.dart';
import '../../../task/presentation/widgets/last_task_list.dart';
import '../../presentation//widgets/completed_tasks_card.dart';
import 'package:project_management_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:project_management_app/features/home/domain/usecases/home_usecases.dart';
import 'package:project_management_app/features/home/presentation/pages/admin_dashboard_page.dart';
import 'package:project_management_app/features/home/presentation/cubit/admin_dashboard_cubit.dart';

class HomePage extends StatefulWidget {
  final TaskUseCases taskUseCases;
  final ActivityUseCases activityUseCases;

  const HomePage({
    super.key,
    required this.taskUseCases,
    required this.activityUseCases,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  /// Uygulamanın alt sekme konfigürasyonunu döndürür
  List<Map<String, dynamic>> _getNavConfig() {
    return [
      {
        'page': _buildHomeBody(),
        'item': const AppBottomNavBarItem(
          icon: Icons.home_outlined,
          label: 'Ana Sayfa',
        ),
      },
      {
        'page': BlocProvider(
          create: (_) => TaskCubit(widget.taskUseCases),
          child: TaskListPage(taskUsecases: widget.taskUseCases),
        ),
        'item': const AppBottomNavBarItem(
          icon: Icons.list_alt_outlined,
          label: 'Görevler',
        ),
      },
      {
        'page': BlocProvider(
          create: (_) => ActivityCubit(widget.activityUseCases),
          child: ActivityListPage(actvityUseCases:widget.activityUseCases),
        ),
        'item': const AppBottomNavBarItem(
          icon: Icons.event,
          label: 'Faaliyetler',
        ),
      },
      if (context.isAdmin)
        {
          'page': BlocProvider(
            create: (_) => getIt<MapCubit>()..loadTasks(),
            child: const TaskMapPage(),
          ),
          'item': const AppBottomNavBarItem(
            icon: Icons.map,
            label: 'Harita',
          ),
        },
    ];
  }

  /// Admin kullanıcı için ana sayfa görünümünü oluşturur
  Widget _buildAdminHome() {
    return BlocProvider(
      create: (_) =>
          AdminDashboardCubit(getIt<AdminDashboardDataUseCases>())..loadAll(),
      child: Stack(
        children: [
          _buildGradientBackground(),
          SafeArea(
            child: Column(
              children: [
                AppSizes.gapH16,
                _buildHeaderSection(),
                AppSizes.gapH16,
                const Expanded(child: AdminDashboardPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navConfig = _getNavConfig();

    final List<AppBottomNavBarItem> items = navConfig
        .map<AppBottomNavBarItem>((e) => e['item'] as AppBottomNavBarItem)
        .toList();

    List<Widget> pages =
        navConfig.map<Widget>((e) => e['page'] as Widget).toList();
    if (context.isAdmin) {
      pages[0] = _buildAdminHome();
    }

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(items),
    );
  }

  /// Builds the bottom navigation bar.
  Widget _buildBottomNavBar(List<AppBottomNavBarItem> items) {
    return AppBottomNavBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: items,
    );
  }

  /// Ana sayfanın gövdesini oluşturan ana widget
  Widget _buildHomeBody() {
    return Stack(
      children: [
        _buildGradientBackground(),
        SafeArea(
          child: Column(
            children: [
              AppSizes.gapH16,
              _buildHeaderSection(),
              AppSizes.gapH16,
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(8.w),
                  child: _buildDashboardCards(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Üst kısımdaki degrade arka plan
  Widget _buildGradientBackground() {
    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.theme.primaryColor, Colors.white10],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  /// Profil ve kullanıcı başlığı (kurumsal, minimalist)
  Widget _buildHeaderSection() {
    final adSoyad = (AppPreferences.username ?? '').trim();
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Küçük, sade bir avatar
          CircleAvatar(
            radius: 32.r,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.person_outline, size: 32.sp, color: Colors.white),
          ),
          SizedBox(width: 16.w),
          // Kullanıcı adı ve karşılama metni
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adSoyad.isNotEmpty ? adSoyad : "Kullanıcı",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Hoş geldiniz!',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.75),
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ),
          // Eğer ileride bir bildirim/ayarlar ikonu eklemek isterseniz:
          // IconButton(
          //   icon: Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.onBackground),
          //   onPressed: () { /* İşlev ekleyin */ },
          // ),
        ],
      ),
    );
  }

  /// Gösterge paneli kartları (tamamlanan görevler, performans, haftalık istekler)
  Widget _buildDashboardCards() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskCubit>(
          create: (ctx) {
            final cubit = TaskCubit(widget.taskUseCases);
            cubit.getAllTaskList();
            return cubit;
          },
        ),
        BlocProvider<HomeCubit>(
          create: (ctx) {
            final taskCubit = ctx.read<TaskCubit>();
            final homeCubit = HomeCubit(getIt<HomeUseCases>(), taskCubit);
            taskCubit.stream.firstWhere((s) => s is TaskLoadSuccess).then((_) {
              homeCubit.initialize();
            });
            return homeCubit;
          },
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeDataLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StatusProgressCard(
                  title: 'Görevler',
                  statusItems: state.summaries.map((e) {
                    final total = state.summaries
                        .fold<double>(0.0, (sum, item) => sum + item.value);
                    final percent = total > 0 ? e.value / total : 0.0;
                    return StatusItemData(
                        label: '${e.name} (${e.value.toInt()})',
                        percent: percent,
                        color: GorevDurumEnumExtension.fromName(e.name).color);
                  }).toList(),
                ),
                AppSizes.gapH12,
                StatusProgressCard(
                  title: 'Faaliyetler',
                  statusItems: state.faliyetSummaries.map((e) {
                    final total = state.faliyetSummaries
                        .fold<double>(0.0, (sum, item) => sum + item.value);
                    final percent = total > 0 ? e.value / total : 0.0;
                    return StatusItemData(
                      label: '${e.name} (${e.value.toInt()})',
                      percent: percent,
                      color: GorevDurumEnumExtension.fromName(e.name).color,
                    );
                  }).toList(),
                ),
                AppSizes.gapH12,
                // Bekleyen Görevler başlık vs...
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.task_alt,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Bekleyen Görevler',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: (Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.fontSize ??
                                          20) *
                                      ScreenUtil().scaleText,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Divider(color: Colors.grey.shade300, thickness: 1.w),
                    ],
                  ),
                ),
                // LastTasksList using state.tasks
                LastTasksList(
                  tasks: state.tasks,
                  onTap: (taskItem) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => TaskCubit(widget.taskUseCases),
                          child: TaskAddPage(task: taskItem),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else if (state is HomeError) {
            return Center(child: Text('Yüklenemedi: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
