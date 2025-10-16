import 'package:cubit_shantika/config/service_locator.dart';
import 'package:cubit_shantika/feature/favourite/favourite_page.dart';
import 'package:cubit_shantika/feature/home/cubit/home_cubit.dart';
import 'package:cubit_shantika/feature/home/home_page.dart';
import 'package:cubit_shantika/feature/navigation/navigation_cubit.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'package:cubit_shantika/ui/app_styles.dart';
import 'package:cubit_shantika/ui/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationPage extends StatelessWidget {
  NavigationPage({super.key});

  final List<Widget> screens = [
    BlocProvider(
      create: (_) => HomeCubit(repo: getIt<GameRepository>())..fetchInitial(),
      child: HomePage(),
    ),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          // extendBody: true,
          backgroundColor: AppStyles.light,
          body: screens[currentIndex],
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<NavigationCubit>().changeTab(index);
            },
          ),
        );
      },
    );
  }
}