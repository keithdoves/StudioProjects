import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/layout/default_layout.dart';
import 'package:river_pod/riverpod/state_provider.dart';

class StateProviderScreen extends ConsumerWidget {
  const StateProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //특정 provider를 바라보다 빌드를 실행
    final state = ref.watch(numberProvider);

    return DefaultLayout(
      title: 'StateProviderScreen',
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.toString(),
            ),
            ElevatedButton(
              onPressed: () { //값을 바꾸고 싶을 땐, .notifier 붙임
                ref.read(numberProvider.notifier).update((state) => state + 1);
              },
              child: Text(
                'UP',
              ),

            ),
            ElevatedButton(
              onPressed: () { //값을 바꾸고 싶을 땐, .notifier 붙임
                ref.read(numberProvider.notifier).state //값을 가져옴
                = ref.read(numberProvider.notifier).state -1;
              },
              child: Text(
                'Down',
              ),

            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => _NextScreen(),
                  ),
                );
              },
              child: Text(
                '_Next Screen',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextScreen extends ConsumerWidget {
  const _NextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(numberProvider);
    return DefaultLayout(
      title: 'StateProviderScreen',
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.toString(),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(numberProvider.notifier).update((state) => state + 1);
              },
              child: Text(
                'UP',
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
