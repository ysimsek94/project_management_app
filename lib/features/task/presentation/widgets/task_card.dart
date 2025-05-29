import 'package:flutter/material.dart';
import 'package:project_management_app/core/extensions/date_extensions.dart';
import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/gorev_durum_enum.dart';

class TaskCard extends StatelessWidget {
  final TaskListItemModel task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap!() : null,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                      Text(task.projeAdi ?? '-',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      AppSizes.gapH4,
                      Text(task.fazAdi ?? '-',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                              GorevDurumEnumExtension.fromId(task.projeFazGorev.durumId))
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      GorevDurumEnumExtension.fromId(task.projeFazGorev.durumId).label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(
                                GorevDurumEnumExtension.fromId(task.projeFazGorev.durumId)),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              AppSizes.gapH12,
              Text(task.projeFazGorev.gorev ?? '-',
                  style: Theme.of(context).textTheme.bodyLarge),
              AppSizes.gapH12,
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: Theme.of(context).primaryColor),
                  AppSizes.gapW4,
                  Text(
                      'Başlangıç: ${DateTime.tryParse(task.projeFazGorev.baslangicTarihi ?? '')?.dMy ?? '-'}',
                      style: Theme.of(context).textTheme.bodySmall),
                  AppSizes.gapW16,
                  Icon(Icons.calendar_today,
                      size: 16, color: Theme.of(context).primaryColor),
                  AppSizes.gapW4,
                  Text(
                      'Bitiş: ${DateTime.tryParse(task.projeFazGorev.tamamlanmaTarihi ?? '')?.dMy ?? '-'}',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(GorevDurumEnum durum) {
    switch (durum) {
      case GorevDurumEnum.tamamlandi:
        return Colors.green.shade600;
      case GorevDurumEnum.devamEdiyor:
        return Colors.amber.shade700;
      case GorevDurumEnum.atandi:
        return Colors.blue.shade700;
      case GorevDurumEnum.olusturuldu:
        return Colors.indigo.shade400;
      case GorevDurumEnum.iptalEdildi:
        return Colors.red.shade600;
      default:
        return Colors.grey.shade500;
    }
  }
}
