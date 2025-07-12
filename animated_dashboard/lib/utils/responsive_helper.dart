import 'package:flutter/material.dart';

import '../common/const/responsive.dart';

// 기준이 되는 너비(Breakpoint)를 상수로 정의해두면 관리하기 편합니다.

const double kDesktopExtraWideBreakpoint = DESKTOP_EXTRA_WIDE_MIN_WIDTH -160.0;
const double kDesktopWideMinBreakpoint = DESKTOP_WIDE_MIN_WIDTH+80.0;
const double kDesktopMinBreakpoint = DESKTOP_MIN_WIDTH+1.0;
const double kTabletBreakpoint = TABLET_MIN_WIDTH; // 786
const double kMobileBreakpoint = MOBILE_MAX_WIDTH; // 440

extension ResponsiveHelper on BuildContext {
  // 현재 화면의 너비를 가져오는 getter

/* if (screenWidth >= DESKTOP_EXTRA_WIDE_MIN_WIDTH -160.0) {
  // 1440px 이상 (매우 넓은 데스크톱)
  return desktopExtraWideBody;
  } else if (screenWidth >= DESKTOP_WIDE_MIN_WIDTH+80.0) {
  // 1280px 이상 (넓은 데스크톱)
  return desktopWideBody;
  } else if (screenWidth >= DESKTOP_MIN_WIDTH+1.0) {
  // 1024px 이상 (일반 데스크톱)
  return desktopBody;
  } else if (screenWidth >= TABLET_MIN_WIDTH) {
  // 768px 이상 (태블릿)
  return tabletBody;
  } else {
  // 768px 미만 (모바일)
  return mobileBody;
  }*/

  double get screenWidth => MediaQuery.sizeOf(this).width;
  // 너비에 따라 다른 값을 반환하는 getter들을 만듭니다.

  // 예시 1: Horizontal Padding
  double get paddingHorizontal {
    if (screenWidth >= kDesktopExtraWideBreakpoint) {
      return 16.0;
    } else if (screenWidth >= kDesktopWideMinBreakpoint) {
      // 태블릿 화면
      return 16.0;
    } else if (screenWidth >= kDesktopMinBreakpoint) {
      // 태블릿 화면
      return 12.0;
    } else if (screenWidth >= kTabletBreakpoint) { //786
      // 태블릿 화면
      return 8.0;
    }
    else if (screenWidth >= kMobileBreakpoint) { //440
      // 미니 태블릿 화면
      return 6.0;
    }
    else {
      // 모바일 화면
      return 4.0;
    }
  }

  // 예시 2: 타이틀 폰트 크기
  double get titleFontSize {
    if (screenWidth >= kDesktopExtraWideBreakpoint) {
      return 32.0;
    } else if (screenWidth >= kDesktopWideMinBreakpoint) {
      // 태블릿 화면
      return 26.0;
    } else if (screenWidth >= kDesktopMinBreakpoint) {
      // 태블릿 화면
      return 22.0;
    } else if (screenWidth >= kTabletBreakpoint) {
      // 태블릿 화면
      return 18.0;
    } else {
      // 모바일 화면
      return 12.0;
    }
  }

  // 예시 3: bool 값으로 특정 위젯을 보여줄지 결정
  bool get isMobile => screenWidth < kTabletBreakpoint;
}