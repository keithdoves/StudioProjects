import 'package:animated_dashboard/dashboard/component/chart/gague_label_chart.dart';
import 'package:animated_dashboard/dashboard/component/chart/sankey_chart.dart';
import 'package:animated_dashboard/dashboard/component/chart_container.dart';
import 'package:animated_dashboard/dashboard/component/white_chart_container.dart';
import 'package:flutter/material.dart';


import '../component/measurable_container.dart';

class DashboardLayoutDesktop extends StatelessWidget {
  const DashboardLayoutDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면의 너비를 기준으로 높이를 계산하여 비율을 유지

    final screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = 0.0;
    if (screenHeight > 1240) {
      screenHeight = 1240.0 * 0.7;
    } else {
      screenHeight = screenWidth * 0.7;
    }

    final List<int> numbers = List.generate(7, (i) => i);

    // 1. SingleChildScrollView로 전체를 감쌉니다.

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(8.0, 200, 24.0, 8.0),
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
                    children: [
                      Expanded(
                        flex: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ChartContainer(
                                color: Colors.white,
                                boxContents: Column(
                                  children: [
                                    Text('Desktop Layout'),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: GaugeLabelChart(
                                              labelText: '$screenWidth',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text('Mark Lettieri Lettieri'),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GaugeLabelChart(
                                              labelText: '$screenWidth',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text('Mark Lettieri Lettieri'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                text: 'A1',
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: ChartContainer(
                                color: Colors.white,
                                boxContents: Column(
                                  children: [
                                    Text('Desktop Layout'),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: GaugeLabelChart(
                                              labelText: '$screenWidth',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text('Mark Lettieri Lettieri'),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GaugeLabelChart(
                                              labelText: '$screenWidth',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text('Mark Lettieri Lettieri'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                text: 'A1',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 25,
                        child: ChartContainer(
                          boxContents: Column(
                            children: [
                              Text('프로젝트 TR 현황'),
                              SizedBox(height: 100,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.separated(
                                    separatorBuilder: (_,_)=> Divider(),
                                    itemCount: numbers.length,
                                    itemBuilder: (_, index) => Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white.withAlpha(90), width: 2.0),
                                      ),
                                      height: 100.0,
                                      child: Text('${numbers[index]}'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          text: 'A2',
                          color: Colors.white,
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
            height: 300,
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
          SizedBox(
            height: 650,
            child: WhiteChartContainer(
              boxContents: SankeyChart(),
              text: 'sankey',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
