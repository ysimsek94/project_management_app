

import 'package:flutter/material.dart';

/// A centralized utility for picking dates and times, preserving the other component.
class DateTimePickers {
  /// Shows a date picker dialog.
  ///
  /// [initial] is the starting date shown in the picker.
  /// Returns a new DateTime with the picked date and original time, or null if cancelled.
  static Future<DateTime?> pickDate(
    BuildContext context,
    DateTime initial,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked == null) return null;
    return DateTime(
      picked.year,
      picked.month,
      picked.day,
      initial.hour,
      initial.minute,
      initial.second,
      initial.millisecond,
      initial.microsecond,
    );
  }

  /// Shows a time picker dialog.
  ///
  /// [initial] is the starting DateTime whose time portion is shown.
  /// Returns a new DateTime with the picked time and original date, or null if cancelled.
  static Future<DateTime?> pickTime(
    BuildContext context,
    DateTime initial,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (picked == null) return null;
    return DateTime(
      initial.year,
      initial.month,
      initial.day,
      picked.hour,
      picked.minute,
      initial.second,
      initial.millisecond,
      initial.microsecond,
    );
  }
}