import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../const/colors.dart';



class Calendar extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final OnDaySelected? onDaySelected;
  //homeScreen에서 캘린더 변수를 가져오기 위해 최상단으로 변수를 끌어올림.
  //state 위젯 안에서는 widget. 키워드로 위 변수에 접근함.
  //stateless 위젯으로 변경 후 widget 키워드 다시 삭제.
  //상태 관리를 모두 homeScreen에서 하기 때문에, stateless 위젯으로 변경함.



  const Calendar({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final defaultBoxDeco = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(1.0),
    );
    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        todayDecoration: defaultBoxDeco.copyWith(
          color: Colors.blue.withOpacity(0.5),
          borderRadius: BorderRadius.circular(3.0),
        ),
        todayTextStyle: defaultTextStyle.copyWith(
          color: Colors.black,
        ),
        defaultDecoration: defaultBoxDeco,
        weekendDecoration: defaultBoxDeco.copyWith(
          color: Colors.blue.withOpacity(0.2),
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 2.0,
          ),
        ),
        outsideDecoration: BoxDecoration(
          shape : BoxShape.rectangle,
        ),
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(
          //copyWith는 기존의 스타일을 복사하여 새로운 스타일을 만듬
          color: PRIMARY_COLOR, //파라미터에 넣은 것만 변경함
        ),
      ),
      onDaySelected: onDaySelected,
      //onDaySelected는 어떤 날짜를 고를 때 실행되어 선택된 날짜를 받아옴
      selectedDayPredicate: (DateTime date) {
        //지금 보고 있는 화면의 모든 날에 대해서 이 함수를 실행함.
        //print('date: $date');
        //선택된 날짜를 캘린더에 돌려줌
        if (selectedDay == null) {
          return false;
        } //선택된 날짜가 있다면 선택한 날짜와 비교하여 T/F를 반환
        return (date.year == selectedDay!.year && //date는 받은 날짜
            date.month == selectedDay!.month &&
            date.day == selectedDay!.day);
      },
    );
  }
}
