import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WideGaugeChart extends StatefulWidget {
  const WideGaugeChart({super.key});

  @override
  State<WideGaugeChart> createState() => _WideGaugeChartState();
}

class _WideGaugeChartState extends State<WideGaugeChart> {
  bool isMobile = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        // 1. 전체 위젯의 비율을 2:1로 강제하는 AspectRatio를 최상단에 배치
        return AspectRatio(
          aspectRatio: 2.0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black54.withAlpha(80),
              border: Border.all(color: Colors.white.withAlpha(90), width: 2.0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              // Column 자식들의 정렬은 그대로 유지
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      const Text(
                        '부서 인원',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8), // 제목과 차트 사이 간격
                // 2. Expanded를 사용해 제목을 제외한 '나머지 모든 세로 공간'을 차지
                Expanded(
                  // Row나 다른 위젯으로 감쌀 필요 없이 바로 Stack을 배치
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            PieChart(
                              PieChartData(
                                // ... 이전과 동일한 PieChartData
                                pieTouchData: PieTouchData(),
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 2,
                                centerSpaceRadius: constraints.maxWidth / 7,
                                sections: showingSections(),
                              ),
                            ),
                            const Center(
                              child: Text(
                                '36 명',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            PieChart(
                              PieChartData(
                                // ... 이전과 동일한 PieChartData
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 2,
                                centerSpaceRadius: constraints.maxWidth / 7,
                                sections: showingSections(),
                              ),
                            ),
                            const Center(
                              child: Text(
                                '36 명',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final fontSize = 16.0;
      final radius = 7.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.black.withAlpha(1),
            value: 40,
            title: '40%',
            showTitle: false,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xFFF48C06),
            value: 80,
            title: '50 명',
            showTitle: false,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: 0,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: 0,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
