import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/core/extensions/theme_extensions.dart';

class AppTextField extends StatelessWidget {
  final IconData? suffixIcon;
  final bool? obscureText;
  final String hint;
  final FormFieldValidator<String>? validator;
  final TextEditingController? textEditingController;
  final TextInputType keyboardType;
  final int? maxLength;
  final FocusNode? focusNode;
  final void Function(String)? onChange;
  final void Function(String)? onSubmit;
  final VoidCallback? onSuffixIconTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? fillColor;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final String? errorText;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final int? maxLines;
  const AppTextField({
    super.key,
    required this.hint,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.focusNode,
    this.obscureText = false,
    this.textEditingController,
    this.maxLength,
    this.onChange,
    this.onSubmit,
    this.onTapOutside,
    this.onSuffixIconTap,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.fillColor,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIconColor,
    this.borderRadius = 8.0,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.errorText,
    this.initialValue,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseFill = readOnly
        ? Colors.grey.shade200
        : (fillColor ?? Colors.white);

    return TextFormField(
      readOnly: readOnly,
      textCapitalization: TextCapitalization.none,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      keyboardType: keyboardType,
      controller: textEditingController,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      onTapOutside: onTapOutside,
      obscureText: obscureText!,
      onTap: onTap,
      textInputAction: textInputAction,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        filled: true,
        fillColor: baseFill,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        errorText: errorText,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                color: prefixIconColor ?? theme.colorScheme.primary,
              ),
        suffixIcon: suffixIcon == null
            ? null
            : GestureDetector(
                onTap: onSuffixIconTap,
                child: Icon(
                  suffixIcon,
                  color: suffixIconColor ?? theme.colorScheme.primary,
                ),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5.w),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: readOnly ? Colors.grey.shade700 : Colors.black87,
      ),
      cursorColor: readOnly ? Colors.transparent : context.theme.colorScheme.primary,
      initialValue: initialValue,
    );
  }
}
