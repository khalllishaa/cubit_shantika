import 'package:cubit_shantika/config/constant.dart';
import 'package:cubit_shantika/config/service_locator.dart';
import 'package:cubit_shantika/feature/detail/detail_page.dart';
import 'package:cubit_shantika/feature/favourite/cubit/favouite_cubit.dart';
import 'package:cubit_shantika/feature/favourite/cubit/favourite_state.dart';
import 'package:cubit_shantika/feature/home/cubit/home_cubit.dart';
import 'package:cubit_shantika/feature/home/cubit/home_state.dart';
import 'package:cubit_shantika/repository/favourite_repository.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'package:cubit_shantika/ui/app_styles.dart';
import 'package:cubit_shantika/ui/custom_appbar.dart';
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
          create: (_) => FavoriteCubit(FavoriteRepository()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return OrangeBackground(
            showSearch: true,
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is GamesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GamesLoaded) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: AppStyles.paddingM),
                    itemCount: state.games.length,
                    itemBuilder: (context, index) {
                      final game = state.games[index];
                      return _buildGameTile(context, game);
                    },
                  );
                }

                if (state is GamesError) {
                  return Center(child: Text("Error: ${state.message}"));
                }

                return const SizedBox();
              },
            ),
          );        },
      ),
    );
  }
}

Widget _buildGameTile(BuildContext context, dynamic game) {
  return BlocBuilder<FavoriteCubit, FavoriteState>(
    builder: (context, favState) {
      bool isFav = false;

      if (favState is FavoriteLoaded) {
        isFav = favState.favoriteIds.contains(game.id);
      } else if (favState is FavoriteToggled) {
        isFav = favState.favoriteIds.contains(game.id);
      }

      String genreString = 'unknown';
      if (game.genres != null && game.genres.isNotEmpty) {
        genreString = game.genres.map((g) => g.name).join(', ');
      }

      return Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPage(gameId: game.id),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: AppStyles.paddingL, vertical: AppStyles.paddingXL),
              decoration: BoxDecoration(
                color: AppStyles.primary,
                borderRadius: BorderRadius.circular(AppStyles.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: AppStyles.dark,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: AppStyles.paddingXXL, right: AppStyles.paddingL, top: AppStyles.paddingM, bottom: AppStyles.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            game.name,
                            style: AppStyles.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: AppStyles.spaceXXS),
                        GestureDetector(
                          onTap: () async {
                            await context.read<FavoriteCubit>().toggleFavorite(
                              id: game.id,
                              name: game.name,
                              rating: game.rating,
                              backgroundImage: game.backgroundImage,
                              genres: game.genres,
                            );

                            bool isFavNow = await context.read<FavoriteCubit>().isFavorite(game.id);

                            showTopNotification(context, game.name, isFavNow);

                          },
                          child: Stack(
                            children: [
                              if (isFav)
                                Positioned(
                                  top: 2,
                                  left: 2,
                                  child: Icon(
                                    Icons.favorite,
                                    size: AppStyles.iconM,
                                    color: AppStyles.dark, // shadow color
                                  ),
                                ),
                              Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                size: AppStyles.iconM,
                                color: isFav ? AppStyles.secondary : AppStyles.dark,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppStyles.spaceXXS),
                    // Genre
                    Text(
                      "genres: $genreString",
                      style: AppStyles.genre,
                    ),
                    SizedBox(height: AppStyles.spaceS),
                    Row(
                      children: [
                        Icon(Icons.star, size: AppStyles.iconM, color: AppStyles.dark),
                        SizedBox(width: AppStyles.spaceXS),
                        Text(
                          "${game.rating ?? '-'}",
                          style: AppStyles.genre.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (game.backgroundImage != null)
            Positioned(
              left: 25,
              top: -10,
              child: Container(
                width: AppStyles.imagelistsize,
                height: AppStyles.imagelistsize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppStyles.radiusL),
                  border: Border.all(color: AppStyles.light, width: 3.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppStyles.radiusL),
                  child: Image.network(
                    game.backgroundImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

void showTopNotification(
    BuildContext context,
    String gameName,
    bool isFavNow,
    ) {
  final String message = isFavNow
      ? '$gameName added to favorites'
      : '$gameName removed from favorites';

  final IconData icon = isFavNow ? Icons.favorite : Icons.favorite_border;

  final Color iconColor = isFavNow ? AppStyles.primary : AppStyles.dark;

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 20,
      right: 20,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(AppStyles.radiusL),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppStyles.paddingXL,
            vertical: AppStyles.paddingXL,
          ),
          decoration: BoxDecoration(
            color: AppStyles.light,
            borderRadius: BorderRadius.circular(AppStyles.radiusL),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              SizedBox(width: AppStyles.spaceS),
              Expanded(
                child: Text(
                  message,
                  style: AppStyles.genre,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(const Duration(milliseconds: 1500)).then((_) {
    overlayEntry.remove();
  });
}