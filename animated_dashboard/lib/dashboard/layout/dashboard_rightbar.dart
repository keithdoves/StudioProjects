import 'package:flutter/material.dart';

import '../component/measurable_container.dart';

class DashboardRightBar extends StatelessWidget {
  DashboardRightBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = 0.0;
    if (screenWidth > 1400) {
      screenHeight = 1400.0;
    } else {
      screenHeight = screenWidth * 0.7;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 200, 24.0, 8.0),
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              Expanded(
                child: MeasurableContainer(
                  text: 'E1',
                  color: Colors.white.withAlpha(40),
                ),
              ),
              Expanded(
                child: MeasurableContainer(
                  text: 'E1',
                  color: Colors.white.withAlpha(40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
