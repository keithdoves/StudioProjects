import 'dart:ui';

import 'package:flutter/material.dart';

import '../../common/animation/animation.dart';

class ListDetailTransition extends StatefulWidget {
  const ListDetailTransition({
    super.key,
    required this.animation,
    required this.one,
    required this.two,
  });

  final Animation<double> animation;
  final Widget one;
  final Widget two;

  @override
  State<ListDetailTransition> createState() => _ListDetailTransitionState();
}

class _ListDetailTransitionState extends State<ListDetailTransition> {
  Animation<double> widthAnimation = const AlwaysStoppedAnimation(0);

  late final Animation<double> sizeAnimation = SizeAnimation(
    parent: widget.animation,// _railAnimation 들어감
  );

  late final Animation<Offset> offsetAnimation = Tween<Offset>(
    begin: const Offset(1, 0), // rail은 -1 이었음.
    end: Offset.zero,
  ).animate(OffsetAnimation(parent: sizeAnimation));
  double currentFlexFactor = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    double nextFlexFactor = switch (width) {
      >= 800 && < 1200 => lerpDouble(500, 600, (width - 800) / 400)!,
      >= 1200 && < 1600 => lerpDouble(600, 700, (width - 1200) / 400)!,
      >= 1600 => 800,
      _ => 500, // 기본값
    };

    if (nextFlexFactor == currentFlexFactor) {
      return;
    }

    if (currentFlexFactor == 0) {
      widthAnimation = Tween<double>(
        begin: 0,
        end: nextFlexFactor,
      ).animate(sizeAnimation);
    } else {
      final TweenSequence<double> sequence = TweenSequence([
        if (sizeAnimation.value > 0) ...[
          TweenSequenceItem(
            tween: Tween(begin: 0, end: widthAnimation.value),
            weight: sizeAnimation.value,
          ),
        ],
        if (sizeAnimation.value < 1) ...[
          TweenSequenceItem(
            tween: Tween(begin: widthAnimation.value, end: nextFlexFactor),
            weight: 1 - sizeAnimation.value,
          ),
        ],
      ]);

      widthAnimation = sequence.animate(sizeAnimation);
    }

    currentFlexFactor = nextFlexFactor;
  }

  @override
  Widget build(BuildContext context) {
    return widthAnimation.value.toInt() == 0
        ? widget.one
        : Row(
      children: [
        Flexible(flex: 1500, child: widget.one),
        Flexible(
          flex: widthAnimation.value.toInt(),
          child: FractionalTranslation(
            translation: offsetAnimation.value,
            child: widget.two,
          ),
        ),
      ],
    );
  }
}