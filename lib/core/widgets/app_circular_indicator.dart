import 'package:flutter/material.dart';
import 'package:project_management_app/core/extensions/theme_extensions.dart';

class AppCircularIndicator extends StatelessWidget {
  const AppCircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.theme.primaryColor,
      ),
    );
  }
}
