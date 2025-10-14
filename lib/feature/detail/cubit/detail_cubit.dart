import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final GameRepository repo;
  DetailCubit(this.repo) : super(DetailInitial());

  Future<void> fetchDetail(int id) async {
    try {
      emit(DetailLoading());
      final game = await repo.getDetail(id);
      emit(DetailLoaded(game));
    } catch (e) {
      emit(DetailError(e.toString()));
    }
  }
}
