import 'package:animated_dashboard/dashboard/component/chart_container.dart';
import 'package:flutter/material.dart';

import '../component/chart/gague_label_chart.dart';
import '../component/chart/stacked_bar_chart.dart';
import '../component/measurable_container.dart';

class DashboardLayoutExtremeWideDesktop extends StatelessWidget {
  const DashboardLayoutExtremeWideDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면의 너비를 기준으로 높이를 계산하여 비율을 유지
    final screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = 0.0;
    if (screenWidth > 1400) {
      screenHeight = 1400.0 * 0.7;
    } else {
      screenHeight = screenWidth * 0.7;
    }

    // 1. SingleChildScrollView로 전체를 감쌉니다.
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 200.0),
      child: Column(
        children: [
          // 2. 상단 A/B 섹션에 화면 너비에 비례하는 높이를 지정합니다.
          SizedBox(
            // 예시: 너비의 70%를 높이로 사용 (비율 조절 가능)
            height: screenHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 이 내부의 Expanded들은 부모(SizedBox)의 명확한 높이 덕분에 정상 작동합니다.
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- 변경된 부분 시작 ---
                      // A 섹션을 2x2 그리드 형태로 변경
                      Expanded(
                        flex: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          // 자식들의 너비나 높이를 부모와 같게 만들어주는 옵션
                          children: [
                            // 왼쪽 열 (기존 A1 영역)
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // A1 상단
                                  Expanded(
                                    child: ChartContainer(
                                      text: 'A1',
                                      color: Colors.white.withAlpha(40),
                                      boxContents: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 8.0,
                                            ),
                                            child: Text(
                                              '유틸 인원',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    width: 1,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: GaugeLabelChart(
                                                    labelText: '37 명',
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text('Flexible'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // A1 하단
                                  Expanded(
                                    child: MeasurableContainer(
                                      text: 'A1',
                                      color: Colors.white.withAlpha(40),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 오른쪽 열 (기존 A2 영역)
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // A2 상단
                                  Expanded(
                                    child: MeasurableContainer(
                                      text: 'A2',
                                      color: Colors.white.withAlpha(40),
                                    ),
                                  ),
                                  // A2 하단
                                  Expanded(
                                    child: MeasurableContainer(
                                      text: 'A2',
                                      color: Colors.white.withAlpha(40),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // --- 변경된 부분 끝 ---
                      Expanded(
                        flex: 25,
                        child: ChartContainer(
                          text: 'A3',
                          color: Colors.white,
                          boxContents: StackedBarChart(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: MeasurableContainer(
                          text: 'B1',
                          color: Colors.white.withAlpha(40),
                          minWidth: 300,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: MeasurableContainer(
                          text: 'B2',
                          color: Colors.white.withAlpha(40),
                          minWidth: 300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 3. 하단 C 섹션에도 고정 높이를 부여합니다.
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MeasurableContainer(
                    text: 'C1',
                    color: Colors.white.withAlpha(40),
                    minWidth: 150,
                  ),
                ),
                Expanded(
                  child: MeasurableContainer(
                    text: 'C2',
                    color: Colors.white.withAlpha(40),
                    minWidth: 150,
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
