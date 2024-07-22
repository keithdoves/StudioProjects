import 'package:flutter/material.dart';
import 'package:u_and_i/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'sunflower',
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontFamily: 'parisienne',
          fontSize: 48.0,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 40.0,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
        ),
      ),
    ),
    home: HomeScreen(),
  ));
}
