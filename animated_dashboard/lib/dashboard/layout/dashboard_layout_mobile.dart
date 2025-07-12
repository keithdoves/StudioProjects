import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../component/chart/gauge_chart.dart';
import '../component/measurable_container.dart';
import '../provider/scroll_controller_provider.dart';

class DashboardLayoutMobile extends ConsumerStatefulWidget {
  const DashboardLayoutMobile({super.key});

  @override
  ConsumerState<DashboardLayoutMobile> createState() =>
      _DashboardLayoutMobileState();
}

class _DashboardLayoutMobileState extends ConsumerState<DashboardLayoutMobile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // NotifierProvider로부터 Notifier 인스턴스를 얻고,
    // 그 안의 scrollController를 가져옵니다.
    final scrollController = ref
        .read(mobileScrollNotifierProvider.notifier)
        .scrollController;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.only(
        top: 188,
        left: 4,
        right: 4,
        bottom: 60,
      ),
      child: Column(
        //나중에 파라미터로 받기
        children: [
          // 1. A1/A2를 가로로 배치 (2열)
          SizedBox(
            height: screenWidth * 0.4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GaugeChart(),
                ),
                Expanded(
                  child: GaugeChart()
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenWidth * 0.4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GaugeChart(),
                ),
                Expanded(
                  child: GaugeChart(),
                ),
              ],
            ),
          ),
          // 2. A3 (1열)
          MeasurableContainer(
            text: 'A3',
            color: Colors.white.withAlpha(40),
            minWidth: 300,
            maxHeight: 300,
          ),
          // 3. B1 (1열)
          MeasurableContainer(
            text: 'B1',
            color: Colors.white.withAlpha(40),
            minWidth: 300,
            maxHeight: 300,
          ),
          // 4. B2 (1열)
          MeasurableContainer(
            text: 'B2',
            color: Colors.white.withAlpha(40),
            minWidth: 300,
            maxHeight: 300,
          ),
          // 5. C1 (1열)
          SizedBox(
            height: screenWidth * 0.3,
            child: Row(
              children: [
                Expanded(
                  child: MeasurableContainer(
                    text: 'C1',
                    color: Colors.white.withAlpha(40),
                    minWidth: 300,
                  ),
                ),
                // 6. C2 (1열)
                Expanded(
                  child: MeasurableContainer(
                    text: 'C2',
                    color: Colors.white.withAlpha(40),
                    minWidth: 300,
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
