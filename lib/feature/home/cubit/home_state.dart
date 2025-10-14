import 'package:cubit_shantika/models/game_models.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GamesInitial extends HomeState {}
class GamesLoading extends HomeState {}
class GamesLoaded extends HomeState {
  final List<GameModel> games;
  final bool hasReachedMax;
  final int page;

  GamesLoaded({required this.games, this.hasReachedMax = false, required this.page});

  GamesLoaded copyWith({List<GameModel>? games, bool? hasReachedMax, int? page}) {
    return GamesLoaded(
      games: games ?? this.games,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [games, hasReachedMax, page];
}
class GamesError extends HomeState {
  final String message;
  GamesError(this.message);
  @override
  List<Object?> get props => [message];
}
