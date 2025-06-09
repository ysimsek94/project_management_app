import '../models/status_summary_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<StatusSummaryModel>> fetchStatusSummary();
  Future<List<StatusSummaryModel>> fetchFaliyetStatusSummary();

}
