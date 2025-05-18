import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppAlerts {
  static void showError(BuildContext context, String message) {
    _show(context,
      title: "Dikkat!",
      message: message,
      type: ContentType.failure,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context,
      title: "İşlem başarılı!",
      message: message,
      type: ContentType.success,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _show(context,
      title: "Uyarı!",
      message: message,
      type: ContentType.warning,
    );
  }

  static void _show(BuildContext context, {
    required String title,
    required String message,
    required ContentType type,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.only(
            bottom: 16.h,
            left: 16.w,
            right: 16.w,
          ),
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: type,
          ),
        ),
      );
  }

  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    String title = 'Onay',
    String? description,
    String confirmText = 'Evet',
    String cancelText = 'Hayır',
    bool barrierDismissible = true,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: description != null ? Text(description) : null,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}