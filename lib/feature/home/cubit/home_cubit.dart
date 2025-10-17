import 'package:cubit_shantika/config/constant.dart';
import 'package:cubit_shantika/feature/home/cubit/home_state.dart';
import 'package:cubit_shantika/models/game_models.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GameRepository repo;
  final int pageSize;

  HomeCubit({required this.repo})
      : pageSize = AppConfig.defaultPageSize,
        super(GamesInitial());

  int _currentPage = 5;
  List<GameModel> _allGames = [];
  String _searchQuery = '';
  bool _isLoadingMore = false;

  Future<void> fetchInitial() async {
    emit(GamesLoading());
    _currentPage = 1;
    final list = await repo.fetchGames(page: _currentPage);
    _allGames = list;
    emit(GamesLoaded(
      games: _allGames,
      hasReachedMax: list.isEmpty,
      page: _currentPage,
    ));
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! GamesLoaded || current.hasReachedMax || _isLoadingMore) return;

    _isLoadingMore = true;
    _currentPage++;

    try {
      final newList = await repo.fetchGames(page: _currentPage);
      if (newList.isEmpty) {
        emit(current.copyWith(hasReachedMax: true));
      } else {
        _allGames.addAll(newList);
        emit(current.copyWith(
          games: List<GameModel>.from(_allGames),
          hasReachedMax: newList.length < 50,
          page: _currentPage,
        ));
      }
    } catch (e) {
      emit(GamesError(e.toString()));
    }

    _isLoadingMore = false;
  }

  // Search function
  void searchGames(String query) {
    _searchQuery = query.toLowerCase();
    final current = state;

    if (current is GamesLoaded) {
      List<GameModel> filtered;

      if (_searchQuery.isEmpty) {
        filtered = _allGames;
      } else {
        filtered = _allGames
            .where((game) => game.name.toLowerCase().contains(_searchQuery))
            .toList();
      }

      emit(current.copyWith(games: filtered));
    }
  }

  Future<void> refresh() async => fetchInitial();
}