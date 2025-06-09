import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final Widget? hint;
  final FormFieldValidator<T?>? validator;
  final double borderRadius;

  const AppDropdown({

    Key? key,
    this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.validator,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(canvasColor: Colors.white),
      child: DropdownButtonFormField<T>(
        value: value,
        hint: hint != null
            ? DefaultTextStyle(
                style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey.shade500),
                child: hint!,
              )
            : null,
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade800),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        dropdownColor: Colors.white,
        elevation: 2,
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}