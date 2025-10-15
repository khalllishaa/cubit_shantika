import 'package:cubit_shantika/config/service_locator.dart';
import 'package:cubit_shantika/feature/detail/detail_page.dart';
import 'package:cubit_shantika/feature/home/cubit/home_cubit.dart';
import 'package:cubit_shantika/feature/home/cubit/home_state.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        repo: getIt<GameRepository>(),
      )..fetchInitial(),
      child: Scaffold(
        appBar: AppBar(title: Text("Games")),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is GamesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GamesLoaded) {
              return ListView.builder(
                itemCount: state.games.length,
                itemBuilder: (context, index) {
                  final game = state.games[index];
                  return ListTile(
                    leading: game.backgroundImage != null
                        ? Image.network(
                      game.backgroundImage!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.image_not_supported),
                    title: Text(game.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(gameId: game.id),
                        ),
                      );
                    },
                    subtitle: Text("Rating: ${game.rating ?? '-'}"),
                  );
                },
              );
            }

            if (state is GamesError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
