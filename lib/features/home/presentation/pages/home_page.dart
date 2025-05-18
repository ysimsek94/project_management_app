import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/constants/app_sizes.dart';
import 'package:project_management_app/features/project/domain/usecases/get_projects_usecase.dart';
import 'package:project_management_app/features/task/domain/usecases/task_usecases.dart';
import 'package:project_management_app/features/task/presentation/pages/task_list_page.dart';
import 'package:project_management_app/injection.dart';
import '../../../../core/preferences/AppPreferences.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../profile/domain/usecases/profile_usecases.dart';
import '../../../profile/presentation/bloc/profile_cubit.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../task/presentation/bloc/task_cubit.dart';
import 'package:project_management_app/core/extensions/theme_extensions.dart';
import 'package:project_management_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:project_management_app/core/extensions/role_extensions.dart';
import '../../../task/presentation/widgets/last_task_list.dart';
import '../../presentation//widgets/completed_tasks_card.dart';
import '../../presentation//widgets/projects_performance_card.dart';
import '../../presentation/widgets/weekly_request_task_card.dart';

class HomePage extends StatefulWidget {
  final GetProjectsUseCase getProjectsUseCase;
  final TaskUseCases taskUseCases;

  const HomePage({
    super.key,
    required this.getProjectsUseCase,
    required this.taskUseCases,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  bool get isAdmin => context.hasRole('admin');

  /// Sayfa içeriği ve alt menülerin yönetimi
  @override
  Widget build(BuildContext context) {
    // Alt sekme sayfalarını ve menü öğelerini birlikte oluştur (senkronizasyon için)
    final List<Map<String, dynamic>> navConfig = [
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
          child: TaskListPage(
            taskUsecases: widget.taskUseCases,
          ),
        ),
        'item': const AppBottomNavBarItem(
          icon: Icons.list_alt_outlined,
          label: 'Görevler',
        ),
      },

        {
          'page': BlocProvider(
            create: (_) => ProfileCubit(getIt<ProfileUseCase>()),
            child: const ProfilePage(),
          ),
          'item': const AppBottomNavBarItem(
            icon: Icons.person,
            label: 'Profil',
          ),
        }

    ];

    final List<Widget> pages =
        navConfig.map<Widget>((e) => e['page'] as Widget).toList();
    final List<AppBottomNavBarItem> items = navConfig
        .map<AppBottomNavBarItem>((e) => e['item'] as AppBottomNavBarItem)
        .toList();

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: items,
      ),
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
              AppSizes.gapH24,
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
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
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.theme.primaryColor, Colors.white10],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  /// Profil ve kullanıcı başlığı
  Widget _buildHeaderSection() {
    final adSoyad = (AppPreferences.adSoyad ?? '').trim();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.person, size: 45, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Text(
            adSoyad.isNotEmpty ? adSoyad : "Kullanıcı",
            style: AppTypography.bold10().copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Gösterge paneli kartları (tamamlanan görevler, performans, haftalık istekler)
  Widget _buildDashboardCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (context.hasRole('user'))
          CompletedTasksCard(
            statusItems: [
              StatusItemData(
                  label: "Tamamlandı", percent: 0.73, color: Colors.green),
              StatusItemData(
                  label: "Bekliyor", percent: 0.18, color: Colors.orange),
              StatusItemData(
                  label: "İptal Edildi", percent: 0.09, color: Colors.red),
            ],
          ),
        AppSizes.gapH16,
        if (isAdmin)
          ProjectPerformanceCard(
            performanceData: [
              ProjectPerformanceData(
                  label: 'Proj 1', percent: 80, color: Colors.blue),
              ProjectPerformanceData(
                  label: 'Proj 2', percent: 55, color: Colors.orange),
              ProjectPerformanceData(
                  label: 'Proj 3', percent: 60, color: Colors.green),
              ProjectPerformanceData(
                  label: 'Proj 4', percent: 45, color: Colors.blueGrey),
              ProjectPerformanceData(
                  label: 'Proj 5', percent: 89, color: Colors.redAccent),
              ProjectPerformanceData(
                  label: 'Proj 6', percent: 96, color: Colors.teal),
            ],
          ),
        AppSizes.gapH16,
        if (isAdmin)
        WeeklyRequestChartCard(
          weeklyData: const [8, 10, 14, 15, 13, 10, 9],
          labels: const ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'],
        ),

        BlocProvider(
          create: (_) => TaskCubit(getIt<TaskUseCases>())..fetchLastTasks(),
          child: const LastTasksList(),
        ),

      ],
    );
  }
}
