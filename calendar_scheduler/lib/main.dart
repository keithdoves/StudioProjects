import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'const/colors.dart';
import 'database/drift.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //runApp() 실행 전에, 코드를 실행하기 위해서는 플러터 프레임워크가 준비되었는지 확인해야 함
  //runapp이 실행되면 저 위 코드가 자동으로 실행되어서, 지금까지 따로 쓰지 않았음.

  await initializeDateFormatting();
   //app을 run하기 전에, 한국어 날짜 형식(intl패키지)을 초기화합니다.

  final database = AppDatabase(); //데이터베이스 인스턴스 생성.

  GetIt.I.registerSingleton<AppDatabase>(database);
 //이렇게 해놓으면 database를 다른 곳에서 사용할 때 GetIt.I<AppDatabase>로 사용할 수 있음

  final color = await database.getCategories();
  if(color.isEmpty){
    for(String hexCode in categoryColors){
      await database.createCategory(
        CategoryTableCompanion(
          color: Value(hexCode),
        )

      );

    }
  }



  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'NotoSans',

    ),
    home: HomeScreen(),
  ));
}
