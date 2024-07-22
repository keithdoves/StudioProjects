import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';

class RouteThreeScreen extends StatelessWidget {
  const RouteThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 주의 : build에 argument 변수를 선언할 것.
    // ModalRoute를 갖고 오려면 보다시피 BuildContext인 context가 필요한데,
    // 위젯의 위치를 나타내는 context는 위젯이 빌드되는 시점에만 접근 가능하다.
    // 따라서 ModalRoute를 사용하려면 build 메서드 안에서만 사용 가능하다.
    final argument = ModalRoute.of(context)!.settings.arguments;
    return MainLayout(
        title: 'Three Screen',
        children:[
          Text('argument: $argument',
          textAlign: TextAlign.center,),
          ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text('Pop'),
          ),
        ] );
  }
}
