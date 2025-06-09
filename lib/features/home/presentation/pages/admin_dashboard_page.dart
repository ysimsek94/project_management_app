import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/admin_dashboard_cubit.dart';
import '../cubit/admin_dashboard_state.dart';
import '../../data/models/chart_dashboard_data.dart';
import '../../data/models/proje_adet_model.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (ctx, state) {
        if (state is AdminDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AdminDashboardError) {
          return Center(child: Text('Hata: ${state.message}'));
        } else if (state is AdminDashboardLoaded) {
          final projeStatus = state.projectStatusList;
          final pieData = state.chartData.series;
          final barData = state.activityByDept;
          final donut = state.projectVsActivity;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatusCards(projeStatus),
                const SizedBox(height: 16),
                _buildPieChart('Proje Tutar Dağılımı', pieData),
                const SizedBox(height: 16),
                _buildDonutChart('Proje vs Faaliyet Adet', donut),
                // const SizedBox(height: 16),
                // _buildBarChart('Departman Bazında Faaliyet Durumu', barData),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatusCards(List<ProjeAdetModel> items) {
    return SizedBox(
      height: 90, // adjust as needed
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemBuilder: (ctx, i) {
          final it = items[i];
          final toplamAdet = items.fold<int>(0, (sum, e) => sum + (e.adet ?? 0));
          final yuzdeOrani = toplamAdet > 0 ? (((it.adet ?? 0) * 100.0) / toplamAdet) : 0;
          return SizedBox(
            width: MediaQuery.of(ctx).size.width * 0.4,
            child: Card(
              color: Theme.of(ctx).colorScheme.surface,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      it.durumAdi,
                      style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                            color: Theme.of(ctx).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${it.adet}',
                          style: Theme.of(ctx).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        Text(
                          '${yuzdeOrani.toStringAsFixed(1)}%',
                          style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                                color: Theme.of(ctx).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPieChart(String title, List<PieData> data) {
    final chartColors = [AppColors.primary, AppColors.primary, AppColors.secondary];
    return _ChartContainer(
      title: title,
      child: SizedBox(
        height: 175,
        child: PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 0,
            sections: data.asMap().entries.map((e) {
              final idx = e.key;
              final d = e.value;
              return PieChartSectionData(
                value: d.value,
                title: d.name,
                radius: 60,
                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                color: chartColors[idx % chartColors.length],
                // No shadow for minimal look
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDonutChart(String title, ProjectVsActivity donut) {
    final segments = [
      PieData(name: 'Proje', value: donut.proje.toDouble()),
      PieData(name: 'Faaliyet', value: donut.faaliyet.toDouble()),
    ];
    final chartColors = [AppColors.primary, AppColors.success, AppColors.secondary];
    return _ChartContainer(
      title: title,
      child: SizedBox(
        height: 175,
        child: PieChart(
          PieChartData(
            sectionsSpace: 4,
            centerSpaceRadius: 40,
            sections: segments.asMap().entries.map((e) {
              final idx = e.key;
              final d = e.value;
              return PieChartSectionData(
                value: d.value,
                title: '${d.value.toInt()}',
                radius: 50,
                titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                color: chartColors[idx % chartColors.length],
                // No shadow for minimal look
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Widget _buildBarChart(String title, List<FaliyetLine> data) {
  //   final grouped = <String, Map<String, int>>{};
  //   for (var item in data) {
  //     final dept = item.departmanAdi;
  //     final tamamlandi = item. == true ? 1 : 0;
  //     final tamamlanmadi = item.faliyet.tamamlandi == false ? 1 : 0;
  //
  //     grouped.update(dept, (current) {
  //       return {
  //         'tamamlandi': current['tamamlandi']! + tamamlandi,
  //         'tamamlanmadi': current['tamamlanmadi']! + tamamlanmadi,
  //       };
  //     }, ifAbsent: () {
  //       return {
  //         'tamamlandi': tamamlandi,
  //         'tamamlanmadi': tamamlanmadi,
  //       };
  //     });
  //   }
  //
  //   final departments = grouped.keys.toList();
  //   return _ChartContainer(
  //     title: title,
  //     child: SizedBox(
  //       height: 240,
  //       child: BarChart(
  //         BarChartData(
  //           barGroups: grouped.entries.toList().asMap().entries.map((entry) {
  //             final i = entry.key;
  //             final e = entry.value;
  //             return BarChartGroupData(
  //               x: i,
  //               barsSpace: 4,
  //               barRods: [
  //                 BarChartRodData(toY: e.value['tamamlandi']!.toDouble(), width: 8),
  //                 BarChartRodData(toY: e.value['tamamlanmadi']!.toDouble(), width: 8),
  //               ],
  //             );
  //           }).toList(),
  //           titlesData: FlTitlesData(
  //             bottomTitles: AxisTitles(
  //               sideTitles: SideTitles(
  //                 showTitles: true,
  //                 getTitlesWidget: (value, meta) {
  //                   final idx = value.toInt();
  //                   if (idx < 0 || idx >= departments.length) return const SizedBox();
  //                   return SideTitleWidget(
  //                     axisSide: meta.axisSide,
  //                     child: Text(
  //                       departments[idx],
  //                       style: const TextStyle(fontSize: 10),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //             leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
  //             rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //             topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //           ),
  //           gridData: FlGridData(show: false),
  //           borderData: FlBorderData(show: false),
  //           alignment: BarChartAlignment.spaceAround,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class _ChartContainer extends StatelessWidget {
  final String title;
  final Widget child;
  const _ChartContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          )),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}