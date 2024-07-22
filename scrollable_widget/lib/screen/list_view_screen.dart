import 'package:flutter/material.dart';
import 'package:scrollable_widget/const/colours.dart';
import 'package:scrollable_widget/layout/main_layout.dart';

class ListViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  ListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        title: 'ListViewScreen',
        body: renderSeperated(),
    );
  }

  Widget renderSeperated(){

    return ListView.separated(
      itemCount: 100,
      itemBuilder: (context, index) => renderContainer(
        color: rainbowColors[index % rainbowColors.length],
        index: index,
      ),
      separatorBuilder: (context, index) {
        index += 1;
        if(index % 5 == 0) {
          return renderContainer(
            color: Colors.black,
            index: index,
            height: 100,
          );
        }

        return Container();
      },
    );
  }

  //2
  //화면에 보이는 것만 랜더링 함.
  Widget renderBuilder() => ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) => renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        ),
      );

  //1
  Widget renderDefault() {
    return ListView(
      //SingleChildScrollView는 child로 받아서
      // 컬럼에 감싼 다음에 여러 위젯을 랜더링 할 수 있었음
      children: numbers
          .map((e) => renderContainer(
                color: rainbowColors[e % rainbowColors.length],
                index: e,
              ))
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
