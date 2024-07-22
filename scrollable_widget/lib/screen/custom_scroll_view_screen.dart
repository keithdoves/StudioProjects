import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scrollable_widget/const/colours.dart';

//delegate : 어떤 파라미터를 받을 지, 정의만 한 것.

//SliverPersistentHeader의 delegate에는 SliverPersistentHeaderDelegate를 상속한
//class를 만들어야 함
class _SilverFixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  _SilverFixedHeaderDelegate(
      {required this.child, required this.maxHeight, required this.minHeight});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  //최대 높이
  double get maxExtent => maxHeight;

  @override
  // 최소 높이
  double get minExtent => minHeight;

  @override
  //covariant - 상속된 클래스도 사용가능
  // : SliverPersistentHeaderDelegate를 상속한 클래스도 가능
  // oldDelegate - build가 실행 됐을 때, 이전 Delegate
  // this : delegate
  //shouldRebuild - 새로 build를 해야할지 말지 결정
  // return false면 죽어도 bulid 다시 안 함
  bool shouldRebuild(_SilverFixedHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}

class CustomScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  CustomScrollViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //이 파라미터 안에 들어갈 수 있는 위젯은 모두 앞에 sliver가 붙음
          renderSliverAppbar(),
          renderHeader(),
          renderSliverGridBuilder(),
          renderHeader(),
          renderBuilderSliverList(),
        ],
      ),
    );
  }

  //
  SliverPersistentHeader renderHeader() {
    return SliverPersistentHeader(
      pinned: true, //여러 해더가 쌓임.
      delegate: _SilverFixedHeaderDelegate(
        child: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              'WOW',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
              ),
            ),
          ),
        ),
        minHeight: 50,
        maxHeight: 150,
      ),
    );
  }

  //Appbar_1
  //
  SliverAppBar renderSliverAppbar() {
    return SliverAppBar(
      backgroundColor: Colors.blue,
      //스크롤 중간에도 위로 스크롤 하면 AppBar가 내려와 보이게 됨.
      floating: true,
      //완전 고정
      pinned: false,
      //자석효과_ AppBar가 보여지는 상태가 중간이 없음. 완전 있음 또는 완전 없음만 있음.
      //floating이 true에만 사용가능
      snap: false,
      //맨 위에서 한계이상으로 스크롤 하면 scaffold구조가 보임
      //stretch는 AppBar가 한계이상으로 차지하도록 만듬.
      stretch: true,
      //최대높이 - 앱바 최대 높이/ 위로 스크롤해서 앱바가 다시생길 때 최대 높이
      expandedHeight: 120,
      //최소높이 - 앱바가 사라질 때 밀려들어가는 높이
      collapsedHeight: 60,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'FlexibleSpace',
        ),
        background: Image.asset(
          'asset/img/image_1.jpeg',
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        'CustomSrollViewScreen',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  //1
  //모든 위젯을 한 번에 그림
  //ListView 기본 생성자와 비슷함
  SliverList renderChildSliverList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        numbers
            .map(
              (e) => renderContainer(
                color: rainbowColors[e % rainbowColors.length],
                index: e,
              ),
            )
            .toList(),
      ),
    );
  }

  //2
  //listView.builder 생성자와 유사함
  SliverList renderBuilderSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        //보이는 것만 랜더
        //builder함수를 named parameter에 넣었는데, 여기에는 그냥 첫 인자로 넣음
        (context, index) {
          return renderContainer(
              color: rainbowColors[index % rainbowColors.length], index: index);
        },
        childCount: 10, //갯수
      ),
    );
  }

  //3
  //GridView.count와 유사함

  SliverGrid renderChildSliverGrid() {
    return SliverGrid(
      delegate: SliverChildListDelegate(
        //그냥 list를 때려박으면 되지만, 성능 안 좋음.
        numbers
            .map(
              (e) => renderContainer(
                color: rainbowColors[e % rainbowColors.length],
                index: e,
              ),
            )
            .toList(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  //4
  //GridView.builder와 유사함
  SliverGrid renderSliverGridBuilder() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return renderContainer(
              color: rainbowColors[index % rainbowColors.length], index: index);
        },
        childCount: 100,
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
      ),
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
