import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Profile> getProfile(String userId) async {
    return await remoteDataSource.fetchProfile(userId);
  }
}