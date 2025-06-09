

import 'package:equatable/equatable.dart';
import '../../data/models/proje_adet_model.dart';
import '../../data/models/chart_dashboard_data.dart';
import '../../data/models/faliyet_line.dart';

/// Base state for Admin Dashboard
abstract class AdminDashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Loading state
class AdminDashboardLoading extends AdminDashboardState {}

/// Error state
class AdminDashboardError extends AdminDashboardState {
  final String message;
  AdminDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Loaded state with all dashboard data
class AdminDashboardLoaded extends AdminDashboardState {
  /// List of project status counts for the cards
  final List<ProjeAdetModel> projectStatusList;

  /// Chart data for the pie chart
  final ChartDashboardData chartData;

  /// List of activity status grouped by department for bar chart
  final List<FaliyetLine> activityByDept;

  /// Summary counts for project vs. activity donut chart
  final ProjectVsActivity projectVsActivity;

  AdminDashboardLoaded({
    required this.projectStatusList,
    required this.chartData,
    required this.activityByDept,
    required this.projectVsActivity,
  });

  @override
  List<Object?> get props => [
        projectStatusList,
        chartData,
        activityByDept,
        projectVsActivity,
      ];
}