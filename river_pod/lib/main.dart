import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/riverpod/provider_observer.dart';
import 'package:river_pod/screen/home_screen.dart';

void main() {
  runApp(
    ProviderScope( //상위에 있어야 쓸 수 있음
      observers: [
        Logger(),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}
