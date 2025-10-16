import 'package:cubit_shantika/feature/home/cubit/home_cubit.dart';
import 'package:cubit_shantika/ui/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

  class OrangeBackground extends StatelessWidget {
    final Widget child;
    final bool showSearch;
    final String title;

    const OrangeBackground({
      super.key,
      required this.child,
      this.showSearch = false,
      this.title = "Game List", // default
    });

    @override
    Widget build(BuildContext context) {
      return Stack(
        children: [
          Column(
            children: [
              Container(
                height: AppStyles.headerheight,
                width: double.infinity,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'images/header.svg',
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: AppStyles.paddingheight,
                          left: AppStyles.paddingXL),
                      child: Row(
                        children: [
                          Icon(Icons.sports_esports,
                              size: AppStyles.iconL, color: AppStyles.dark),
                          SizedBox(width: AppStyles.spaceM),
                          Text(
                            title, // ← pakai title!
                            style: AppStyles.header,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (showSearch)
            Positioned(
              top: 110,
              left: 20,
              right: 20,
              child: _searchBar(context),
            ),

          Positioned(
            top: showSearch ? 180 : 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: child,
          ),
        ],
      );
    }
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppStyles.paddingL),
      height: 50,
      decoration: BoxDecoration(
        color: AppStyles.search,
        borderRadius: BorderRadius.circular(AppStyles.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppStyles.dark,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppStyles.dark, size: AppStyles.iconsearch),
          SizedBox(width: AppStyles.spaceM),
          Expanded(
            child: TextField(
              onChanged: (value) {
                context.read<HomeCubit>().searchGames(value);
              },
              decoration: InputDecoration(
                hintText: "search",
                hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppStyles.genre.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }