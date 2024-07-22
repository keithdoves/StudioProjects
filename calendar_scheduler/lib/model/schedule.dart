import 'package:drift/drift.dart';

import 'category.dart';

class ScheduleTable extends Table {
  // 1) 식별 가능한 ID
  IntColumn get id => integer().autoIncrement()(); //getter /DB에서 자동 증가
  // 2) 시작 시간
  IntColumn get startTime => integer()();

  // 3) 종료 시간
  IntColumn get endTime => integer()();

  // 4) 내용
  TextColumn get content => text()();

  // 5) 날짜
  DateTimeColumn get date => dateTime()();

  // 6) 카테고리 (카테고리 테이블에서 참조한다는 뜻)
  IntColumn get colorId => integer().references(CategoryTable, #Id,)();

  // 7) 일정 생성날짜시간
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();


}
