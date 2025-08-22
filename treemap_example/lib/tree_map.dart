import 'package:flutter/material.dart';
import 'package:d4_hierarchy/d4_hierarchy.dart';
import 'dart:math';

// ✅ [추가] 위젯이 사용할 기본 데이터. 외부에서 데이터를 주지 않으면 이 데이터가 사용됩니다.
const _defaultTreemapData = {
  "name": "Default",
  "children": [
    {
      "name": "Category A", // 1번 패밀리
      "children": [
        {"name": "A-1", "value": 25},
        {"name": "A-2", "value": 15},
      ]
    },
    {
      "name": "Category B", // 2번 패밀리
      "children": [
        {"name": "B-1", "value": 30},
        {"name": "B-2", "value": 10},
      ]
    },
  ]
};


// =========================================================================
// 재사용 가능한 최종 Treemap 위젯 (컴포넌트)
// =========================================================================
class TreemapWidget extends StatefulWidget {
  /// 시각화할 계층 구조 데이터 (옵셔널)
  final Map<String, dynamic>? data;

  /// 타일 사이의 간격 (옵셔널)
  final double? tilePadding;

  /// 타일 색상 리스트 (옵셔널)
  final List<Color>? tileColors;

  /// 타일 테두리 속성 (옵셔널)
  final BorderSide? border;

  /// 타일 내부 텍스트 스타일 (옵셔널)
  final TextStyle? textStyle;

  const TreemapWidget({
    super.key,
    this.data, // ✅ [수정] required 키워드 제거
    this.tilePadding,
    this.tileColors,
    this.border,
    this.textStyle,
  });

  @override
  State<TreemapWidget> createState() => _TreemapWidgetState();
}

class _TreemapWidgetState extends State<TreemapWidget> {
  // 패밀리별 색상을 저장할 Map
  final Map<String, Color> _familyColors = {};

  // ✅ [추가] 위젯이 실제로 사용할 데이터를 담을 변수
  late final Map<String, dynamic> _activeData;

  // 기본 색상 리스트
  static const _defaultColors = [
    Colors.amber, Colors.blue, Colors.green, Colors.purple,
    Colors.red, Colors.orange, Colors.teal, Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    // ✅ [추가] 위젯이 생성될 때 사용할 데이터를 결정합니다.
    _activeData = widget.data ?? _defaultTreemapData;
    _assignFamilyColors();
  }

  // 데이터가 외부에서 변경될 경우를 대비
  @override
  void didUpdateWidget(TreemapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != null && oldWidget.data != widget.data) {
      _activeData = widget.data!;
      _familyColors.clear();
      _assignFamilyColors();
    }
  }

  /// 2레벨 Children을 기준으로 패밀리 색상을 할당하는 로직
  void _assignFamilyColors() {
    final rootChildren = _activeData['children'] as List<dynamic>?;
    if (rootChildren == null) return;

    final colors = widget.tileColors ?? _defaultColors;
    int colorIndex = 0;

    for (final familyNode in rootChildren) {
      final familyName = (familyNode as Map<String, dynamic>)['name'] as String;
      if (!_familyColors.containsKey(familyName)) {
        _familyColors[familyName] = colors[colorIndex % colors.length];
        colorIndex++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // ✅ [수정] 위젯의 data 대신, 결정된 _activeData를 사용합니다.
        final root = hierarchy(_activeData, (d) => (d as Map<String, dynamic>)['children'])!;

        root.sum((d) {
          final map = d as Map<String, dynamic>;
          return map.containsKey('value') ? map['value'] : 0;
        });

        final treemapLayout = Treemap.new()
          ..size = [constraints.maxWidth, constraints.maxHeight]
          ..padding = (node) => widget.tilePadding ?? 4.0;

        treemapLayout(root);

        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: TreemapPainter(
            root: root,
            familyColors: _familyColors,
            border: widget.border,
            textStyle: widget.textStyle,
          ),
        );
      },
    );
  }
}

// TreemapPainter는 이전과 동일합니다.
class TreemapPainter extends CustomPainter {
  final dynamic root;
  final Map<String, Color> familyColors;
  final BorderSide? border;
  final TextStyle? textStyle;

  TreemapPainter({
    required this.root,
    required this.familyColors,
    this.border,
    this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final node in root.leaves()) {
      dynamic familyNode = node;
      while (familyNode.depth > 1) {
        familyNode = familyNode.parent;
      }
      final familyName = (familyNode.data as Map<String, dynamic>)['name'];
      final tileColor = familyColors[familyName] ?? Colors.grey;

      final rectPaint = Paint()
        ..color = tileColor.withOpacity(0.7)
        ..style = PaintingStyle.fill;

      final rect = Rect.fromLTRB(node.x0, node.y0, node.x1, node.y1);
      canvas.drawRect(rect, rectPaint);

      final borderStyle = border ?? const BorderSide(color: Colors.white, width: 1.0);
      if (borderStyle != BorderSide.none) {
        final borderPaint = Paint()
          ..color = borderStyle.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderStyle.width;
        canvas.drawRect(rect, borderPaint);
      }

      if (rect.width > 25 && rect.height > 15) {
        final defaultTextStyle = const TextStyle(color: Colors.white, fontSize: 12);
        final finalTextStyle = textStyle ?? defaultTextStyle;

        final textSpan = TextSpan(
          text: (node.data as Map<String, dynamic>)['name'],
          style: finalTextStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(minWidth: 0, maxWidth: rect.width - 10);
        textPainter.paint(
          canvas,
          Offset(rect.left + 5, rect.top + 5),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant TreemapPainter oldDelegate) {
    return oldDelegate.root != root || oldDelegate.familyColors != familyColors;
  }
}