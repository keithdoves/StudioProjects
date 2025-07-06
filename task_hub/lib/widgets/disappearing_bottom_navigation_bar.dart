import 'package:flutter/material.dart';

import '../animations.dart';
import '../destinations.dart';
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
      backgroundColor: Colors.white,
      child: NavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        destinations: destinations.map<NavigationDestination>((d) {
          return NavigationDestination(icon: Icon(d.icon), label: d.label);
        }).toList(),
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}