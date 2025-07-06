import 'package:flutter/material.dart';

class SliverResizingHeaderScreen extends StatelessWidget {
  const SliverResizingHeaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1) SliverPersistentHeader 로 “리사이징 헤더” 구현
          SliverPersistentHeader(
            pinned: true,     // 스크롤 올릴 때 헤더가 탑에 고정
            delegate: _HeaderDelegate(
              minExtent: 80,  // 스크롤했을 때 최소 높이
              maxExtent: 200, // 펼쳐졌을 때 최대 높이
            ),
          ),

          // 2) 내용 스크롤
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                title: Text('아이템 #$index'),
              ),
              childCount: 50,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
  });

  @override
  final double minExtent;
  @override
  final double maxExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // shrinkOffset: maxExtent에서 얼마나 스크롤되었는지
    final progress = (1 - (shrinkOffset / (maxExtent - minExtent))).clamp(0.0, 1.0);
    // progress: 1.0 → fully expanded, 0.0 → fully collapsed

    return Container(
      color: Colors.blue,
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(16),
      child: Opacity(
        opacity: progress,
        child: Text(
          'Resizable Header',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24 * (0.5 + 0.5 * progress), // 크기에 따라 텍스트 크기 변화
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate old) {
    return old.minExtent != minExtent || old.maxExtent != maxExtent;
  }
}