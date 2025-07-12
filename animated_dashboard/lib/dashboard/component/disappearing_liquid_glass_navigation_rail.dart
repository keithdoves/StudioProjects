import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../common/animation/animation.dart';
import '../transition/nav_rail_transition.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class DisappearingLiquidGlassNavigationRail extends StatelessWidget {
  const DisappearingLiquidGlassNavigationRail({
    super.key,
    required this.railFabAnimation,
    required this.railAnimation,
    required this.backgroundColor,
    required this.selectedIndex,
    required this.isExtended,
    this.onDestinationSelected,
  });

  final RailAnimation railAnimation;
  final RailFabAnimation railFabAnimation;
  final Color backgroundColor;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final bool isExtended;

  // 1. 데이터 리스트 정의
  static final _destinations = [
    {'icon': Icons.home_outlined, 'label': 'Home Home Home'},
    {'icon': Icons.favorite_border_rounded, 'label': 'Favoritas mia'},
    {'icon': Icons.person_outline, 'label': 'Profile'},
    {'icon': Icons.home_outlined, 'label': 'Home Home Home'},
    {'icon': Icons.favorite_border_rounded, 'label': 'Favoritas mia'},
    {'icon': Icons.person_outline, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return NavRailTransition(
      backgroundColor: Colors.transparent,
      animation: railAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Card(
          elevation: 12.0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: LiquidGlassLayer(
            settings: LiquidGlassSettings(
              blur: 5,
              ambientStrength: 2.5,
              lightAngle: 0.2 * math.pi,
              glassColor: Colors.white12,
              lightIntensity: 1.0,
                thickness : isExtended ? 25 : 20,

            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              alignment: Alignment.center, // 왼쪽 정렬로 변경하면 더 자연스러울 수 있음
              child: LiquidGlass.inLayer(
                shape: LiquidRoundedSuperellipse(
                  borderRadius: const Radius.circular(40),
                ),
                glassContainsChild: false,
                // 2. Column을 AnimatedSwitcher를 사용하도록 수정
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: _destinations.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final destination = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isExtended
                              ? Row(
                                  key: ValueKey('extended_$index'),
                                  children: [
                                    Icon(
                                      destination['icon'] as IconData,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      destination['label'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : Icon(
                                  key: ValueKey('icon_$index'),
                                  destination['icon'] as IconData,
                                  color: Colors.white,
                                  size: 24,
                                ),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          // 레이아웃이 변경될 때 자연스러운 전환을 위해 추가
                          layoutBuilder: (currentChild, previousChildren) {
                            return Stack(
                              alignment: Alignment.centerLeft,
                              children: <Widget>[
                                ...previousChildren,
                                if (currentChild != null) currentChild,
                              ],
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
