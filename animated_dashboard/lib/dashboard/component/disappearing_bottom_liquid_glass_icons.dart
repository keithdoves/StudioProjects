import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../common/animation/animation.dart';
import '../transition/bottom_bar_transition.dart';

class DisappearingBottomLiquidGlassIcons extends StatelessWidget {
  const DisappearingBottomLiquidGlassIcons({
    super.key,
    required this.tabSpacing,
    required this.onPressed,
    required this.isHomeSelected,
    required this.barAnimation,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final double tabSpacing;
  final VoidCallback onPressed;
  final bool isHomeSelected;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final BarAnimation barAnimation;

  @override
  Widget build(BuildContext context) {
    return BottomBarTransition(
      animation: barAnimation,
      backgroundColor: Colors.transparent,
      child: Padding(
        //Start of Bottom Navigation Bar
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: LiquidGlassLayer(
          settings: LiquidGlassSettings(
            ambientStrength: 0.5,
            lightAngle: 0.2 * math.pi,
            glassColor: Colors.white12,
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LiquidGlass.inLayer(
                  //blur: 3,
                  shape: LiquidRoundedSuperellipse(
                    borderRadius: const Radius.circular(40),
                  ),
                  glassContainsChild: false,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        IconButton(
                          icon: Icon(Icons.home_outlined),
                          color: Colors.white,
                          iconSize: 24,
                          selectedIcon: Icon(Icons.home),
                          isSelected: isHomeSelected,
                          onPressed: onPressed,
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.all(
                            8.0,
                          ),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: tabSpacing),
                  duration: const Duration(milliseconds: 600),
                  curve: ElasticOutCurve(0.76),//Curves.elasticOut,
                  builder: (context, spacing, child) {
                    // 애니메이션 값이 음수가 되지 않도록 clamp 처리
                    return SizedBox(
                      width: spacing.clamp(0.0, double.infinity),
                      height: 0,
                    );
                  },
                ),
                LiquidGlass.inLayer(
                  //blur: 3,
                  shape: LiquidRoundedSuperellipse(
                    borderRadius: const Radius.circular(40),
                  ),
                  glassContainsChild: false,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
