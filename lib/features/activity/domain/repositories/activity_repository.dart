import 'package:project_management_app/features/activity/data/models/faliyet_gorev_request_model.dart';
import '../../data/models/faliyet_gorev_model.dart';
import '../../data/models/faliyet_response_model.dart';

abstract class ActivityRepository {
  Future<List<FaliyetResponseModel>> getActivityList(FaliyetGorevRequestModel request);
  Future<void> updateActivity(FaliyetGorevModel activity);
}