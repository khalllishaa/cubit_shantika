import 'package:cubit_shantika/feature/home/cubit/home_state.dart';
import 'package:cubit_shantika/models/game_models.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GameRepository repo;
  final int pageSize;
  HomeCubit({required this.repo, this.pageSize = 20}) : super(GamesInitial());

  int _currentPage = 1;

  Future<void> fetchInitial() async {
    try {
      emit(GamesLoading());
      _currentPage = 1;
      final list = await repo.fetchGames(page: _currentPage, pageSize: pageSize);
      final hasReached = list.length < pageSize;
      emit(GamesLoaded(games: list, hasReachedMax: hasReached, page: _currentPage));
    } catch (e) {
      emit(GamesError(e.toString()));
    }
  }

  Future<void> fetchNextPage() async {
    final current = state;
    if (current is GamesLoaded && !current.hasReachedMax) {
      try {
        final nextPage = current.page + 1;
        final more = await repo.fetchGames(page: nextPage, pageSize: pageSize);
        final hasReached = more.length < pageSize;
        final combined = List<GameModel>.from(current.games)..addAll(more);
        emit(current.copyWith(games: combined, hasReachedMax: hasReached, page: nextPage));
      } catch (e) {
        emit(GamesError(e.toString()));
      }
    }
  }

  Future<void> refresh() async => fetchInitial();
}
