import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassStackedAppbar extends StatelessWidget {
  const LiquidGlassStackedAppbar({required this.screenWidth, super.key});
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LiquidGlass(
          //blur: 3,
          settings: LiquidGlassSettings(
            ambientStrength: 0.2,
            lightAngle: 0.25 * math.pi,
            glassColor: Colors.white.withAlpha(10),
          ),
          shape: LiquidRoundedSuperellipse(
            borderRadius: const Radius.circular(40),
          ),
          glassContainsChild: false,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipOval(
              child: Image.asset(
                'assets/alex-suprun.jpg',
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이순신 AP5',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.group,
                  color: Colors.grey,
                  size: 15,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '조선 해군',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 40,
        ),
        Text(
          'Total Width $screenWidth',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        const Spacer(),
        LiquidGlass(
          //blur: 3,
          settings: LiquidGlassSettings(
            ambientStrength: 0.5,
            lightAngle: -0.2 * math.pi,
            glassColor: Colors.white12,
          ),
          shape: LiquidRoundedSuperellipse(
            borderRadius: const Radius.circular(40),
          ),
          glassContainsChild: false,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
