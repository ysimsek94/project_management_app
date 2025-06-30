import 'package:bloc/bloc.dart';
import '../../data/models/kisi_model.dart';
import '../../domain/usecases/kisi_usecases.dart';
import 'kisi_state.dart';

class KisiCubit extends Cubit<KisiState> {
  final KisiUseCases getAllKisiler;

  KisiCubit(this.getAllKisiler) : super(KisiInitial());

  Future<void> loadKisiler() async {
    emit(KisiLoading());
    try {
      final kisiler = await getAllKisiler();
      emit(KisiLoaded(kisiler));
    } catch (e) {
      emit(KisiError(e.toString()));
    }
  }
}
