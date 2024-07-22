import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TestWidget(label: 'test1'),
          //이처럼 빌드 타임에 모든 값을 알 수 있을 때 const 사용
          //const로 위젯을 선언하면, 다음에 build가 실행될 때, 이미 그려놨던 위젯을 그대로 사용한다.
          TestWidget(label: 'test2'),
          ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text('Build!'))
        ],
      ),
    ));
  }
}

class TestWidget extends StatelessWidget {
  final String label;

  const TestWidget({
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('$label Build 실행');
    return Container(
      child: Text(
        label,
      ),
    );
  }
}
