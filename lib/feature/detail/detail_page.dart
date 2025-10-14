import 'package:cubit_shantika/feature/detail/cubit/detail_cubit.dart';
import 'package:cubit_shantika/feature/detail/cubit/detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'package:cubit_shantika/data/api_service.dart';

class DetailPage extends StatelessWidget {
  final int gameId;
  const DetailPage({required this.gameId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailCubit(GameRepository(ApiService()))..fetchDetail(gameId),
      child: Scaffold(
        appBar: AppBar(title: Text("Detail")),
        body: BlocBuilder<DetailCubit, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is DetailLoaded) {
              final game = state.game;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE
                    if (game.backgroundImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(game.backgroundImage!),
                      ),

                    const SizedBox(height: 16),

                    // TITLE
                    Text(
                      game.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    // Release
                    Text("Release date: ${game.released ?? '-'}"),

                    SizedBox(height: 8),

                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, size: 18),
                        SizedBox(width: 4),
                        Text(game.rating?.toString() ?? "-"),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Description (RAW data)
                    Text(
                      game.description ?? "No description",
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              );
            }

            if (state is DetailError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            return SizedBox();
          },
        ),
      ),
    );
  }
}
