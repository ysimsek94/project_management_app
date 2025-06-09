import '../datasources/home_remote_data_source.dart';
import '../models/status_summary_model.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  HomeRepositoryImpl(this.remoteDataSource);


  @override
  Future<List<StatusSummaryModel>> getStatusSummary() =>
      remoteDataSource.fetchStatusSummary();

  @override
  Future<List<StatusSummaryModel>> getFaliyetStatusSummary() =>
      remoteDataSource.fetchFaliyetStatusSummary();
}