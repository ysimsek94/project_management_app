import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:project_management_app/features/project/domain/usecases/get_projects_usecase.dart';
import 'package:project_management_app/features/task/domain/usecases/get_tasks_by_project_id_usecase.dart';
import 'package:project_management_app/features/task/domain/usecases/task_usecases.dart';
import 'package:project_management_app/features/task/presentation/pages/task_list_page.dart';

import '../../../../core/preferences/AppPreferences.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../task/presentation/bloc/task_cubit.dart';
import 'package:project_management_app/core/extensions/extensions.dart';
import 'package:project_management_app/core/widgets/app_bottom_nav_bar.dart';
 // Ensure this import exists

class HomePage extends StatefulWidget {
  final GetProjectsUseCase getProjectsUseCase;
  final GetTasksByProjectIdUseCase getTasksUseCase;
  final TaskUseCases taskUseCases;

  const HomePage({
    super.key,
    required this.getProjectsUseCase,
    required this.getTasksUseCase,
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
          getTasksUseCase: widget.getTasksUseCase,
          taskUsecases: widget.taskUseCases,
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: pages[_currentIndex],
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          AppBottomNavBarItem(icon: Icons.home_outlined, label: 'Ana Sayfa'),
          AppBottomNavBarItem(icon: Icons.list_alt_outlined, label: 'Görevler'),
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
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7B61FF), Color(0xFF4DA6FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.white, size: 26),
                      ),
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
                    children: const [
                      _CompletedTasksCard(),
                      SizedBox(height: 16),
                      _ProjectPerformanceCard(),
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
