import 'package:flutter/material.dart';

import '../const/colors.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;
  final int scheduleCount;
  final textStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );

  TodayBanner(
      {required this.selectedDay, required this.scheduleCount, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                style: textStyle,
                '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일'),
            Text(style: textStyle,
                '${scheduleCount}개'),
          ],
        ),
      ),
    );
  }
}
