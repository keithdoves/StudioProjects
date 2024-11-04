import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/layout/default_layout.dart';
import 'package:river_pod/riverpod/select_provider.dart';

class SelectProviderScreen extends ConsumerWidget {
  const SelectProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Build');
    //value는 상태임.
    //.select()로 state는 bool이 됨
    //이제 isSpicy만 감시하다가,
    final state = ref.watch(
      selectProvider.select((value) => value.isSpicy),
    );
    ref.listen(selectProvider.select((value) => value.hasBought),
        (previos, next) {
      print('next : $next');
    });
    return DefaultLayout(
      title: 'Select Provider Screen',
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(state.name),
            Text(state.toString()),
            // Text(state.hasBought.toString()),
            ElevatedButton(
              onPressed: () {
                ref.read(selectProvider.notifier).toggleIsSpicy();
              },
              child: Text('spicy toggle'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(selectProvider.notifier).toggleHasBought();
              },
              child: Text('HasBought toggle'),
            ),
          ],
        ),
      ),
    );
  }
}
