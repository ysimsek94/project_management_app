import 'package:flutter/cupertino.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_response_model.dart';
import '../../../../core/constants/app_sizes.dart';
import 'activity_card.dart';

class ActivityListView extends StatelessWidget {
  final List<FaliyetResponseModel> activities;
  final void Function(FaliyetResponseModel)? onTap;

  const ActivityListView({required this.activities, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (_, __) => AppSizes.gapH8,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return ActivityCard(
          activity: activity,
          onTap: onTap != null ? () => onTap!(activity) : null,
        );
      },
    );
  }
}