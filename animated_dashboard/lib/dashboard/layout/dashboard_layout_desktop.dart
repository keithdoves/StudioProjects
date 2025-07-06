import 'package:flutter/material.dart';

import '../component/measurable_container.dart';

class DashboardLayoutDesktop extends StatelessWidget {
  const DashboardLayoutDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면의 너비를 기준으로 높이를 계산하여 비율을 유지

    final screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = 0.0;
    if(screenHeight>1240){
      screenHeight = 1240.0 * 0.7;
    }else{
      screenHeight = screenWidth * 0.7;
    }


    // 1. SingleChildScrollView로 전체를 감쌉니다.

    return SingleChildScrollView(
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
                              child: AspectRatio(
                                // Wrap A1 with AspectRatio
                                aspectRatio: 1 / 1, // Makes it a square

                                child: MeasurableContainer(
                                  text: 'A1',

                                  color: Colors.white.withAlpha(40),

                                  minWidth: 300,

                                  maxHeight: 300,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 1,

                              child: AspectRatio(
                                // Wrap A2 with AspectRatio
                                aspectRatio: 1 / 1, // Makes it a square

                                child: MeasurableContainer(
                                  text: 'A2',

                                  color: Colors.white.withAlpha(40),

                                  minWidth: 300,

                                  maxHeight: 300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 25,

                        child: Align(
                          alignment: Alignment.topLeft,

                          child: MeasurableContainer(
                            text: 'A3',

                            color: Colors.white.withAlpha(40),

                            minWidth: 300,
                          ),
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
