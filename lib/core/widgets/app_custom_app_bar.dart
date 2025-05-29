import 'package:flutter/material.dart';

import '../utils/app_navigator.dart';
import '../utils/app_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBack != null
                  ? onBack!
                  : () => AppNavigator.maybePopWithResult(context),
            )
          : null,
      title: Text(
        title,
        style: AppTypography.bold20(),
      ),
      actions: actions,
    );
  }
}