import 'package:flutter/material.dart';
import 'package:flutter_examples/OOP/oop_example.dart';
import 'package:flutter_examples/OOP/oop_example3.dart';
import 'package:flutter_examples/normal/functional_programming.dart';

import 'OOP/oop_example2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Flutter'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            flex: 1,
            child: Text(
              'Where Are you?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: 100.0,
              color: Colors.red,
            ),
          ),
          Expanded(
            flex: 3,
            child: OopExample(),
          ),
          Expanded(
            flex: 3,
            child: OopExample2(),
          ),
          Expanded(
            flex: 3,
            child: OopExample3(),
          ),
          Expanded(
            flex: 3,
            child: FunctionalProgramming(),
          ),
        ],
      ),
    );
  }
}
