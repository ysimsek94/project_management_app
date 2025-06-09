import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/core/extensions/date_extensions.dart';
import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';
import '../../../../core/constants/gorev_durum_enum.dart';

class TaskCard extends StatelessWidget {
  final TaskListItemModel task;
  final VoidCallback? onTap;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: theme.cardTheme.color,
        elevation:5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First row: Project Name, Phase Name, Status Chip
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _ProjectInfo(
                      projectName: task.projeAdi ?? '-',
                      phaseName: task.fazAdi ?? '-',
                      textTheme: textTheme,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _StatusChip(
                    durum: task.projeFazGorev.durum,
                    theme: theme,
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Task Title
              Text(
                task.projeFazGorev.gorev ?? '-',
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey[800], height: 1.4),
              ),

              SizedBox(height: 12.h),

              // Dates Row
              _DateRow(
                baslangic: task.projeFazGorev.baslangicTarihi,
                bitis: task.projeFazGorev.tamamlanmaTarihi,
                textTheme: textTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget to display project name & phase name.
class _ProjectInfo extends StatelessWidget {
  final String projectName;
  final String phaseName;
  final TextTheme textTheme;

  const _ProjectInfo({
    Key? key,
    required this.projectName,
    required this.phaseName,
    required this.textTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          projectName,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 4.h),
        Text(
          phaseName,
          style: textTheme.bodyMedium?.copyWith(color: Colors.grey[800], height: 1.4),
        ),
      ],
    );
  }
}

/// Chip widget to display task status.
class _StatusChip extends StatelessWidget {
  final GorevDurumEnum durum;
  final ThemeData theme;

  const _StatusChip({
    Key? key,
    required this.durum,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(durum);
    return Chip(
      backgroundColor: color.withOpacity(0.2),
      label: Text(
        durum.label,
        style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    );
  }

  Color _getStatusColor(GorevDurumEnum durum) {
    switch (durum) {
      case GorevDurumEnum.tamamlandi:
        return Colors.green.shade600;
      case GorevDurumEnum.devamEdiyor:
        return Colors.amber.shade700;
      case GorevDurumEnum.atandi:
        return theme.colorScheme.primary;
      case GorevDurumEnum.olusturuldu:
        return Colors.indigo.shade400;
      case GorevDurumEnum.iptalEdildi:
        return Colors.red.shade600;
      default:
        return Colors.grey.shade500;
    }
  }
}

/// Row widget to display start and end dates with icons.
class _DateRow extends StatelessWidget {
  final String? baslangic;
  final String? bitis;
  final TextTheme textTheme;

  const _DateRow({
    Key? key,
    required this.baslangic,
    required this.bitis,
    required this.textTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startDate = DateTime.tryParse(baslangic ?? '');
    final endDate = DateTime.tryParse(bitis ?? '');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  'Başlangıç: ${startDate?.dMy ?? '-'}',
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey[700], height: 1.4),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  'Bitiş: ${endDate?.dMy ?? '-'}',
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey[700], height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
