import 'package:dusty_dust/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'model/stat_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //runApp말고 다른 것을 main에서 실행하려면 위와 같은 코드가 필요함.

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [StatModelSchema],
    directory: dir.path, //db를 생성할 위치
  );

  GetIt.I.registerSingleton<Isar>(isar);

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'Sunflower',
      ),
      home: HomeScreen(),
    ),
  );
}
