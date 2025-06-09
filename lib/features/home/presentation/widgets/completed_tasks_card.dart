import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_management_app/core/constants/app_sizes.dart';

class StatusItemData {
  final String label;
  final double percent;
  final Color color;

  StatusItemData({
    required this.label,
    required this.percent,
    required this.color,
  });
}

class StatusProgressCard extends StatefulWidget {
  final String title;
  final List<StatusItemData> statusItems;

  const StatusProgressCard({
    Key? key,
    required this.title,
    required this.statusItems,
  }) : super(key: key);

  @override
  State<StatusProgressCard> createState() => _StatusProgressCardState();
}

class _StatusProgressCardState extends State<StatusProgressCard> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            AppSizes.gapH16,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.3,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                        sections:
                            widget.statusItems.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          final isTouched = index == touchedIndex;
                          final fontSize = isTouched ? 18.0 : 12.0;
                          final radius = isTouched ? 50.0 : 40.0;
                          return PieChartSectionData(
                            color: item.color,
                            value: item.percent * 100,
                            title: '${(item.percent * 100).round()}%',
                            radius: radius,
                            titleStyle: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: const [
                                Shadow(color: Colors.black26, blurRadius: 2)
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.statusItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: item.color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.label,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
