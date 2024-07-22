import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../component/number_row.dart';
import '../constant/color.dart';

//StatefulWidget은 immutable하기 때문에 final로 선언.
//변하는 것은 State

class SettingScreen extends StatefulWidget {
  final int maxNumber;
  const SettingScreen({required this.maxNumber, super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double maxNumber = 1; //state에다가 widget키워드를 쓸 수 없음
  //state가 statefulWiget에 붙기 전에 여기 변수들이 생성되기 때문에 widget키워드를 가져올 수 없음
  @override
  void initState() {
    //상태변경이 아니라 StatefulWidget이 (재)생성 될 때 실행함
    maxNumber = widget.maxNumber.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Body(maxNumber: maxNumber),
              _Footer(
                onSliderChanged: onSliderChanged,
                maxNumber: maxNumber,
                onButtonPressed: onButtonPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSliderChanged(double val) {
    setState(() {
      //setState가 없으면  값은 변경되지만 화면에 반영되지 않음. 다시 랜더링하기 위해서 setState를 사용
      maxNumber = val;
    });
  }

  void onButtonPressed() {
    Navigator.of(context).pop(maxNumber.toInt()); //뒤로가기 - 현재 화면을 터트리다
    //pop에 넣어주면 데이터를 넘겨줌
  }
}

class _Body extends StatelessWidget {
  final double maxNumber;
  const _Body({required this.maxNumber, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NumberRow(
        number: maxNumber.toInt(),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final ValueChanged<double>? onSliderChanged;
  final VoidCallback onButtonPressed;
  final double maxNumber;

  const _Footer(
      {required this.onSliderChanged,
      required this.onButtonPressed,
      required this.maxNumber,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Slider(
          value: maxNumber,
          min: 1000,
          max: 100000,
          onChanged: onSliderChanged,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: RED_COLOR),
          onPressed: onButtonPressed,
          child: const Text(
            'Save!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );
  }
}
