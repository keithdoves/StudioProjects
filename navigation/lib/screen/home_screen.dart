import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';
import 'package:navigation/screen/route_one_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, //pop을 막을 지 여부. 안드로이드의 시스템 뒤로가기를 막음
      onPopInvoked: (bool didPop) {
        // didPop은 pop이 되었는지 여부를 알려줌.
        // 여기에는 pop 시도가 발생했을 때의 처리를 작성//
      },
      child: MainLayout(
        title: 'Home Screen',
        children: [
          //maybePop은 스텍에 뒤로 갈 페이지가 없으면 아무것도 안함.
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            child: const Text('maybePop'),
          ),

          ElevatedButton(
              onPressed: () {
                //canPop은 현재 페이지가 pop할 수 있는지 확인함.
                print(Navigator.of(context).canPop());
              },
              child: const Text('Can Pop')),
          //HomeScreen만 있는데, pop하면 앱이 종료됨.
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('pop')),
          ElevatedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const RouteOneScreen(
                      number: 123,
                    ),
                  ),
                );
              },
              child: const Text('Push')),
        ],
      ),
    );
  }
}
