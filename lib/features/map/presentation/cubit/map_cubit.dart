import 'package:bloc/bloc.dart';

import '../../domain/usecases/map_usecases.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapUseCases _mapUseCases;

  MapCubit(this._mapUseCases) : super(MapLoading());

  Future<void> loadTasks() async {
    try {
      emit(MapLoading());
      final projectList = await _mapUseCases.getAllProjects();
      emit(MapLoaded(projectList));
    } catch (e) {
      emit(MapError('Görevler yüklenemedi: \$e'));
    }
  }
}