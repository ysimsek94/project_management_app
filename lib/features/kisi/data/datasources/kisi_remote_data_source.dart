import '../models/kisi_model.dart';

abstract class KisiRemoteDataSource {
  Future<List<KisiModel>> getKisiList();
}