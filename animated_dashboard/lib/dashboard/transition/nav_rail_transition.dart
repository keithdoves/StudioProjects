import 'package:flutter/material.dart';

import '../../common/animation/animation.dart';

class NavRailTransition extends StatefulWidget {
  const NavRailTransition({
    super.key,
    required this.animation,
    required this.backgroundColor,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;
  final Color backgroundColor;

  @override
  State<NavRailTransition> createState() => _NavRailTransitionState();
}

class _NavRailTransitionState extends State<NavRailTransition> {
  // The animations are only rebuilt by this method when the text
  // direction changes because this widget only depends on Directionality.

  late final bool ltr = Directionality.of(context) == TextDirection.ltr;

  late final Animation<Offset> offsetAnimation = Tween<Offset>(
    begin: ltr ? const Offset(-1, 0) : const Offset(1, 0),
    end: Offset.zero,
  ).animate(OffsetAnimation(parent: widget.animation));

  late final Animation<double> widthAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(SizeAnimation(parent: widget.animation)); //0.6s //parent railAnimation


  @override
  Widget build(BuildContext context) {
    return ClipRect(
      //고정된 크기를 갖지 않지만 “자기 자신의 레이아웃 크기”를 기준으로 그려지는 내용을 잘라내는 역할
      //자식 크기에 맞춰 width가 지정됨.
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.transparent),
        child: AnimatedBuilder(
          animation: widthAnimation,
          //widthAnimation으로 자식의 크기가 점점 커진다.
          //그러나 offsetAnimation은 늦게 시작하기 때문에
          //-1 위치에서 랜더링되고, 그려지지 않은 공간만 화면에 보인다.
          //그 공간의 배경을 설정하기 위해 DecoratedBox로 래핑한다.
          builder: (context, child) {
            return Align(

              alignment: Alignment.topLeft,
              widthFactor: widthAnimation.value,
              child: FractionalTranslation(
                //FractionalTranslation은 레이아웃 역할을 하지 않고
                //자신이 속한 박스 기준으로 자식을 옮겨 랜더링함.
                translation: offsetAnimation.value,
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}