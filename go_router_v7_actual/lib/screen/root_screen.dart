import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_v7_actual/layout/default_layout.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              context.go('/basic');
            },
            child: Text('Go Basic'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/named');
            },
            child: Text('Go named2'),
          ),
          ElevatedButton(
            onPressed: () {
              context.goNamed('named_screen');
              //라우트가 길어졌을 때 유용함
            },
            child: Text('Go Named'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/push');
              //라우트가 길어졌을 때 유용함
            },
            child: Text('Go Push'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/pop');
            },
            child: Text('Go Pop'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/path_param/456');
            },
            child: Text('Go Path Param'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/query_param');
              //라우트가 길어졌을 때 유용함
            },
            child: Text('Go Query Parameter'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/nested/a');
            },
            child: Text('Go Nested'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/nested/d');
            },
            child: Text('Go Stateful Nested'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/login');
            },
            child: Text('Go LoginScreen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/login2');
            },
            child: Text('Go LoginScreen22'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/transition');
            },
            child: Text('Go Transition Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/error');
            },
            child: Text('Error Screen'),
          ),
        ],
      ),
    );
  }
}
