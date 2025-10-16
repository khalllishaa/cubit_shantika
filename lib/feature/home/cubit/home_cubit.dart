import 'package:cubit_shantika/feature/home/cubit/home_state.dart';
import 'package:cubit_shantika/models/game_models.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GameRepository repo;
  final int pageSize;

  HomeCubit({required this.repo, this.pageSize = 20}) : super(GamesInitial());

  int _currentPage = 1;
  List<GameModel> _allGames = [];
  String _searchQuery = '';

  Future<void> fetchInitial() async {
    try {
      emit(GamesLoading());
      _currentPage = 1;
      _searchQuery = '';
      final list = await repo.fetchGames(page: _currentPage, pageSize: pageSize);
      _allGames = list;
      final hasReached = list.length < pageSize;
      emit(GamesLoaded(games: list, hasReachedMax: hasReached, page: _currentPage));
    } catch (e) {
      emit(GamesError(e.toString()));
    }
  }

  // Pagination
  Future<void> goToPage(int pageNum) async {
    try {
      emit(GamesLoading());
      _currentPage = pageNum;
      _searchQuery = '';
      final list = await repo.fetchGames(page: _currentPage, pageSize: pageSize);
      _allGames = list;
      final hasReached = list.length < pageSize;
      emit(GamesLoaded(
        games: list,
        hasReachedMax: hasReached,
        page: _currentPage,
      ));
    } catch (e) {
      emit(GamesError(e.toString()));
    }
  }

  Future<void> nextPage() async {
    final current = state;
    if (current is GamesLoaded && !current.hasReachedMax) {
      await goToPage(_currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) {
      await goToPage(_currentPage - 1);
    }
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