import 'dart:io';
import 'package:calendar_scheduler/model/schedule_with_category.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

import '../model/category.dart';

//part 키워드 : 다른 파일을 하나의 파일처럼 인식하도록 만들어줌
part 'drift.g.dart'; //.g는 generated의 약자

@DriftDatabase(//DriftDatabase 어노테이션을 사용하여 데이터베이스를 정의
    tables: [
  ScheduleTable,
  CategoryTable,
] //만든 테이블을 여기 써줌
    )
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()); //생성자를 통해 데이터베이스 연결
  //생성자 -> 부모 생성자를 호출하면서 _openConnection()을 파라미터로 넣어줌

  Future<int> createCategory(CategoryTableCompanion data) =>
      into(categoryTable).insert(data);

  Future<List<CategoryTableData>> getCategories() =>
      select(categoryTable).get();

  Future<ScheduleWithCategory> getScheduleById(int id) {
    final query = select(scheduleTable).join([
      innerJoin(
        categoryTable,
        categoryTable.id.equalsExp(
          scheduleTable.colorId,
        ),
      ),
    ])
      ..where(scheduleTable.id.equals(id));

    return query.map((row) {
      final schedule = row.readTable(scheduleTable);
      final category = row.readTable(categoryTable);

      return ScheduleWithCategory(category: category, schedule: schedule);
    }).getSingle();
  }

  //입력한 data로 업데이트
  Future<int> updateScheduleById(int id, ScheduleTableCompanion data) =>
      (update(scheduleTable)..where((table) => table.id.equals(id)))
          .write(data);

  //실제로 다루게되는 class는 뒤에 Data붙은 것임(code generator가 만들어줌)
  //scheduleTable은 위에 우리가 선언한 것이 아니라 _$AppDatabase속에 code generator가 만들어준 것

  //* 메소드 정의 : 데이터베이스에 데이터를 추가하거나 가져오는 메소드
  Future<List<ScheduleTableData>> getSchedules(
    DateTime date,
  ) =>
      /*final selectQuery = select(scheduleTable);
    selectQuery.where((table) => table.date.equals(date));
    return selectQuery.get();*/
      // 위 아래는 똑같다
      (select(scheduleTable)..where((table) => table.date.equals(date))).get();

  Stream<List<ScheduleWithCategory>> streamSchedules(DateTime date) {
    final query = select(scheduleTable).join([
      innerJoin(
        categoryTable,
        categoryTable.id.equalsExp(
          scheduleTable.colorId,
        ),
      ),
    ])
      ..where(scheduleTable.date.equals(date))
      ..orderBy([
        // scheduleTable의 date 필드를 기준으로 오름차순 정렬
        OrderingTerm(
            expression: scheduleTable.startTime, mode: OrderingMode.asc),
        // 필요에 따라 categoryTable의 다른 필드로 정렬을 추가할 수 있습니다.
        // (t) => OrderingTerm(expression: t.read(categoryTable.name), mode: OrderingMode.asc)
      ]);

    return query.map((row) {
      final schedule = row.readTable(scheduleTable);
      final category = row.readTable(categoryTable);

      return ScheduleWithCategory(category: category, schedule: schedule);
    }).watch();
  }

  //삭제한 값의 id를 받을 수 있기 때문에 int로 반환
  Future<int> createSchedule(ScheduleTableCompanion data) =>
      into(scheduleTable).insert(data);

  Future<int> removeSchedule(int id) => (delete(scheduleTable)
        ..where(
          (table) => table.id.equals(id),
        ))
      .go();

  //ScheduleTableCompanion : 데이터베이스에 데이터를 추가할 때 사용하는 클래스(C,U)
  //int를 반환하는 것은 데이터베이스에 데이터를 추가하면 추가된 데이터의 id를 반환하기 때문

  @override
  int get schemaVersion => 2; //스키마 버전을 정의 / schemaVersion : 데이터베이스 스키마의 버전

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (Migrator m, int from, int to) async {
        //from : 앱에 깔린 버전
        //to : 업데이트 할 버전
        if (from < 2) {
          await m.addColumn(categoryTable, categoryTable.randomNumber2);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    //LazyDatabase : 데이터베이스와 지연된 연결을 만들어줌
    final dbFolder = await getApplicationDocumentsDirectory();
    //앱을 설치하면 각 앱 별로 배정받는 폴더가 있음
    //그 폴더의 위치를 갖고오는 것이 getApplicationDocumentsDirectory()
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    //db.sqlite 파일을 만들어줌
    // WINDOWS : C:\\User\flutter
    // MAC : /User/flutter
    // Users/flutter/ + /name/codefactory
    // Users/flutter/name/codefactory 이렇게 합쳐줌
    // Users/flutter/name/codefactory/db.sqlite 이렇게 됨
    //운영체제별로 경로를 다르게 가져오기 때문에 path 패키지를 사용하여 경로를 합쳐줌

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      //안드로이드 옛날버전 버그를 해결해줌
    }

    final cachebase = await getTemporaryDirectory();
    sqlite3.tempDirectory = cachebase.path; //임시 디렉토리를 sqlite3에 알려줌
    //sqlite3가 임시디렉토리를 통해 캐시나 메타데이터 등을 저장함.

    return NativeDatabase.createInBackground(file);
    //file에 데이터베이스 만듬.
  });
}
