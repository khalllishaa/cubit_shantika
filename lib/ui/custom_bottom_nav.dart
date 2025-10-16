import 'package:cubit_shantika/ui/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      height: AppStyles.bottomsize,
      margin: EdgeInsets.all(AppStyles.paddingXL),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: AppStyles.bottomsizeheigth,
              width: AppStyles.bottomsizewidth,
              decoration: BoxDecoration(
                color: AppStyles.primary,
                borderRadius: BorderRadius.circular(AppStyles.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: AppStyles.dark,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
            ),
          ),
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
        duration: Duration(milliseconds: 300),
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
                  duration: Duration(milliseconds: 300),
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
              Text(
                label,
                style: AppStyles.bottomnav,
              ),
              SizedBox(height: AppStyles.spaceXXS),
              Container(
                height: 3,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(AppStyles.radiusS),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}
