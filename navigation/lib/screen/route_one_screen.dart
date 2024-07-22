import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';
import 'package:navigation/screen/route_two_screen.dart';

class RouteOneScreen extends StatelessWidget {
  final int? number;
  const RouteOneScreen({this.number, super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Route One',
      children: [
        Text(
          'argument : $number',
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
            onPressed: () {
              //[HomeScreen(), RouteOneScreen(), RouteTwoScreen()] navigator는 이런식으로 화면이 쌓임.
              //지우면 오른쪽부터 사라짐. Stack 구조 / route stack
              Navigator.of(context).pop(456); // 현재화면 터트리고 이전화면 이동
            },
            child: const Text('Pop')),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).maybePop(456); // 현재화면 터트리고 이전화면 이동
            },
            child: const Text('MaybePop')),
        ElevatedButton(
          onPressed: () {
            //push는 MaterialPageRoute를 사용함.
            //pushNamed는 main.dart에서 설정한 route name을 사용함.
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RouteTwoScreen(),
                settings: const RouteSettings(
                  //argument를 넘겨줄 수 있음.
                  arguments: 789,
                ),
              ),
            );
          },
          child: const Text('Push to Two'),
        ),
      ],
    );
  }
}
