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
              surfaceTintColor: Color(0xff00ffffff),
              scrolledUnderElevation: 0,
              elevation: 0,
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
                        return _buildGameTile(context, game);
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

Widget _buildGameTile(BuildContext context, dynamic game) {
  return BlocBuilder<FavoriteCubit, FavoriteState>(
    builder: (context, favState) {
      bool isFav = false;

      // Check dari berbagai state
      if (favState is FavoriteLoaded) {
        isFav = favState.favoriteIds.contains(game.id);
      } else if (favState is FavoriteToggled) {
        isFav = favState.favoriteIds.contains(game.id);
      }

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

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFav
                        ? '${game.name} removed from favorites'
                        : '${game.name} added to favorites',
                  ),
                  duration: const Duration(seconds: 1),
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