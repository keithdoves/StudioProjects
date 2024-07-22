import 'package:flutter/material.dart';
import 'package:blog_webapp/screen/home_screen.dart';

void main() {
  //flutter 프레임워크가 실행할 준비가 될때까지 기다린다.
  //statelesswidget에서 변수를 사용하려면 반드시 아래 코드를 추가해야 함
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}
