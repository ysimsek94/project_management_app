import 'package:project_management_app/features/activity/data/models/faliyet_gorev_request_model.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_response_model.dart';

import '../models/faliyet_gorev_model.dart';

abstract class ActivityRemoteDataSource {
  Future<List<FaliyetResponseModel>> getActivityList(FaliyetGorevRequestModel faliyetGorevRequestModel);
  Future<void> updateActivity(FaliyetGorevModel activity);
}