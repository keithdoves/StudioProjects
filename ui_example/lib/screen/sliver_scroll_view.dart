import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:ui_example/const/colours.dart';

class SliverScrollView extends StatelessWidget {
  final List<int> numbers = List.generate(100, (i) => i);

  SliverScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          renderSliverAppBar(),
          renderHeader(),
          renderSliverGrid(),
        ],
      ),
    );
  }

  // Appbar

  SliverAppBar renderSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      collapsedHeight: 75,
      backgroundColor: Colors.black,
      title: Text(
        'Seoul',
      ),
      titleTextStyle: TextStyle(
          color: Colors.blueGrey,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          fontStyle: FontStyle.italic),
      stretch: true,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double opacity =
              ((constraints.biggest.height - 150) / 200).clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            title: Opacity(
              opacity: opacity, // 기본적으로 투명하게 설정
              child: Icon(
                Icons.gesture_outlined,
                color: Colors.white38,
                size: 40,
              ),
            ),
            background: Image.asset(
              'asset/img/image.png',
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  SliverGrid renderSliverGrid() {
    return SliverGrid(
      delegate: SliverChildListDelegate(
        numbers
            .map((e) => Container(
                  color: rainbowColors[e % rainbowColors.length],
                  height: 100,
                ))
            .toList(),
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
      ),
    );
  }

  SliverPersistentHeader renderHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: PersistentHeaderForExample(
        maxHeight: 25.0,
        minHeight: 24.0,
      ),
    );
  }
}

class PersistentHeaderForExample extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;

  PersistentHeaderForExample(
      {required this.maxHeight, required this.minHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
      color: Colors.black54,
      height: maxHeight,
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => maxHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(PersistentHeaderForExample oldDelegate) {
return oldDelegate.minHeight != minHeight ||
    oldDelegate.maxHeight != maxHeight;
  }
}
