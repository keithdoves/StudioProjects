import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StatefulNestedScreen extends StatelessWidget {
  final Widget child;

  StatefulNestedScreen({
    required this.child,
    Key? key,
  }) : super(key: key);

  int getIndex(BuildContext context) {
    if (GoRouterState.of(context).location == '/nested/d') {
      return 0;
    } else if (GoRouterState.of(context).location == '/nested/e') {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GoRouterState.of(context).location),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: getIndex(context),
        onTap: (index) {
          if (index == 0) {
            context.go('/nested/d');
          } else if (index == 1) {
            context.go('/nested/e');
          } else {
            context.go('/nested/f');
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.receipt,
              ),
              label: 'receipt'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.ac_unit_outlined,
              ),
              label: 'snow'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
              ),
              label: 'dashboard'),
        ],
      ),
    );
  }
}
