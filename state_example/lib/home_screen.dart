import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int count = 0;

  void increment() {
    setState(() {
      ++count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (count > 10) Text('Too high'),
              Counter(
                fnc: increment,
                count: count,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Counter extends StatelessWidget {
  final VoidCallback fnc;
  final int count;

  Counter({super.key, required this.fnc, required this.count});

  @override
  Widget build(BuildContext context) {
    print('counter build');
    return Row(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: fnc,
          child: Text('+'),
        )
      ],
    );
  }
}
