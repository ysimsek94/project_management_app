import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/profile.dart';
import '../../domain/usecases/profile_usecases.dart';


part 'profile_state.dart';

/// Profil verisini yüklemek için Cubit
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileUseCase profileUseCase;
  ProfileCubit(this.profileUseCase) : super(ProfileInitial());

  /// Login sonrası SharedPreferences’ta tuttuğun userId’yi buraya
  /// verip çağırdığında API’den profil bilgisini çeker.
  void getProfile(String userId) async {
    emit(ProfileLoading());
    try {
      final profile = await profileUseCase.getProfile(userId);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Bir hata oluştu: ${e.toString()}'));
    }
  }
}