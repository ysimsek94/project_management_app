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
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal).copyWith(
        primary: Colors.teal,
        secondary: Colors.teal.shade200,
      ),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    AppThemeColor.purple: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple).copyWith(
        primary: Colors.purple,
        secondary: Colors.purple.shade200,
      ),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    AppThemeColor.green: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green).copyWith(
        primary: Colors.green,
        secondary: Colors.green.shade200,
      ),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    AppThemeColor.orange: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange).copyWith(
        primary: Colors.orange,
        secondary: Colors.orange.shade200,
      ),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    AppThemeColor.red: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.red).copyWith(
        primary: Colors.red,
        secondary: Colors.red.shade200,
      ),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    AppThemeColor.pink: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink).copyWith(
        primary: Colors.pink,
        secondary: Colors.pink.shade200,
      ),
      scaffoldBackgroundColor: AppColors.bgWhite,
      fontFamily: "Montserrat",
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  };
}
