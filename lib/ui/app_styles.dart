import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {

  // Color Apps
  static const Color light = Color(0xFFFFFFFF);
  static const Color dark = Color(0xFF191919);
  static const Color grey1 = Color(0xFF606060);
  static const Color grey2 = Color(0xFFE8E8E8);
  static const Color grey3 = Color(0xFF989696);
  static const Color primary = Color(0xFFFFBF5C);
  static const Color secondary = Color(0xFFFAA523);
  static const Color search = Color(0xFFFFCD80);

  // Text Style
  static final TextStyle bottomnav = TextStyle(fontSize: 11, fontFamily: 'Ravie', height: 1.2, letterSpacing: 0.5, fontWeight: FontWeight.w400,);
  static final TextStyle title = GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppStyles.dark);
  static final TextStyle genre = GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.normal, color: AppStyles.dark);
  static final TextStyle header = GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppStyles.dark);
  static final TextStyle detail = GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal, color: AppStyles.dark);

  // Icon Sizes
  static const double iconS = 15.0;
  static const double iconM = 20.0;
  static const double iconL = 36.0;
  static const double icondetail = 32.0;
  static const double iconsearch = 24.0;

  // Padding & Margin
  static const double paddingXXS = 2.0;
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 12.0;
  static const double paddingL = 16.0;
  static const double paddingXL = 20.0;
  static const double paddingXXL = 135.0;
  static const double paddingheight = 60.0;
  static const double paddingdetail = 40.0;

  // Spacing
  static const double spaceXXS = 2.0;
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 12.0;
  static const double spaceL = 16.0;
  static const double spaceXL = 25.0;
  static const double spaceHeader = 60.0;
  static const double spaceimagedetail = 45.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 20.0;
  static const double radiusXL = 35.0;

  // Image Size
  static const double imagelistsize = 116.0;
  static const double bottomsize = 90.0;
  static const double bottomsizeheigth = 70.0;
  static const double bottomsizewidth = 300.0;
  static const double headerheight = 210.0;
  static const double nofavsize = 240.0;
  static const double detailwidth = 335.0;
  static const double detailheight = 55.0;
  static const double detailsize = 180.0;
}