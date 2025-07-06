import 'dart:math' as math; // LiquidGlassSettings의 lightAngle에 필요
import 'package:flutter/material.dart';
import '../../common/animation/animation.dart';
import '../transition/nav_rail_transition.dart';
import 'animated_floating_action_button.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class DisappearingNavigationRail extends StatelessWidget {
  const DisappearingNavigationRail({
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

  @override
  Widget build(BuildContext context) {
    return NavRailTransition(
      backgroundColor: Colors.white.withAlpha(10),
      animation: railAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Card(
          elevation: 12.0,
          color:Colors.transparent, // 패널의 기본 반투명 배경색
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: NavigationRail(
            backgroundColor: Colors.transparent,
            extended: isExtended,
            selectedLabelTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            // 선택된 아이콘의 배경(Indicator)은 투명하게 하여 유리 효과가 가려지지 않게 함
            indicatorColor: Colors.transparent,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu, color: Colors.white),
                ),
                const SizedBox(height: 16),
                AnimatedFloatingActionButton(
                  animation: railFabAnimation,
                  elevation: 0,
                  onPressed: () {},
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            groupAlignment: -0.85,
            // destinations의 각 아이콘을 LiquidGlass로 감쌉니다.
            destinations: [
              _buildLiquidGlassDestination(
                icon: Icons.accessibility_new_outlined,
                label: 'Screen 1',
              ),
              _buildLiquidGlassDestination(
                icon: Icons.car_crash_outlined,
                label: 'Screen 2',
              ),
              _buildLiquidGlassDestination(
                icon: Icons.settings,
                label: 'Screen 3',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 반복되는 코드를 줄이기 위해 별도의 메서드로 추출
  NavigationRailDestination _buildLiquidGlassDestination({
    required IconData icon,
    required String label,
  }) {
    return NavigationRailDestination(
      // icon 속성에 LiquidGlass 위젯을 적용
      icon: LiquidGlass(
        shape: LiquidOval(), // 동그란 유리 모양
        glassContainsChild: false, // 아이콘이 유리 위에 렌더링되도록 설정
        settings: LiquidGlassSettings(
          lightAngle: 0.2 * math.pi,
          glassColor: Colors.white.withAlpha(80), // 유리 자체의 희미한 색
          ambientStrength: 0.5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Colors.white),
        ),
      ),
      label: Text(label),
    );
  }
}