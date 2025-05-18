import 'package:flutter/material.dart';
import 'package:project_management_app/core/extensions/date_extensions.dart';
import 'package:project_management_app/core/extensions/string_extensions.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap!() : null,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Proje, faz ve durum
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Proje Adı", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      AppSizes.gapH4,
                      Text("Faz Adı", style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(task.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.status.capitalize(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(task.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              AppSizes.gapH12,
              Text(task.title, style: Theme.of(context).textTheme.bodyLarge),
              AppSizes.gapH12,
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Theme.of(context).primaryColor),
                  AppSizes.gapW4,
                  Text('Başlangıç: ${DateTime.now().yMd}', style: Theme.of(context).textTheme.bodySmall),
                  AppSizes.gapW16,
                  Icon(Icons.calendar_today, size: 16, color: Theme.of(context).primaryColor),
                  AppSizes.gapW4,
                  Text('Bitiş: ${DateTime.now().yMd}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'tamamlandı':
        return Colors.green;
      case 'devam ediyor':
        return Colors.orange;
      case 'yapılacak':
        return Colors.blue;
      default:
        return Colors.redAccent;
    }
  }
}