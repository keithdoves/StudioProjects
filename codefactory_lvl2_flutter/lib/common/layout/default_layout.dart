import 'package:flutter/material.dart';

//모든 뷰에 모든 기능을 적용하고 싶다 할 때,
//모든 뷰에 전부 적용하는 것이 아니라 이 default_layout에 구현하면 됨

class DefaultLayout extends StatelessWidget {
  final Widget child;

  const DefaultLayout({
    required this.child,
    Key? key,
}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
    );
  }
}
