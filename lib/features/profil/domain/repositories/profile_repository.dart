import '../entities/profile.dart';

abstract class ProfileRepository {
  /// [userId] ile Profil bilgisini getirir
  Future<Profile> getProfile(String userId);
}