import 'package:codefactory_lvl2_flutter/common/layout/default_layout.dart';
import 'package:codefactory_lvl2_flutter/order/view/order_screen.dart';
import 'package:codefactory_lvl2_flutter/restaurant/view/restaurant_screen.dart';
import 'package:codefactory_lvl2_flutter/user/view/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../product/view/product_screen.dart';
import '../const/colors.dart';

class RootTab extends StatefulWidget {
  static String get routeName => '/';
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.fastfood_outlined,
            ),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.receipt_long_outlined,
            ),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outlined,
            ),
            label: '프로필',
          ),
        ],
      ),
      title: '코팩 딜리버리',
      child: Center(
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(), //좌우드레그로 탭 이동 막음
          controller: controller,
          children: [
            RestaurantScreen(),
            ProductScreen(),
            OrderScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
