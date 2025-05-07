part of 'profile_cubit.dart';

/// Profil ekranının alabileceği durumlar
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Başlangıç durumu
class ProfileInitial extends ProfileState {}

/// API çağrısı bekleniyor
class ProfileLoading extends ProfileState {}

/// API çağrısı başarılı, [profile] verisi var
class ProfileLoaded extends ProfileState {
  final Profile profile;
  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// API hata döndü veya beklenmeyen bir hata oldu
class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}