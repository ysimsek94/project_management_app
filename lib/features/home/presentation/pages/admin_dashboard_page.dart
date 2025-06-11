import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/admin_dashboard_cubit.dart';
import '../cubit/admin_dashboard_state.dart';
import '../../data/models/chart_dashboard_data.dart';
import '../../data/models/proje_adet_model.dart';

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendItem({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _touchedPieIndex = -1;
  int _touchedDonutIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        if (state is AdminDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AdminDashboardError) {
          return Center(child: Text('Hata: ${state.message}'));
        }

        final projeStatus = (state as AdminDashboardLoaded).projectStatusList;
        final pieData = state.chartData.series;
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusCards(List<ProjeAdetModel> items) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (ctx, i) {
          final it = items[i];
          final toplam = items.fold<int>(0, (sum, e) => sum + (e.adet ?? 0));
          final pct = toplam > 0 ? ((it.adet ?? 0) * 100.0 / toplam) : 0;
          return SizedBox(
            width: MediaQuery.of(ctx).size.width * 0.45,
            child: Card(
              color: Theme.of(ctx).colorScheme.surface,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      it.durumAdi,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
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
                          '${pct.toStringAsFixed(1)}%',
                          style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                              color: Theme.of(ctx).colorScheme.primary),
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
    final colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      AppColors.success,
    ];

    return _ChartContainer(
      title: title,
      child: AspectRatio(
        aspectRatio: 1.3,
        child: Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, resp) {
                      setState(() {
                        _touchedPieIndex =
                            resp?.touchedSection?.touchedSectionIndex ?? -1;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: data.asMap().entries.map((e) {
                    final idx = e.key;
                    final d = e.value;
                    final isTouched = idx == _touchedPieIndex;
                    return PieChartSectionData(
                      color: colors[idx % colors.length],
                      value: d.value,
                      title: d.name,
                      radius: isTouched ? 60 : 50,
                      titleStyle: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.asMap().entries.map((e) {
                final idx = e.key;
                final d = e.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _LegendItem(
                    color: colors[idx % colors.length],
                    text: '${d.name} (${d.value.toInt()})',
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonutChart(String title, ProjectVsActivity donut) {
    final segments = [
      PieData(name: 'Proje', value: donut.proje.toDouble()),
      PieData(name: 'Faaliyet', value: donut.faaliyet.toDouble()),
    ];
    final colors = [
      Theme.of(context).colorScheme.primary,
      AppColors.success,
    ];

    return _ChartContainer(
      title: title,
      child: AspectRatio(
        aspectRatio: 1.3,
        child: Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, resp) {
                      setState(() {
                        _touchedDonutIndex =
                            resp?.touchedSection?.touchedSectionIndex ?? -1;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                  sections: segments.asMap().entries.map((e) {
                    final idx = e.key;
                    final d = e.value;
                    final isTouched = idx == _touchedDonutIndex;
                    return PieChartSectionData(
                      color: colors[idx],
                      value: d.value,
                      title: '${d.value.toInt()}%',
                      radius: isTouched ? 60 : 50,
                      titleStyle:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: segments.asMap().entries.map((e) {
                final idx = e.key;
                final d = e.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _LegendItem(
                    color: colors[idx],
                    text: '${d.name} (${d.value.toInt()})',
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartContainer extends StatelessWidget {
  final String title;
  final Widget child;
  const _ChartContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    )),

            child,
          ],
        ),
      ),
    );
  }
}
