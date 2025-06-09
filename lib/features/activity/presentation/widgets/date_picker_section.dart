import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

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
    return
      SizedBox(
        height: 80.h,
        width: double.infinity,
        child: WeeklyDatePicker(
          selectedDay: currentDate,
          changeDay: onDateSelected,
          enableWeeknumberText: false,
          weeknumberColor: Theme.of(context).primaryColor,
          weeknumberTextColor: Colors.white,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          weekdayTextColor: Colors.grey.shade500,
          digitsColor: Colors.black87,
          selectedDigitBackgroundColor: Theme.of(context).primaryColor,
          weekdays: const ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"],
          daysInWeek: 7,
        ),
      );
  }
}