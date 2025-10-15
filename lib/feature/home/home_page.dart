import 'package:cubit_shantika/config/service_locator.dart';
import 'package:cubit_shantika/feature/detail/detail_page.dart';
import 'package:cubit_shantika/feature/favourite/cubit/favouite_cubit.dart';
import 'package:cubit_shantika/feature/favourite/cubit/favourite_state.dart';
import 'package:cubit_shantika/feature/home/cubit/home_cubit.dart';
import 'package:cubit_shantika/feature/home/cubit/home_state.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(
            repo: getIt<GameRepository>(),
          )..fetchInitial(),
        ),
        BlocProvider(
          create: (_) => FavoriteCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Games"),
            ),
            body: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is GamesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GamesLoaded) {
                  return BlocListener<FavoriteCubit, FavoriteState>(
                    listener: (context, favState) {
                      // Trigger rebuild when favorite changes
                    },
                    child: ListView.builder(
                      itemCount: state.games.length,
                      itemBuilder: (context, index) {
                        final game = state.games[index];
                        return _GameListTile(game: game);
                      },
                    ),
                  );
                }

                if (state is GamesError) {
                  return Center(child: Text("Error: ${state.message}"));
                }

                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }
}

class _GameListTile extends StatelessWidget {
  final dynamic game; // Replace with your Game model type

  const _GameListTile({required this.game});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: context.read<FavoriteCubit>().isFavorite(game.id),
      builder: (context, snapshot) {
        final isFav = snapshot.data ?? false;

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
          subtitle: Text("Rating: ${game.rating ?? '-'}"),
          trailing: IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () async {
              await context.read<FavoriteCubit>().toggleFavorite(
                id: game.id,
                name: game.name,
                rating: game.rating,
                backgroundImage: game.backgroundImage,
              );

              // Show snackbar
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFav
                          ? '${game.name} removed from favorites'
                          : '${game.name} added to favorites',
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPage(gameId: game.id),
              ),
            );
          },
        );
      },
    );
  }
}