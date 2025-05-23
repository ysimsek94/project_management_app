import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  /// Kullanıcının profile verisini [userId] ile getirir
  Future<ProfileModel> fetchProfile(String userId);
}