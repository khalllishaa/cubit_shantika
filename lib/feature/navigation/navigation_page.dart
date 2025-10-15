import 'package:cubit_shantika/config/service_locator.dart';
import 'package:cubit_shantika/feature/favourite/favourite_page.dart';
import 'package:cubit_shantika/feature/home/cubit/home_cubit.dart';
import 'package:cubit_shantika/feature/home/home_page.dart';
import 'package:cubit_shantika/feature/navigation/navigation_cubit.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: EdgeInsets.all(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              width: 300,
              decoration: BoxDecoration(
                color: const Color(0xFFFFBF5C),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(1.0),
                    blurRadius: 0,
                    offset: const Offset(5, 5),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          // Nav Items
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  isActive: currentIndex == 0,
                  svgPath: currentIndex == 0
                      ? 'images/icons/home_filled.svg'
                      : 'images/icons/home_outline.svg',
                  label: 'Home',
                ),
                _buildNavItem(
                  index: 1,
                  isActive: currentIndex == 1,
                  svgPath: currentIndex == 1
                      ? 'images/icons/fav_filled.svg'
                      : 'images/icons/fav_outline.svg',
                  label: 'Favorite',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required bool isActive,
    required String svgPath,
    required String label,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0, isActive ? -15 : 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: SvgPicture.asset(
                    svgPath,
                    width: isActive ? 48 : 32,
                    height: isActive ? 48 : 32,
                    placeholderBuilder: (context) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            if (isActive) ...[
              // const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.getFont(
                  'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                height: 3,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}
