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
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        hint: hint,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),

          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}