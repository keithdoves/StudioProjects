import 'dart:ui';

import 'package:flutter/material.dart';

import '../../common/animation/animation.dart';
import '../transition/bottom_bar_transition.dart';

class DisappearingBottomNavigationBar extends StatelessWidget {
  const DisappearingBottomNavigationBar({
    super.key,
    required this.barAnimation,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final BarAnimation barAnimation;

  @override
  Widget build(BuildContext context) {
    return BottomBarTransition(
      animation: barAnimation,
      backgroundColor: Colors.transparent,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 10.0),
          child: NavigationBar(
            labelTextStyle: WidgetStatePropertyAll(
              const TextStyle(
                color: Colors.white,
                fontSize: 12, // 원하는 폰트 크기
                fontWeight: FontWeight.w500, // 원하는 폰트 굵기
                // 여기에 다른 TextStyle 속성들을 추가할 수 있습니다.
              ),
            ),
            indicatorColor: Colors.transparent,
            elevation: 0,
            backgroundColor: Colors.transparent,
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.accessibility_new_outlined,
                  color: Colors.white,
                ),
                label: 'Screen 1',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.car_crash_outlined,
                  color: Colors.white,
                ),
                label: 'Screen 2',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                label: 'Screen 3',
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
        ),
      ),
    );
  }
}
