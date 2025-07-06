import 'package:flutter/material.dart';

class SliverPersistentHeaders extends StatelessWidget {
  const SliverPersistentHeaders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter 3.24 CarouselView')),
      body: Center(
        child: SizedBox(
          height: 170,
          child: CarouselView(
            // ① 기본 uncontained 레이아웃
            itemExtent: 350, // 각 아이템의 너비(또는 높이)
            shrinkExtent: 80, // 끝 아이템이 축소될 최소 크기
            itemSnapping: false, // 스크롤 후 중앙 정렬
            children: List.generate(5, (i) {
              return Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  //color: Colors.primaries[i % Colors.primaries.length],
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image:
                        NetworkImage('https://picsum.photos/800/400?random=$i'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  'Item $i',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,         // 넘치는 부분은 말줄임표(…) 처리
                  softWrap: false,
                  textAlign: TextAlign.start,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
