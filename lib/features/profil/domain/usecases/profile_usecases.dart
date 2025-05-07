import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class ProfileUseCase {
  final ProfileRepository repository;
  ProfileUseCase(this.repository);

  Future<Profile> getProfile(String userId) async {
    return await repository.getProfile(userId);
  }
}
