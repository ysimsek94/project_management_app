import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/core/widgets/app_button.dart';

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
    required String title,
    String? description,
    String confirmText = 'Evet',
    String cancelText = 'Hayır',
    bool barrierDismissible = true,
  }) async {
    final theme = Theme.of(context);
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge,
              ),
              if (description != null) ...[
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: theme.textTheme.titleMedium,
                ),
              ],
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(cancelText.toUpperCase()),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(confirmText.toUpperCase()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return result == true;
  }
}