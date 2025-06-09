
import 'package:project_management_app/features/activity/data/models/faliyet_gorev_model.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_gorev_request_model.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_response_model.dart';

import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_remote_data_source.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource remoteDataSource;

  ActivityRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<FaliyetResponseModel>> getActivityList(FaliyetGorevRequestModel request) async {
    var activityList = await remoteDataSource.getActivityList(request);
    return activityList;
  }

  @override
  Future<void> updateActivity(FaliyetGorevModel activity) {
    return remoteDataSource.updateActivity(activity);
  }

}
