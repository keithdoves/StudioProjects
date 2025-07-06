import 'dart:ui';

import 'package:flutter/material.dart';

import '../animations.dart';
import '../transition/nav_rail_transition.dart';
import 'animated_floating_action_button.dart';

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
      animation: railAnimation,
      backgroundColor: backgroundColor,
      child: NavigationRail(
        extended: isExtended,
        selectedLabelTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        indicatorColor: Theme.of(context).colorScheme.primary.withAlpha(50),
        selectedIndex: selectedIndex,
        backgroundColor: backgroundColor,
        onDestinationSelected: onDestinationSelected,
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
                const SizedBox(height: 8),
                AnimatedFloatingActionButton(
                  animation: railFabAnimation,
                  elevation: 0,
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
        groupAlignment: -0.85,
        destinations: const [
          NavigationRailDestination(icon: Icon(Icons.accessibility_new_outlined), label: Text('Screen 1')),
          NavigationRailDestination(icon: Icon(Icons.car_crash_outlined), label: Text('Screen 2')),
          NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Screen 3')),
        ],
      ),
    );
  }
}
