import 'package:cubit_shantika/feature/favourite/cubit/favouite_cubit.dart';
import 'package:cubit_shantika/feature/favourite/cubit/favourite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cubit_shantika/feature/detail/detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoriteCubit()..loadFavorites(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Favorites"),
        ),
        body: BlocConsumer<FavoriteCubit, FavoriteState>(
          listener: (context, state) {
            if (state is FavoriteToggled) {
              context.read<FavoriteCubit>().loadFavorites();
            }
          },
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FavoriteLoaded) {
              if (state.favorites.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "No favorites yet",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final game = state.favorites[index];
                  return ListTile(
                    leading: game['backgroundImage'] != null
                        ? Image.network(
                      game['backgroundImage'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.image_not_supported),
                    title: Text(game['name']),
                    subtitle: Text("Rating: ${game['rating'] ?? '-'}"),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        context.read<FavoriteCubit>().toggleFavorite(
                          id: game['id'],
                          name: game['name'],
                          rating: game['rating'],
                          backgroundImage: game['backgroundImage'],
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(gameId: game['id']),
                        ),
                      );
                    },
                  );
                },
              );
            }

            if (state is FavoriteError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}