import 'package:flutter/material.dart';
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
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final String? errorText;
  final String? initialValue;
  final TextInputAction? textInputAction;
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
    this.borderRadius = 8.0,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.errorText,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      readOnly: readOnly,
      textCapitalization: TextCapitalization.none,
      maxLines: 1,
      maxLength: maxLength,
      keyboardType: keyboardType,
      controller: textEditingController,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      onTapOutside: onTapOutside,
      obscureText: obscureText!,
      onTap: readOnly ? onTap : null,
      textInputAction: textInputAction,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
        filled: true,
        fillColor: fillColor ?? Colors.grey.shade100,
        contentPadding: contentPadding,
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
                  color: theme.colorScheme.primary,
                ),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      style: theme.textTheme.bodyMedium,
      cursorColor: context.theme.colorScheme.primary,
      initialValue: initialValue,
    );
  }
}
