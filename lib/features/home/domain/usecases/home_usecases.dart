// lib/features/home/domain/usecases/home_usecases.dart
import '../repositories/home_repository.dart';
import '../../data/models/status_summary_model.dart';

class HomeUseCases {
  final HomeRepository repository;
  HomeUseCases(this.repository);

  /// Durum adetleri için özet veriyi getirir
  Future<List<StatusSummaryModel>> getStatusSummary() =>
      repository.getStatusSummary();

  ///Faliyet Durum adetleri için özet veriyi getirir
  Future<List<StatusSummaryModel>> getFaliyetStatusSummary() =>
      repository.getFaliyetStatusSummary();
}