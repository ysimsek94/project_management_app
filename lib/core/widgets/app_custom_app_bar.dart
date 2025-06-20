import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 24.sp,
              ),
              onPressed: onBack != null
                  ? onBack!
                  : () =>Navigator.of(context).pop(true),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: actions,
    );
  }
}