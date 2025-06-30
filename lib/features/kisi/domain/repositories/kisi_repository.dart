import '../../data/models/kisi_model.dart';

abstract class KisiRepository {
  Future<List<KisiModel>> getAllKisiler();
}