import 'package:flutter/material.dart';

import '../const/tabs.dart';

class BasicAppbarTabBarScreen extends StatelessWidget {
  BasicAppbarTabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TABS.length, //Tab의 전체 길이
      child: Scaffold(
        appBar: AppBar(
          title: Text('Basic AppBar Screen'),
          bottom: TabBar(
            tabs: TABS
                .map(
                  (e) => Tab(
                    icon: Icon(
                      e.icon,
                    ),
                    child: Text(e.label),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: TABS
              .map(
                  (e) =>
                      Center(child: Icon(
                          e.icon
                      ),
                      )
          ).toList()
        ),
      ),
    );
  }
}
