import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<String> colorList = [
    'red',
    'green',
    'blue',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sliver Resizing Header Example'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverResizingHeader(
            minExtentPrototype: Container(
              height: 50.0,
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Min Header',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            maxExtentPrototype: Container(
              height: 200.0,
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Max Header',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            child: Container(
              color: Colors.blue,
              child: Column(
                children: colorList
                    .map((e) => ListTile(
                          title: Text(e),
                        ))
                    .toList(),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
