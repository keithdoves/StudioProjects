import 'package:flutter/material.dart';
import 'package:scrollable_widget/const/colours.dart';
import 'package:scrollable_widget/layout/main_layout.dart';

class ReorderableListViewScreen extends StatefulWidget {
  const ReorderableListViewScreen({super.key});

  @override
  State<ReorderableListViewScreen> createState() =>
      _ReorderableListViewScreenState();
}

class _ReorderableListViewScreenState extends State<ReorderableListViewScreen> {
  List<int> numbers = List.generate(100, (index) => index);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'ReorderableListViewScreen',
      body: ReorderableListView.builder(
        itemBuilder: (context, index) {
          return renderContainer(
            color: rainbowColors[numbers[index] % rainbowColors.length],
            index: numbers[index],
          );
        },
        itemCount: numbers.length,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }

            final item = numbers.removeAt(oldIndex);
            numbers.insert(newIndex, item);
          });
        },
      ),
    );
  }

  Widget renderDefault() {
    return ReorderableListView(
      children: numbers
          .map(
            (e) => renderContainer(
                color: rainbowColors[e % rainbowColors.length], index: e),
          )
          .toList(),
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          //경우 1
          //[red, orange, yellow]
          //[0, 1, 2]
          // red를 yellow 다음ㅇ로 옮기고 싶다.
          //red : 0 oldIndex-> 3 newIndex
          //어느 인덱스던 간에 값을 옮기기 전 인덱스로 상정한다
          //실제로 옮기고 난 다음 인덱스는 중요하지 않다(<- 우리가 할 일)
          //[orange, yellow, red]
          //
          //경우 2
          //[red, orange, yellow]
          //yellow를 red 전으로 옮기고 싶다
          // yellow : 2 oldIndex -> 0 newIndex
          // [yellow, red, orange]

          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final item = numbers.removeAt(oldIndex);
          numbers.insert(newIndex, item);
        });
      },
    );
  }

  Widget renderContainer({
    required Color color,
    required int index,
    double? height,
  }) {
    print(index);

    return Container(
      key: Key(index.toString()), //key가 업스면 시스템에서 Container를 구별할 수 없음
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
