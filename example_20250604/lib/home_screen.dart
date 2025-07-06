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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            color: count > 10 ? Colors.red : Colors.orange,
          ),
          Center(
            child: Counter(
              increment: increment,
              count: count,
            ),
          ),
        ],
      ),
    );
  }
}

class Counter extends StatelessWidget {
  final VoidCallback increment;
  final int count;

  Counter({
    super.key,
    required this.increment,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$count'),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(onPressed: increment, child: Text('+')),
      ],
    );
  }
}
