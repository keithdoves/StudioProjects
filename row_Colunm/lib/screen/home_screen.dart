import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
//Text 위젯은 너비를 지정할 수 있는 위젯에 감싸져야 너비가 그에 맞춰진다.
  // 이를테면 너비를 지정할 수 없는 Column 위젯에 감싸져 있으면 너비가 그에 맞춰지지 않는다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // SafeArea : 화면의 안전한 영역, 노치 디자인 등에 사용(시스템 지역을 침범하지 않는 영역)
        bottom: false, // bottom 시스템 영역을 침범하지 않는 옵션/ true로 하면 침범
        child: Container(
          // Container : 그냥 위젯을 넣는 공간
          color: Colors.black,
          width: MediaQuery.of(context).size.width, //화면의 가로길이(현재사용중인 기기의길이)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Expanded, Flexible : 이 둘은 Row, Column의 children 안에서만 사용가능
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.orange,
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.yellow,
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.green,
                  ),
                ],
              ),
              Container(
                height: 50.0,
                width: 50.0,
                color: Colors.orange,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.orange,
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.yellow,
                  ),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.green,
                  ),
                ],
              ),
              Container(
                height: 50.0,
                width: 50.0,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
