

import '../../domain/repositories/kisi_repository.dart';
import '../datasources/kisi_remote_data_source.dart';
import '../models/kisi_model.dart';

class KisiRepositoryImpl implements KisiRepository {
  final KisiRemoteDataSource remoteDataSource;
  List<KisiModel>? _cache;

  KisiRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<KisiModel>> getAllKisiler() async {
    if (_cache != null) {
      return _cache!;
    }

    final result = await remoteDataSource.getKisiList();
    _cache = result;
    return result;
  }
}