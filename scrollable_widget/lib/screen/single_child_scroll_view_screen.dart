import 'package:flutter/material.dart';
import 'package:scrollable_widget/const/colours.dart';
import 'package:scrollable_widget/layout/main_layout.dart';

class SingleChildScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(
      100, (index) => index); //100개 만듬


   SingleChildScrollViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        title: 'SingleChildScrollViewScreen',
        //기본은 스크롤이 안되고, 위젯으로 인해 화면이 넘어가면 스크롤이 됨
        body: renderClip(),
    );
  }

  //1
  //기본 랜더링법
  Widget renderSimple() {
    return SingleChildScrollView(
      child: Column(
        children: rainbowColors.map((e) => renderContainer(color: e)).toList(),
      ),
    );
  }
  //2
  //화면을 넘어서지 않아도 스크롤 되게하기
  Widget renderAlwaysScroll(){
    return SingleChildScrollView(
      //NeverScrollableScrollPhysics - 스크롤 안 됨
      physics: AlwaysScrollableScrollPhysics(), //스크롤 됨
      //화면을 넘어서지 않도록 스크롤이 되도록 할 수 있음
      child: Column(
        children: [
          renderContainer(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
  //3
  //위젯이 잘리지 않게 하기
  Widget renderClip(){
    return SingleChildScrollView(
      clipBehavior: Clip.none, //잘렸을 때, 어떻게 할지
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          renderContainer(
            color: Colors.black,
          ),
        ],
      ),
    );

  }

  //4
  //OS별 스크롤 구현
  Widget renderPhysics(){
    return SingleChildScrollView(
      //BouncingScrollPhysics - iOS 스타일(상단 땡김 가능)
      //ClampingScrollPhysics - Android 스타일(상단 안 당겨짐)
      physics: ClampingScrollPhysics(),
      child: Column(
        children: rainbowColors.map(
                (e) => renderContainer(color: e))
            .toList(),
      ),
    );
  }
  //5
  //singleShildScrollView 퍼포먼스
  Widget renderPerformance(){
    return SingleChildScrollView(
      child: Column(
        children: numbers.map(
                (e)=>renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e,
            ) //이렇게 하면 0부터 6까지 숫자를 계속 갖고 올 수 있음
        ).toList(),


      ),
    );
  }


  Widget renderContainer({required Color color,
                          int? index
  }) {
    if(index != null){
      print(index);
    }
    return Container(
      height: 300,
      color: color,
    );
  }
}
