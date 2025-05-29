import 'package:flutter/material.dart';
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

class CompletedTasksCard extends StatelessWidget {
  final List<StatusItemData> statusItems;

  const CompletedTasksCard({
    Key? key,
    required this.statusItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Görevlerim',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          // Progress list design
          Column(
            children: statusItems.map((item) {
              final count = (item.percent * 100).round();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        '${item.label}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                   AppSizes.gapW12,
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: item.percent,
                          minHeight: 12,
                          color: item.color,
                          backgroundColor: item.color.withOpacity(0.2),
                        ),
                      ),
                    ),
                    AppSizes.gapW4,
                    Text(
                      '${(item.percent * 100).round()}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
