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
    AppThemeColor.teal: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
    ),
    AppThemeColor.purple: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
    ),
    AppThemeColor.green: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
    ),
    AppThemeColor.orange: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
    ),
    AppThemeColor.red: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
    ),
    AppThemeColor.pink: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
    ),
  };
}
