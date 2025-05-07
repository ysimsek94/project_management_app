import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:project_management_app/features/project/domain/usecases/get_projects_usecase.dart';
import 'package:project_management_app/features/task/domain/usecases/task_usecases.dart';
import 'package:project_management_app/features/task/presentation/pages/task_list_page.dart';

import 'package:project_management_app/injection.dart';

import '../../../../core/preferences/AppPreferences.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../profil/domain/usecases/profile_usecases.dart';
import '../../../profil/presentation/bloc/profile_cubit.dart';
import '../../../profil/presentation/pages/profile_page.dart';
import '../../../task/presentation/bloc/task_cubit.dart';
import 'package:project_management_app/core/extensions/theme_extensions.dart';
import 'package:project_management_app/core/widgets/app_bottom_nav_bar.dart';
 // Ensure this import exists

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

  @override
  Widget build(BuildContext context) {
    /// Uygulamadaki alt sekmelerin içeriklerini temsil eden sayfa listesi
    final List<Widget> pages = [
      /// Ana gösterge paneli - kullanıcıya genel bir bakış sunar
      _buildHomeContent(),

      /// Görev listesi sayfası - projelere göre görevleri gösterir
      BlocProvider(
        create: (_) => TaskCubit(widget.taskUseCases),
        child: TaskListPage(
          taskUsecases: widget.taskUseCases,
        ),
      ),
      // Profile sekmesi
      BlocProvider(
        create: (_) => ProfileCubit(getIt<ProfileUseCase>()),
        child: const ProfilePage(),
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          AppBottomNavBarItem(icon: Icons.home_outlined, label: 'Ana Sayfa'),
          AppBottomNavBarItem(icon: Icons.list_alt_outlined, label: 'Görevler'),
          AppBottomNavBarItem(icon: Icons.person, label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [context.theme.primaryColor, Colors.white10],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.person, size: 45, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      AppPreferences.adSoyad ?? "Ana Sayfa",
                      style: AppTypography.bold10().copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CompletedTasksCard(),
                      const SizedBox(height: 16),
                      _ProjectPerformanceCard(),
                      const SizedBox(height: 16),
                      // Haftalık Talep Sayısı Chart
                       _WeeklyRequestChartCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class _CompletedTasksCard extends StatelessWidget {
  const _CompletedTasksCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Tamamlanan Görevler",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatusItem(
                    label: "Tamamlandı", percent: 0.72, color: Colors.green),
                _StatusItem(
                    label: "Bekliyor", percent: 0.18, color: Colors.orange),
                _StatusItem(
                    label: "İptal Edildi", percent: 0.10, color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectPerformanceCard extends StatelessWidget {
  const _ProjectPerformanceCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Projelerin Performansı",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 20,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Proj 1');
                            case 1:
                              return const Text('Proj 2');
                            case 2:
                              return const Text('Proj 3');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: 80, color: Colors.blue, width: 18)
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: 45, color: Colors.orange, width: 18)
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(toY: 60, color: Colors.green, width: 18)
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;

  const _StatusItem({
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 8,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text("${(percent * 100).toInt()}%",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

/// Haftalık Talep Sayısı kartı için ayrı widget
class _WeeklyRequestChartCard extends StatelessWidget {
  const _WeeklyRequestChartCard({Key? key}) : super(key: key);

  /// Geçici (mock) haftalık talep verisi
  final List<double> weeklyData = const [8, 10, 14, 15, 13, 10, 9];

  /// Bar chart için bar gruplarını oluşturan fonksiyon
  List<BarChartGroupData> getBarGroups(List<double> data) {
    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index],
            width: 12,
            gradient: const LinearGradient(
              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            rodStackItems: [
              BarChartRodStackItem(
                0,
                data[index],
                Colors.transparent,
              ),
            ],
            borderRadius: BorderRadius.circular(4),
          )
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  /// Alt başlıklar için özel widget fonksiyonu
  Widget getBottomTitleWidget(double value, TitleMeta meta, List<double> data) {
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final int index = value.toInt();
    if (index < 0 || index >= data.length) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        days[index],
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// BarChartData yapılandırması
  BarChartData buildBarChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 20,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.toStringAsFixed(1)}',
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) => getBottomTitleWidget(value, meta, weeklyData),
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: getBarGroups(weeklyData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Haftalık Talep Sayısı",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(buildBarChartData()),
            ),
          ],
        ),
      ),
    );
  }
}

BarChartGroupData makeBarGroup(int x, double y) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        width: 12,
        borderRadius: BorderRadius.circular(4),
        gradient: const LinearGradient(
          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    ],
  );
}
