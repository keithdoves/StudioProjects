import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';
import 'route_three_screen.dart';

class RouteTwoScreen extends StatelessWidget {
  const RouteTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //of(context) = 가장 가까운 화면에서 갖고 올 수 있음.
    // 즉 아래 코드는 가장 가까운 화면에서 modalRoute(fullScreen)를 갖고 옴.
    final arguments = ModalRoute.of(context)!.settings.arguments;
    return MainLayout(
      title: 'route two',
      children: [
        Text(
          'arguments: $arguments',
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('pop'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/three',
                arguments: 999); //Main.dart에서 설정한 route name
          },
          child: const Text('push Named to Three'),
        ),
        ElevatedButton(
          onPressed: () {
            //현재화면을 없애고 새로운 화면을 띄움.(즉 현재 화면을 새 화면으로 교체)
            Navigator.of(context).pushReplacementNamed(
              '/three',
              arguments: 1423,
            );
          },
          child: const Text('Replace'),
        ),
        ElevatedButton(
          onPressed: () {
            //현재화면을 없애고 새로운 화면을 띄움.
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/three',
              //false로 하면 이전 화면이 없어짐.
              //three로 이동후, name이 '/'인 화면만 남김.(모든 이전 화면들을 제거하고 새로운 화면으로 이동|
              // 단,개발자가 지정한 조건에 맞는 라우트가 나올 떄까지 이전 라우트들을 제거)
              (route) => route.settings.name == '/',
              arguments: 11555,
            );
          },
          child: const Text(
            'pushAndRemoveUntil',
          ),
        ),
      ],
    );
  }
}
