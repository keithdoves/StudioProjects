import 'package:flutter/material.dart';

// 각 컨테이너의 크기를 측정하고 표시하는 위젯
class MeasurableContainer extends StatefulWidget {
  final String text;
  final Color color;
  final double? minWidth;
  final double? maxHeight;

  const MeasurableContainer(
      {Key? key, // Key를 외부에서 받을 수 있도록 변경
        required this.text,
        required this.color,
        this.minWidth,
        this.maxHeight})
      : super(key: key); // super(key: key)로 key를 전달

  @override
  State<MeasurableContainer> createState() => _MeasurableContainerState();
}

class _MeasurableContainerState extends State<MeasurableContainer> {





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
    final newSize = MediaQuery.sizeOf(context);
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
        // 디버깅을 위해 각 컨테이너의 크기를 콘솔에 출력

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMaxHeight = widget.maxHeight ?? double.infinity;

    return Container(
      key: _containerKey, // 각 MeasurableContainer 인스턴스가 이 키를 사용
      constraints: BoxConstraints(
        minWidth: widget.minWidth ?? 0,
        maxHeight: effectiveMaxHeight,
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: widget.color,
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.text, style: const TextStyle(fontSize: 14)),
     /*       if (widget.minWidth != null)
              Text('minWidth ${widget.minWidth!.toStringAsFixed(1)}'),
            if (widget.maxHeight != null && widget.maxHeight != double.infinity)
              Text('maxHeight ${widget.maxHeight!.toStringAsFixed(1)}'),*/
            // 각 MeasurableContainer가 자신의 크기를 표시
            Text(
              '현재 크기: 가로 ${_currentSize.width.toStringAsFixed(2)}, 세로 ${_currentSize.height.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}