import 'package:flutter/material.dart';

class DraggableWidget extends StatefulWidget {
  /// 드래그 효과를 적용할 자식 위젯
  final Widget child;

  /// 제자리로 돌아올 때의 애니메이션 지속 시간
  final Duration animationDuration;

  /// 제자리로 돌아올 때의 애니메이션 커브
  final Curve animationCurve;

  const DraggableWidget({
    super.key,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 300), // 기본 0.3초
    this.animationCurve = Curves.easeOut, // 기본 easeOut 커브
  });

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  // 위젯의 이동 거리를 저장할 변수
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 👆 드래그가 시작되거나 업데이트될 때 호출
      onPanUpdate: (details) {
        // 위치 변경 값을 즉시 반영 (드래그 중에는 애니메이션 없음)
        setState(() {
          _offset += details.delta;
        });
      },
      // ✨ 드래그가 끝났을 때 호출
      onPanEnd: (details) {
        // 위치를 원점(0, 0)으로 되돌림.
        // AnimatedContainer가 변경을 감지하고 애니메이션을 실행함.
        setState(() {
          _offset = Offset.zero;
        });
      },
      // 드래그가 시스템에 의해 취소될 경우에도 원점으로 복귀
      onPanCancel: () {
        setState(() {
          _offset = Offset.zero;
        });
      },
      child: AnimatedContainer(
        duration: widget.animationDuration, // 애니메이션 지속 시간
        curve: widget.animationCurve,      // 애니메이션 효과
        // transform 속성을 이용해 위젯을 시각적으로 이동시킴
        transform: Matrix4.translationValues(_offset.dx, _offset.dy, 0),
        transformAlignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}