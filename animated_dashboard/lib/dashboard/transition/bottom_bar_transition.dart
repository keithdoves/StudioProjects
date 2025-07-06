import 'package:flutter/material.dart';

import '../../common/animation/animation.dart';

class BottomBarTransition extends StatefulWidget {
  const BottomBarTransition({
    super.key,
    required this.animation,
    required this.backgroundColor,
    required this.child,
  });

  final Animation<double> animation;
  final Color backgroundColor;
  final Widget child;

  @override
  State<BottomBarTransition> createState() => _BottomBarTransition();
}

class _BottomBarTransition extends State<BottomBarTransition> {
  late final Animation<Offset> offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(OffsetAnimation(parent: widget.animation));

  late final Animation<double> heightAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(SizeAnimation(parent: widget.animation));

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Align(
        alignment: Alignment.center,
        heightFactor: heightAnimation.value,
        child: FractionalTranslation(
          translation: offsetAnimation.value,
          child: widget.child,
        ),
      ),
    );
  }
}
