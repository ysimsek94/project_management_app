import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBottomNavBarItem {
  final IconData icon;
  final String label;

  const AppBottomNavBarItem({
    required this.icon,
    required this.label,
  });
}

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<AppBottomNavBarItem> items;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;

  const AppBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Container(
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10.r,
              offset: Offset(0, -1.h),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1.w),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final isSelected = index == currentIndex;
                  final color = isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade500;
                  final item = items[index];
                  return Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18.r),
                        onTap: () => onTap(index),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                              vertical: 6.h, horizontal: 16.w),
                          decoration: isSelected
                              ? BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(18.r),
                                )
                              : null,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item.icon,
                                size: isSelected ? 28.sp : 24.sp,
                                color: color,
                              ),
                              SizedBox(height: 4.h),
                              if ((isSelected && showSelectedLabels) ||
                                  (!isSelected && showUnselectedLabels))
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 9.2.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              SizedBox(height: 4.h),
                              if (isSelected)
                                Container(
                                  width: 20.w,
                                  height: 2.h,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(1.h),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
