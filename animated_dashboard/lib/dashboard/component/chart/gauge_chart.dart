import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GaugeChart extends StatefulWidget {
  const GaugeChart({super.key});
// Gauge Chart 다시 만들기

  @override
  State<GaugeChart> createState() => _GaugeChartState();
}

class _GaugeChartState extends State<GaugeChart> {
  int touchedIndex = -1;
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
        bool isMobile = constraints.maxWidth < 270;
        //print(isMobile);
        return AspectRatio(
          aspectRatio: isMobile ? 1 : 1.2,
          child: Container(
            constraints: BoxConstraints(
              minWidth: double.infinity,
            ),
            padding: isMobile ? const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0)
            : const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.black54.withAlpha(80),
              border: Border.all(color: Colors.white.withAlpha(90), width: 2.0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(
                        width: isMobile ? 4 : 8,
                      ),
                      Text(
                        '부서 인원',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                     SizedBox(
                      height: isMobile ? 0 : 18,
                    ),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: isMobile ? 1.6 : 1.5,
                        child: Stack(
                          children: [
                            PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                        setState(() {
                                          if (!event
                                                  .isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection ==
                                                  null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!
                                              .touchedSectionIndex;
                                        });
                                      },
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 2,
                                centerSpaceRadius:
                                isMobile ?
                                constraints.maxWidth/4.7 :
                                constraints.maxWidth/3.7
                                ,
                                sections: showingSections(),
                              ),
                            ),
                            Center(
                              child: Text(
                                '36 명',
                                style: TextStyle(
                                  fontSize: isMobile ? 17 : 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 15.0 : 16.0;
      final radius = isTouched ? 10.0 : 7.0;
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
