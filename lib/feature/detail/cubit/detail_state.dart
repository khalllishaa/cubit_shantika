import 'package:equatable/equatable.dart';
import 'package:cubit_shantika/models/game_models.dart';

abstract class DetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final GameModel game;
  DetailLoaded(this.game);

  @override
  List<Object?> get props => [game];
}

class DetailError extends DetailState {
  final String message;
  DetailError(this.message);

  @override
  List<Object?> get props => [message];
}
