import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_gorev_request_model.dart';

import '../../../../core/constants/gorev_durum_enum.dart';
import '../../../../core/preferences/AppPreferences.dart';
import '../../data/models/faliyet_gorev_model.dart';
import '../../data/models/faliyet_response_model.dart';
import '../../domain/usecases/activity_usecases.dart';
import 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final ActivityUseCases _activityUseCases;
  List<FaliyetResponseModel> _allActivities = [];

  ActivityCubit(this._activityUseCases) : super(ActivityInitial());

  Future<void> updateActivity(FaliyetGorevModel activity) async {
    emit(ActivityOperationInProgress());
    try {
      await _activityUseCases.updateActivity(activity);
      emit(ActivityUpdateSuccess("Görev Güncellendi."));
    } catch (e) {
      emit(ActivityFailure('Görev güncellenemedi: ${e.toString()}'));
    }
  }

  Future<void> getActivityList(FaliyetGorevRequestModel request) async {
    emit(ActivityLoadInProgress());
    try {
      var activities = await _activityUseCases.getActivityList(request);
      _allActivities = activities; // tam listeyi saklıyoruz
      emit(ActivityLoadSuccess(_allActivities)); // ekrana tam listeyi basıyoruz
    } catch (e) {
      emit(ActivityFailure('Görevler yüklenemedi: $e'));
    }
  }

  void search(String query) {
    // Küçük/büyük harf duyarsız filtre
    final filtered = _allActivities
        .where((t) => (t.faliyetGorev.gorev ?? '')
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    emit(ActivityLoadSuccess(filtered));
  }
}
