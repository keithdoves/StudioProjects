// providers.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. NotifierProvider를 정의합니다.
// autoDispose를 사용하여 MobileLayout이 사라지면 Notifier도 함께 파괴됩니다.
final mobileScrollNotifierProvider =
NotifierProvider.autoDispose<MobileScrollNotifier, double>(() {
  return MobileScrollNotifier();
});

// 2. Notifier 클래스를 정의합니다.
// <double>은 이 Notifier가 관리할 상태의 타입(tabSpacing)을 의미합니다.
class MobileScrollNotifier extends AutoDisposeNotifier<double> {
  // Notifier가 관리할 ScrollController
  late final ScrollController scrollController;

  // Notifier가 생성될 때 초기 상태와 로직을 설정합니다.
  @override
  double build() {
    scrollController = ScrollController();

    scrollController.addListener(_onScroll);

    // Notifier가 파괴될 때 ScrollController도 함께 dispose합니다.
    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });

    // 초기 상태값(tabSpacing)은 0.0입니다.
    return 0.0;
  }

  // 스크롤 리스너 로직
  void _onScroll() {
    final offset = scrollController.offset;
    // 조건에 따라 상태(state)를 직접 업데이트합니다.
    // state는 Notifier가 관리하는 현재 값(tabSpacing)을 의미합니다.
    if (offset > 100) {
      if (state != 150) {
        state = 150;
      }
    } else {
      if (state != 0) {
        state = 0;
      }
    }
  }
}