import 'package:flutter/material.dart';

import '../const/tabs.dart';

class BasicAppbarTabBarScreen extends StatelessWidget {
  BasicAppbarTabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController( //컨트롤러가 자동으로 주입됨.
      length: TABS.length, //Tab의 전체 길이
      child: Scaffold(
        appBar: AppBar(
          title: Text('Basic AppBar Screen'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TabBar(
                  indicatorColor: Colors.red,
                  indicatorWeight: 4.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  //.label 라벨 크기만큼
                  isScrollable: true,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w100,

                  ),
                  tabs:
                  TABS
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
              ],
            ),
          )
        ),
        body: TabBarView(
            //TabBar-TabBarView가 연결되는 것은
            //DefaultTabController 안에 두 위젯이 있기 때문
            physics: NeverScrollableScrollPhysics(), //좌우로 터치하여 넘길 수 없게 제한.

            children: TABS
                .map((e) => Center(
                      child: Icon(e.icon),
                    ))
                .toList()),
      ),
    );
  }
}
