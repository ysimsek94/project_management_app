import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/core/extensions/date_extensions.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_response_model.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/gorev_durum_enum.dart';

class ActivityCard extends StatelessWidget {
  final FaliyetResponseModel activity;
  final VoidCallback? onTap;

  const ActivityCard({super.key, required this.activity, this.onTap});

  @override
  Widget build(BuildContext context) {
    final durum = activity.faliyetGorev.durum;
    return InkWell(
      onTap: onTap != null ? () => onTap!() : null,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                      Text(activity.faliyetAdi ?? '-',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87)),

                        AppSizes.gapH4,
                      Text(activity.faliyetTuru ?? '-',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87)),

                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(durum).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      durum.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(durum),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              AppSizes.gapH12,
              Text(activity.faliyetGorev.gorev??"",
                  style: Theme.of(context).textTheme.bodyLarge),
              AppSizes.gapH12,
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: Theme.of(context).primaryColor),
                  AppSizes.gapW4,
                  Text(
                      'Başlangıç: ${DateTime.tryParse(activity.faliyetGorev.baslangicTarihi)?.dMy ?? '-'}',
                      style: Theme.of(context).textTheme.bodySmall),
                  AppSizes.gapW16,
                  Icon(Icons.calendar_today,
                      size: 16, color: Theme.of(context).primaryColor),
                  AppSizes.gapW4,
                  Text(
                      'Bitiş: ${DateTime.tryParse(activity.faliyetGorev.tamamlanmaTarihi ?? '')?.dMy ?? '-'}',
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
