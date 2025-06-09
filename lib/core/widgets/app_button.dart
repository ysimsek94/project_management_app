import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/core/extensions/theme_extensions.dart';

import '../utils/app_styles.dart';

enum ButtonType { filled, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.color,
    this.width,
    this.minWidth = 64,
    this.height = 48,
    required this.title,
    this.onClick,
    this.type = ButtonType.filled,
    this.isLoading = false,
    this.icon,
    this.borderRadius = 8,
    this.elevation = 0,
    this.padding,
  });

  final Color? color;
  final double? width;
  final double minWidth;
  final double height;
  final String title;
  final Function()? onClick;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final Color primary = color ?? context.theme.primaryColor;
    final isDisabled = onClick == null;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth.w,
        minHeight: height.h,
      ),
      child: SizedBox(
        width: width?.w,
        height: height.h,
        child: type == ButtonType.text
            ? TextButton(
          onPressed: onClick,
          style: TextButton.styleFrom(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
            foregroundColor: isDisabled
                ? Colors.grey
                : primary.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
          ),
          child: _buildContent(primary, isDisabled),
        )
            : OutlinedButton(
          onPressed: onClick,
          style: OutlinedButton.styleFrom(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
            side: type == ButtonType.outlined
                ? BorderSide(
              color: isDisabled ? Colors.grey : primary,
              width: 1.2.w,
            )
                : null,
            foregroundColor: isDisabled
                ? Colors.grey
                : type == ButtonType.outlined
                ? primary
                : Colors.white,
            backgroundColor: type == ButtonType.filled
                ? (isDisabled ? Colors.grey[300] : primary)
                : Colors.transparent,
            elevation: elevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
            shadowColor: primary.withOpacity(0.2),
          ),
          child: _buildContent(primary, isDisabled),
        ),
      ),
    );
  }

  Widget _buildContent(Color primary, bool isDisabled) {
    return isLoading
        ? SizedBox(
      width: 20.w,
      height: 20.w,
      child: CircularProgressIndicator(
        strokeWidth: 2.w,
        valueColor: AlwaysStoppedAnimation<Color>(
          type == ButtonType.filled && !isDisabled
              ? Colors.white
              : isDisabled
              ? Colors.grey
              : primary,
        ),
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null)
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Icon(
              icon,
              size: 20.sp,
              color: type == ButtonType.filled && !isDisabled
                  ? Colors.white
                  : isDisabled
                  ? Colors.grey
                  : primary,
            ),
          ),
        Text(
          title,
          style: AppTypography.medium16().copyWith(
            color: type == ButtonType.filled && !isDisabled
                ? Colors.white
                : isDisabled
                ? Colors.grey
                : primary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}