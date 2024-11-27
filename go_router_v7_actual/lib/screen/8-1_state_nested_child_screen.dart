import 'package:flutter/material.dart';

class StateNestedChildScreen extends StatelessWidget {
  final String routeName;

  const StateNestedChildScreen({
    required this.routeName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(routeName),
    );
  }
}
