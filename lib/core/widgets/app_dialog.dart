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
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(icon,
                        size: 24, color: Theme.of(context).primaryColor),
                  ),
                  AppSizes.gapH16,
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  AppSizes.gapH8,
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!,
                    textAlign: TextAlign.center
                    ,
                    child: content,
                  ),
                  AppSizes.gapH24,
                  Row(
                    children: actions,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
