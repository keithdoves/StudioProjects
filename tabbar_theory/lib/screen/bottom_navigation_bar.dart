import 'package:flutter/material.dart';

import '../const/tabs.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>
    with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    controller = TabController(
      length: TABS.length,
      vsync: this,
    );
    controller.addListener((){
      setState(() {
       //리스너 및 setState가 없으면 onTap의 콜백함수가 작동 되어도 상태 변경 감지 안 됨.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Navigation Bar'),
      ),
      body: TabBarView(
        controller: controller,
        children: TABS
            .map((e) => Center(
                  child: Icon(e.icon),
                ))
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: controller.index, //TabBarView와 연동
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          controller.animateTo(index);

        },
        items: TABS
            .map((e) => BottomNavigationBarItem(
                  icon: Icon(e.icon),
                  label: e.label,
                ))
            .toList(),
      ),
    );
  }
}
