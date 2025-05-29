part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

/// Dashboard görevleri yükleniyor
class DashboardLoading extends HomeState {}

/// Dashboard görevleri yüklendi
class HomeTasksLoaded extends HomeState {
  final List<DashboardTaskModel> tasks;
  HomeTasksLoaded(this.tasks);
}

/// Durum özetleri yükleniyor
class SummariesLoading extends HomeState {}

/// Durum özetleri yüklendi
class HomeSummariesLoaded extends HomeState {
  final List<StatusSummaryModel> summaries;
  HomeSummariesLoaded(this.summaries);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}