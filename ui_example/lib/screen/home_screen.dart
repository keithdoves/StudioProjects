import 'package:flutter/material.dart';
import 'package:ui_example/const/colours.dart';
import 'package:ui_example/screen/network_image_with_slider_example.dart';
import 'package:ui_example/screen/single_child_scroll_view.dart';
import 'package:ui_example/screen/sliver_persistent_header.dart';
import 'package:ui_example/screen/sliver_resizing_header_screen.dart';
import 'package:ui_example/screen/sliver_scroll_view.dart';

class HomeScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.ac_unit,
              color: Colors.red,
            ),
            tooltip: 'Open shopping cart',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SliverResizingHeaderScreen(),
                  ));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.ac_unit,
              color: Colors.green,
            ),
            tooltip: 'Open shopping cart',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SingleChildScrollViewRender(),
                  ));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.ac_unit,
              color: Colors.lime,
            ),
            tooltip: 'Open shopping cart',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SliverPersistentHeaders(),
                  ));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.ac_unit,
              color: Colors.teal,
            ),
            tooltip: 'Open shopping cart',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SliverScrollView(),
                  ));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.ac_unit,
              color: Colors.lightBlue,
            ),
            tooltip: 'Open shopping cart',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NetworkImageWithSliderExample(),
                  ));
            },
          ),
        ],
        title: Text(
          'Example Of UI',
          style: TextStyle(fontSize: 24.0),
        ),
        // clipBehavior: Clip.antiAlias,
      ),
      body: ListView.separated(
        itemBuilder: (_, index) => RenderContainer(
          index: index,
        ),
        separatorBuilder: (_, index) => Container(
          height: 8.0,
        ),
        itemCount: 100,
      ),
    );
  }
}

class RenderContainer extends StatelessWidget {
  final int index;

  const RenderContainer({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    print(index);
    return Container(
      height: 100.0,
      color: rainbowColors[index % rainbowColors.length],
      child: Center(
        child: Text(
          index.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22.0,
          ),
        ),
      ),
    );
  }
}
