import '../../data/models/status_summary_model.dart';

abstract class HomeRepository {
  Future<List<StatusSummaryModel>> getStatusSummary();
  Future<List<StatusSummaryModel>> getFaliyetStatusSummary();
}