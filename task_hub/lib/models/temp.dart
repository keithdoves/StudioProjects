/*
import 'package:flutter/material.dart';
import 'package:task_hub/measurable_container.dart'; // 새로 생성한 파일 import

class DashboardContent extends StatefulWidget {
  DashboardContent({required this.doubleWidth, super.key});

  //해야할 것
  // 1. 900 하나만 있으니 모바일 뷰에서 3ROW는 힘듬
  //    그래서 900이전에 2RoW로 갔다가 1200쯤에 3Row 가야함
  // 2. 이에 따른 연쇄적인 조정이 필요(Rail Extend, ListViewTrainsition Two)
  // 3. 레이아웃 모두 Width 값 보이게 하기.
  // 4. DashboardContent 애니메이션 넣기

  static const double desktopBreakpoint = 1100.0; // 데스크톱 레이아웃으로 전환될 너비
  static const double tabletBreakpoint = 600.0;
  final double doubleWidth;

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  // DashboardContent 자체의 크기를 측정하기 위한 GlobalKey
  final GlobalKey _dashboardContentKey = GlobalKey();
  Size _dashboardContentSize = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDashboardContentSize();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 화면 크기가 변경될 때마다 이 메서드가 호출됩니다.
    // 여기에서 크기 측정 로직을 다시 호출합니다.
    final newSize = MediaQuery.sizeOf(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDashboardContentSize();
    });
  }

  // DashboardContent 자체의 크기를 측정하는 함수
  void _getDashboardContentSize() {
    final renderBox =
    _dashboardContentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _dashboardContentSize = renderBox.size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _dashboardContentKey, // DashboardContent 자체에 key 할당
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
          children: [
            Row(
              children: [
                Text(
                  'Full_Width : ${widget.doubleWidth.toInt().toString()},',
                  style: TextStyle(fontSize: 15.0),
                ),
                Text(
                  '  Side_Width :  ${(widget.doubleWidth.toInt() - _dashboardContentSize.width).toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
            // DashboardContent 자체의 크기 표시
            Text(
              'Dashboard Width : ${_dashboardContentSize.width.toStringAsFixed(2)}, Height : ${_dashboardContentSize.height.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
        toolbarHeight: 80, // AppBar 높이 충분히 확보
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < DashboardContent.desktopBreakpoint) {
            // 좁은 화면 (모바일) 레이아웃: 모든 위젯을 수직으로 배치
            return SingleChildScrollView(
              child: Column(
                children: [
                  // MeasurableContainer 사용
                  MeasurableContainer(
                      text: 'A1',
                      color: Colors.red[100]!,
                      minWidth: 300,
                      maxHeight: 300),
                  MeasurableContainer(
                      text: 'A2',
                      color: Colors.red[100]!,
                      minWidth: 300,
                      maxHeight: 300),
                  MeasurableContainer(
                      text: 'A3',
                      color: Colors.red[100]!,
                      minWidth: 300,
                      maxHeight: 300),
                  MeasurableContainer(
                      text: 'B1', color: Colors.green[100]!, minWidth: 300),
                  MeasurableContainer(
                      text: 'B2', color: Colors.green[100]!, minWidth: 300),
                  MeasurableContainer(
                      text: 'C1', color: Colors.blue[100]!, minWidth: 300),
                  MeasurableContainer(
                      text: 'C2', color: Colors.blue[100]!, minWidth: 300),
                ],
              ),
            );
          } else {

            // 넓은 화면 (데스크톱/태블릿) 레이아웃
            return Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: MeasurableContainer(
                                          text: 'A1',
                                          color: Colors.red[100]!,
                                          minWidth: 300,
                                          maxHeight: 300)),
                                  Expanded(
                                      flex: 1,
                                      child: MeasurableContainer(
                                          text: 'A2',
                                          color: Colors.red[100]!,
                                          minWidth: 300,
                                          maxHeight: 300)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: MeasurableContainer(
                                    text: 'A3',
                                    color: Colors.red[100]!,
                                    minWidth: 300),
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
                                flex: 1,
                                child: MeasurableContainer(
                                    text: 'B1',
                                    color: Colors.green[100]!,
                                    minWidth: 300)),
                            Expanded(
                                flex: 3,
                                child: MeasurableContainer(
                                    text: 'B2',
                                    color: Colors.green[100]!,
                                    minWidth: 300)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: MeasurableContainer(
                              text: 'C1',
                              color: Colors.blue[100]!,
                              minWidth: 150)),
                      Expanded(
                          child: MeasurableContainer(
                              text: 'C2',
                              color: Colors.blue[100]!,
                              minWidth: 150)),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

Widget _buildTabletLayout() {
  // 요청하신 A1/A2(2) - A3(1) - B1(1) - B2(1) - C1(1) - C2(1) 레이아웃
  return SingleChildScrollView(
    child: Column(
      children: [
        // 1. A1/A2를 가로로 배치 (2열)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: MeasurableContainer(text: 'A1', color: Colors.red[100]!, minWidth: 300, maxHeight: 300)),
            Expanded(child: MeasurableContainer(text: 'A2', color: Colors.red[100]!, minWidth: 300, maxHeight: 300)),
          ],
        ),
        // 2. A3 (1열)
        MeasurableContainer(text: 'A3', color: Colors.red[100]!, minWidth: 300, maxHeight: 300),
        // 3. B1 (1열)
        MeasurableContainer(text: 'B1', color: Colors.green[100]!, minWidth: 300),
        // 4. B2 (1열)
        MeasurableContainer(text: 'B2', color: Colors.green[100]!, minWidth: 300),
        // 5. C1 (1열)
        MeasurableContainer(text: 'C1', color: Colors.blue[100]!, minWidth: 300),
        // 6. C2 (1열)
        MeasurableContainer(text: 'C2', color: Colors.blue[100]!, minWidth: 300),
      ],
    ),
  );
}
*/
