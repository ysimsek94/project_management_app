import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class DatePickerSection extends StatelessWidget {
  final DateTime currentDate;
  final Function(DateTime) onDateSelected;

  const DatePickerSection({
    super.key,
    required this.currentDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      DateTime.now(),
      height: 100.h,
      width: 80.w,
      locale: 'tr',
      initialSelectedDate: currentDate,
      selectionColor: Theme.of(context).primaryColor,
      selectedTextColor: Colors.white,
      dateTextStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      dayTextStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      monthTextStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      onDateChange: onDateSelected,
    );
  }
}
