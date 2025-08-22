import 'package:flutter/material.dart';
import 'package:treemap_example/tree_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TreeMap Component Example'),),
      body: TreemapWidget(),
    );
  }
}
