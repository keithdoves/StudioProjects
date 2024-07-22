void main() {


  DateTime now = DateTime.now(); //현재 날짜와 시간을 가져온다.
  print(now); //2021-08-31 15:47:00.000
  print(now.year); //2023
  print(now.month); //8
  print(now.day); //31
  print(now.hour); //
  print(now.minute); //47
  print(now.second); //0
  print(now.millisecond); //0

  Duration duration = Duration(
    days: 1,
    hours: 10,
    minutes: 10,
    seconds: 10,
    milliseconds: 10,
    microseconds: 10,
  );

  print(duration); //1:10:10:10.010010
  print(duration.inDays); //1
  print(duration.inHours); //34
  print(duration.inMinutes); //2050
  print(duration.inSeconds); //123010
  print(duration.inMilliseconds); //123010010
  print(duration.inMicroseconds); //123010010010

  DateTime specificDate = DateTime(
    2021,
    8,
    30,
    15,
    47,
    12,
    5,
    7,
  );
  print(specificDate); //2021-08-31 15:47:00.000

  final difference = now.difference(specificDate);
  print(difference); //2 days, 0:00:00.000000
  print(difference.inDays); //2
  print(difference.inHours); //48
  print(difference.inMinutes); //2880

  print(now.isAfter(specificDate)); //true 다음이냐?
  print(now.isBefore(specificDate)); //false 전이냐?

  now.add(Duration(hours: 10)); //현재 시간에 duration을 더한다.
  now.subtract(Duration(hours: 10)); //현재 시간에 duration을 뺀다.

}