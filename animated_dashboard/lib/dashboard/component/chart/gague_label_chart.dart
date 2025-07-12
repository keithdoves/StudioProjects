import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

//  Expended로 래핑해서 쓸 것
//
class GaugeLabelChart extends StatefulWidget {
   const GaugeLabelChart({
    required this.labelText,
    super.key,
  });

  final String labelText;
  @override
  State<GaugeLabelChart> createState() => _GaugeLabelChartState();
}

class _GaugeLabelChartState extends State<GaugeLabelChart> {
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
        final sectionsRadius = constraints.maxWidth * 0.08; //차트 두께
        final dynamicFontSize = constraints.maxWidth * 0.2;
        return Container(
          //margin: const EdgeInsets.only(bottom: 3.0),
          //color: Colors.red,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PieChart(
                PieChartData(
                  // ... 이전과 동일한 PieChartData
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius:   (constraints.maxWidth / 2) - sectionsRadius  ,
                  sections: showingSections(sectionsRadius),
                ),
              ),
              Center(
                child: Text(
                  '${widget.labelText}',
                  style: TextStyle(
                    fontSize: dynamicFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(double sectionsRadius) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final currentRadius = isTouched ? sectionsRadius * 1.2 : sectionsRadius * 1;
      final fontSize = isTouched ? 15.0 : 16.0;
      //final radius = isTouched ? 10.0 : 7.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 20, offset: Offset(3, 3))];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.black.withAlpha(1),
            value: 40,
            title: '40%',
            showTitle: false,
            radius: currentRadius,
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
            gradient: LinearGradient(
              colors: const [Color(0xFFF48C06), Colors.deepOrange], // 시작 색상과 끝 색상
              begin: Alignment.topLeft, // 왼쪽 위에서 시작
              end: Alignment.bottomRight, // 오른쪽 아래에서 끝
            ),
            value: 80,
            title: '50 명',
            showTitle: false,
            radius: currentRadius,
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
            radius: currentRadius,
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
            radius: currentRadius,
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
