part of 'home_cubit.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Tüm veriler yüklenirken gösterilecek durum
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Dashboard görevleri, durum özetleri ve faaliyet özetleri yüklendi
class HomeDataLoaded extends HomeState {
  final List<TaskListItemModel> tasks;
  final List<StatusSummaryModel> summaries;
  final List<StatusSummaryModel> faliyetSummaries;
  const HomeDataLoaded(this.tasks, this.summaries,this.faliyetSummaries);
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}