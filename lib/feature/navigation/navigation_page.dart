import 'package:cubit_shantika/feature/favourite/favourite_page.dart';
import 'package:cubit_shantika/feature/home/cubit/home_cubit.dart';
import 'package:cubit_shantika/feature/home/home_page.dart';
import 'package:cubit_shantika/feature/navigation/navigation_cubit.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api_service.dart';

class NavigationPage extends StatelessWidget {
  NavigationPage({super.key});

  final List<Widget> screens = [
    BlocProvider(
      create: (_) => HomeCubit(repo: GameRepository(ApiService()))..fetchInitial(),
      child: HomePage(),
    ),
    FavouritePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: screens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<NavigationCubit>().changeTab(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorite',
              ),
            ],
          ),
        );
      },
    );
  }
}
