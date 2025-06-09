import 'package:project_management_app/features/activity/data/models/faliyet_gorev_request_model.dart';
import '../../data/models/faliyet_gorev_model.dart';
import '../../data/models/faliyet_response_model.dart';
import '../repositories/activity_repository.dart';

class ActivityUseCases {
  final ActivityRepository repository;

  ActivityUseCases(this.repository);

  Future<List<FaliyetResponseModel>> getActivityList(FaliyetGorevRequestModel request) async {
    return await repository.getActivityList(request);
  }
  Future<void> updateActivity(FaliyetGorevModel activity) async {
    return await repository.updateActivity(activity);
  }


}
