// lib/core/navigation/app_navigator.dart

import 'package:flutter/material.dart';

class AppNavigator {
  static void maybePopWithResult(BuildContext context, [dynamic result = true]) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
  }
}