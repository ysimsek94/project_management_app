import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      icon,
                      size: 24.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!,
                    textAlign: TextAlign.center
                    ,
                    child: content,
                  ),
                  SizedBox(height: 24.h),
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
