import 'package:flutter/material.dart';

import '../component/measurable_container.dart';

class DashboardLayoutTablet extends StatelessWidget {
  const DashboardLayoutTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // A A: 상단 영역 (세로 2/5 차지)
          SizedBox(
            height: screenWidth * 0.27,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MeasurableContainer(
                    text: 'A1',
                    color: Colors.white.withAlpha(40),
                  ),
                ),
                Expanded(
                  child: MeasurableContainer(
                    text: 'A2',
                    color: Colors.white.withAlpha(40),
                  ),
                ),
              ],
            ),
          ),

          // C: 중간 영역 (세로 1/5 차지)
          SizedBox(
            height: screenWidth * 0.33,
            child: MeasurableContainer(
              text: 'C1',
              color: Colors.white.withAlpha(40),
            ),
          ),

          // B B: 하단 영역 (세로 2/5 차지)
          SizedBox(
            height: screenWidth * 0.6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MeasurableContainer(
                    text: 'B1',
                    color: Colors.white.withAlpha(40),
                  ),
                ),
                Expanded(
                  child: MeasurableContainer(
                    text: 'B2',
                    color: Colors.white.withAlpha(40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
