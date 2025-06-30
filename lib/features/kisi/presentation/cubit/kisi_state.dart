import 'package:equatable/equatable.dart';
import '../../data/models/kisi_model.dart';

abstract class KisiState extends Equatable {
  const KisiState();

  @override
  List<Object?> get props => [];
}

class KisiInitial extends KisiState {}

class KisiLoading extends KisiState {}

class KisiLoaded extends KisiState {
  final List<KisiModel> kisiler;

  const KisiLoaded(this.kisiler);

  @override
  List<Object?> get props => [kisiler];
}

class KisiError extends KisiState {
  final String message;

  const KisiError(this.message);

  @override
  List<Object?> get props => [message];
}
