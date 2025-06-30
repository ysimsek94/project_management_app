import '../repositories/kisi_repository.dart';
import '../../data/models/kisi_model.dart';

class KisiUseCases {
  final KisiRepository repository;
  KisiUseCases(this.repository);

  Future<List<KisiModel>> call() async {
    return await repository.getAllKisiler();
  }
}