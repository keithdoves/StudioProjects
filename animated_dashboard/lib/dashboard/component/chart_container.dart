import 'package:flutter/material.dart';

// 각 컨테이너의 크기를 측정하고 표시하는 위젯
class ChartContainer extends StatefulWidget {
  final String text;
  final Color color;
  final double? minWidth;
  final double? maxHeight;
  final Widget boxContents;

  const ChartContainer({
    Key? key, // Key를 외부에서 받을 수 있도록 변경
    required this.text,
    required this.color,
    this.minWidth,
    this.maxHeight,
    required this.boxContents,
  }) : super(key: key); // super(key: key)로 key를 전달

  @override
  State<ChartContainer> createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer> {
  final GlobalKey _containerKey = GlobalKey(); // 각 인스턴스마다 고유한 GlobalKey
  Size _currentSize = Size.zero; // 각 인스턴스마다 고유한 크기 상태

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureSize();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 화면 크기가 변경될 때마다 이 메서드가 호출됩니다.
    // 여기에서 크기 측정 로직을 다시 호출합니다.
    //final newSize = MediaQuery.sizeOf(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureSize();
    });
  }

  void _measureSize() {
    final renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _currentSize = renderBox.size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMaxHeight = widget.maxHeight ?? double.infinity;

    return Container(
      key: _containerKey,
      // 각 MeasurableContainer 인스턴스가 이 키를 사용
      constraints: BoxConstraints(
        minWidth: widget.minWidth ?? 0,
        maxHeight: effectiveMaxHeight,
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black54.withAlpha(40),
        border: Border.all(color: Colors.white.withAlpha(90), width: 2.0),
        borderRadius: BorderRadius.circular(25),
      ),
      child: widget.boxContents,
    );
  }
}
