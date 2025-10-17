import 'package:cubit_shantika/config/service_locator.dart';
import 'package:cubit_shantika/feature/detail/cubit/detail_cubit.dart';
import 'package:cubit_shantika/feature/detail/cubit/detail_state.dart';
import 'package:cubit_shantika/ui/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cubit_shantika/repository/game_repository.dart';

class DetailPage extends StatelessWidget {
  final int gameId;
  const DetailPage({required this.gameId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailCubit(getIt<GameRepository>())..fetchDetail(gameId),
      child: Scaffold(
        backgroundColor: AppStyles.light,
        body: BlocBuilder<DetailCubit, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is DetailLoaded) {
              final game = state.game;
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    _buildBackgroundContainer(),
                    _buildContent(context, game),
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

Widget _buildBackgroundContainer() {
  return Positioned(
    top: 265,
    left: 0,
    right: 0,
    bottom: 0,
    child: Container(
      decoration: BoxDecoration(
        color: AppStyles.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppStyles.radiusL),
          topRight: Radius.circular(AppStyles.radiusL),
        ),
      ),
    ),
  );
}

Widget _buildContent(BuildContext context, dynamic game) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(height: AppStyles.spaceHeader),
      _buildHeader(context),
      SizedBox(height: AppStyles.spaceXL),
      _buildImage(game),
      SizedBox(height: AppStyles.spaceXL),
      _buildGameInfoCard(game),
      Transform.translate(
        offset: Offset(0, -35),
        child: _buildDescription(game),
      ),
      SizedBox(height: AppStyles.spaceXL),
    ],
  );
}

Widget _buildHeader(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppStyles.paddingL),
    child: Container(
      height: AppStyles.detailheight,
      width: AppStyles.detailwidth,
      padding: EdgeInsets.symmetric(
        horizontal: AppStyles.paddingL,
        vertical: AppStyles.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppStyles.primary,
        borderRadius: BorderRadius.circular(AppStyles.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppStyles.dark,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.chevron_left,
              color: AppStyles.dark,
              size: AppStyles.icondetail,
            ),
          ),
          SizedBox(width: AppStyles.spaceXL),
          Text(
            "Detail Game",
            style: AppStyles.header,
          ),
        ],
      ),
    ),
  );
}

Widget _buildImage(dynamic game) {
  if (game.backgroundImage == null) return SizedBox();

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppStyles.paddingXL),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppStyles.light,
          width: 5,
        ),
        borderRadius: BorderRadius.circular(AppStyles.radiusL),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppStyles.radiusL),
        child: Image.network(
          game.backgroundImage!,
          height: AppStyles.detailsize,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

Widget _buildGameInfoCard(dynamic game) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppStyles.paddingdetail),
    child: Transform.translate(
      offset: Offset(0, -65),
      child: Container(
        padding: EdgeInsets.all(AppStyles.paddingL),
        decoration: BoxDecoration(
          color: AppStyles.secondary,
          borderRadius: BorderRadius.circular(AppStyles.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppStyles.dark,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleRow(game),
            SizedBox(height: AppStyles.spaceM),
            _buildInfoRow(game),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTitleRow(dynamic game) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          game.name,
          style: AppStyles.header.copyWith(fontSize: 18),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      // SizedBox(width: AppStyles.spaceS),
      Icon(
        Icons.favorite_border,
        color: AppStyles.dark,
        size: AppStyles.iconsearch,
      ),
    ],
  );
}

Widget _buildInfoRow(dynamic game) {
  return Row(
    children: [
      Icon(Icons.calendar_month, size: 14, color: AppStyles.dark),
      SizedBox(width: AppStyles.spaceXS),
      Text(
        game.released ?? '-',
        style: AppStyles.detail
      ),
      SizedBox(width: AppStyles.spaceXL),
      Icon(Icons.star, size: 14, color: AppStyles.dark),
      SizedBox(width: AppStyles.spaceXS),
      Text(
        game.rating?.toString() ?? '-',
          style: AppStyles.detail
      ),
      SizedBox(width: AppStyles.spaceXL),
      Icon(Icons.people, size: 14, color: AppStyles.dark),
      SizedBox(width: AppStyles.spaceXS),
      Text(
        "200 players",
          style: AppStyles.detail
      ),
    ],
  );
}

Widget _buildDescription(dynamic game) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppStyles.paddingL),
    child: Text(
      game.description ?? "No description available",
      textAlign: TextAlign.justify,
      style: AppStyles.genre,
    ),
  );
}