import 'package:flutter/material.dart';

import '../../common/const/responsive.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.tabletBody,
    required this.desktopBody,
    required this.desktopWideBody,
    required this.desktopExtraWideBody,
  });

  // 각 레이아웃에 해당하는 위젯들
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;
  final Widget desktopWideBody;
  final Widget desktopExtraWideBody;


  @override
  Widget build(BuildContext context) {
    // 현재 화면의 너비를 가져옴
    final double screenWidth = MediaQuery.of(context).size.width;

    // 화면 너비에 따라 적절한 레이아웃을 반환
    // (가장 큰 너비부터 확인해야 함)
    if (screenWidth >= DESKTOP_EXTRA_WIDE_MIN_WIDTH -160.0) {
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
    }
  }
}