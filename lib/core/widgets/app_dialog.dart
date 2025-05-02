import 'package:flutter/material.dart';
import 'package:project_management_app/core/constants/app_sizes.dart';

class AppDialog {
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget content,
    required List<Widget> actions,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F9FC),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE4E7EB)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.blue),
                      AppSizes.gapW8,
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: content,
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(children: actions),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}