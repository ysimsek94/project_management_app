import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

enum AppThemeColor {
  purple,

  green,

  orange,

  red,

  teal,

  pink,
}

class AppTheme {
  static final Map<AppThemeColor, ThemeData> themes = {
    AppThemeColor.purple: ThemeData(
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      primaryColor: Colors.deepPurple,
    ),
    AppThemeColor.green: ThemeData(
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      primaryColor: Colors.green,
    ),
    AppThemeColor.orange: ThemeData(
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      primaryColor: Colors.orange,
    ),
    AppThemeColor.red: ThemeData(
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      primaryColor: Colors.red,
    ),
    AppThemeColor.teal: ThemeData(
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      primaryColor: Colors.teal,
    ),
    AppThemeColor.pink: ThemeData(
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      primaryColor: Colors.pink,
    ),
  };
}
