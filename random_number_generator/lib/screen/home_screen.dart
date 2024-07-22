import 'dart:math';
import 'package:flutter/material.dart';
import '../component/number_row.dart';
import '../constant/color.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int maxNumber = 1000;
  List<int> randomNumbers = [
    123,
    456,
    789,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            //symmetric - 대칭이라는 뜻
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(onPressed: onSettingsPop),
              _body(
                randomNumbers: randomNumbers,
              ),
              _Footer(onPressed: onRandomNumberGenerate),
            ],
          ),
        ),
      ),
    );
  }

  void onRandomNumberGenerate() {
    final rand = Random();
    final Set<int> newNumbers = {};

    while (newNumbers.length != 3) {
      //set 자료형으로 중복 제거
      final number = rand.nextInt(maxNumber);
      newNumbers.add(number);
    }

    setState(() {
      randomNumbers = newNumbers.toList(); //새로운 랜덤 숫자로 변경
    });
  }

  void onSettingsPop() async {
    //이동한 화면으로부터 데이터를 받는 법은 Navigator를 변수로 선언해서 받을 수 있음
    //그러나 미래에 받을 것이기 때문에 async, await를 사용하여 받을 수 있음
    final int? result = await Navigator.of(
            context) //of(context)는 위젯 트리에서 가장 가까운 navigator을 가져다 줌
        .push<int>(
      //push에 <>제네릭으로 어떤 값을 리턴받을지, 정할 수 있음
      MaterialPageRoute(
        builder: (BuildContext context) => SettingScreen(
          maxNumber: maxNumber,
        ),
      ), //screen과 동의어라고 생각
    );

    print('result: $result');
    if (result != null) {
      //setState(() {
      maxNumber = result; //result는 null이 될 수 있음. 이전화면에서 스와이프로 넘어오면 저장 버튼 안누름.
      //});
    }
  } // 이 익명함수 부분 외우기
}

class _Header extends StatelessWidget {
  final VoidCallback onPressed;

  const _Header({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '랜덤숫자 생성기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.settings,
            color: RED_COLOR,
          ),
        ),
      ],
    );
  }
}

class _body extends StatelessWidget {
  final List<int> randomNumbers;

  const _body({required this.randomNumbers, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: randomNumbers
            .asMap() //맨 밑에만 padding 주지 않기 위해 entries를 사용하여 삼항연산자로 case 나눔
            .entries
            .map(
              (x) => Padding(
                padding: EdgeInsets.only(bottom: x.key == 2 ? 0 : 16.0),
                child: NumberRow(
                  number: x.value,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressed;

  const _Footer({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //컨테이너와 유사하나, 높이나 너비만 선택가능
      //Row는 가로로 다 채우는 성질이 있어, 자식에 expanded를 사용하면 좌우로 꽉차게 된다.
      //반대로 세로로 최소한으로 채우려는 성질이 있다.
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: RED_COLOR,
        ),
        onPressed: onPressed,
        child: const Text(
          '생성하기!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
