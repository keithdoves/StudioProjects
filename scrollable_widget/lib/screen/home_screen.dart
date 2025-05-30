import 'package:flutter/material.dart';
import 'package:scrollable_widget/layout/main_layout.dart';
import 'package:scrollable_widget/screen/custom_scroll_view_screen.dart';
import 'package:scrollable_widget/screen/grid_view_screen.dart';
import 'package:scrollable_widget/screen/list_view_screen.dart';
import 'package:scrollable_widget/screen/refresh_indicator.dart';
import 'package:scrollable_widget/screen/reorderable_list_view_screen.dart';
import 'package:scrollable_widget/screen/scrollbar_screen.dart';
import 'package:scrollable_widget/screen/single_child_scroll_view_screen.dart';

class ScreenModel {
  final WidgetBuilder builder;
  final String name;

  ScreenModel({
    required this.builder,
    required this.name,
  });
}

class HomeScreen extends StatelessWidget {
  final screens = [
    ScreenModel(
      builder: (_) => SingleChildScrollViewScreen(),
      name: 'SingleChildScrollViewScreen',
    ),
    ScreenModel(
      builder: (_) => ListViewScreen(),
      name: 'ListViewScreen',
    ),

    ScreenModel(
      builder: (_) => GridViewScreen(),
      name: 'GridViewScreen',
    ),

    ScreenModel(
      builder: (_) => ReorderableListViewScreen(),
      name: 'OrderableListViewScreen',
    ),
    ScreenModel(
      builder: (_) => CustomScrollViewScreen(),
      name: 'CustomScrollViewScreen',
    ),
    ScreenModel(
      builder: (_) => ScrollbarScreen(),
      name: 'Scrollbar',
    ),
    ScreenModel(
      builder: (_) => RefreshIndicatorScreen(),
      name: 'RefreshIndicatorScreen',
    ),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Home',
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: screens
                .map(
                  (screen) => ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: screen.builder),
                      );
                    },
                    child: Text(screen.name),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
