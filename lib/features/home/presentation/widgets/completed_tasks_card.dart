import 'package:flutter/material.dart';

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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Görevlerim',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: statusItems
                  .map((item) => _StatusItem(
                        label: item.label,
                        percent: item.percent,
                        color: item.color,
                      ))
                  .toList(),
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
    Key? key,
    required this.label,
    required this.percent,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          width: 48,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: percent,
                color: color,
                backgroundColor: color.withOpacity(0.2),
                strokeWidth: 6,
              ),
              Center(
                child: Text(
                  '${(percent * 100).round()}%',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}