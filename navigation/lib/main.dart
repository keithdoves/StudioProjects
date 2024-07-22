import 'package:flutter/material.dart';
import 'package:navigation/screen/home_screen.dart';
import 'package:navigation/screen/route_one_screen.dart';
import 'package:navigation/screen/route_three_screen.dart';
import 'package:navigation/screen/route_two_screen.dart';

const HOME_ROUTE = '/';

void main() {
  runApp(MaterialApp(
    // home: HomeScreen(),
    initialRoute: '/',
    routes: {
      HOME_ROUTE: (context) => const HomeScreen(),
      '/one': (context) => const RouteOneScreen(),
      '/two': (context) => const RouteTwoScreen(),
      '/three': (context) => const RouteThreeScreen(),
    },
  ));
}
