import 'package:flutter/material.dart';
import 'package:scrollable_widget/layout/main_layout.dart';

import '../const/colours.dart';

class GridViewScreen extends StatelessWidget {


  List<int> numbers = List.generate(100, (index) => index);

  //final String title;

  GridViewScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return MainLayout(
      title: 'GridViewScreen',
      body: renderMaxExtent(),
    );
  }


   //3
   // 위젯의 최대 사이즈 설정

  Widget renderMaxExtent(){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 90, //위젯의 최대 길이를 정할 수 있음
        //만약 최대 200까지 차지할 수 있다면 200이상의 숫자를 설정해도 안 바뀜
      ),
      itemCount: 102,
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
    );

  }


   //2
  // 보이는 것만 그림
  Widget renderBuilder(){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
    );

  }


  //1
  // 한 번에 다 그림.
  Widget renderCount() {
    return GridView.count(
      //한 번에 다 그림(퍼포먼스 저하)
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      children: numbers
          .map(
            (e) => renderContainer(
                color: rainbowColors[e % rainbowColors.length], index: e),
          )
          .toList(),
    );
  }

  Widget renderContainer({
    required Color color,
    required int index,
    double? height,
  }) {
    print(index);

    return Container(
      height: height ?? 300,
      color: color,
      child: Center(
        child: Text(
          index.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
