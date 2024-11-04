import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/layout/default_layout.dart';
import 'package:river_pod/riverpod/future_provider.dart';

class FutureProviderScreen extends ConsumerWidget {
  const FutureProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //AsyncValue는 .when으로 맵핑하여 관리할 수 있음.
    final AsyncValue state = ref.watch(multipulesFutureProvider);
    return DefaultLayout(
      title: 'Future Provider Screen',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          state.when(
            data: (data) {
              return Text(
                data.toString(),
                textAlign: TextAlign.center,
              );
            }, //데이터가 있을 때
            error: (err, stack) => Text(
              err.toString(),
            ), //에러가 날 때
            loading: ()=>Center(child: CircularProgressIndicator()), //로딩중 일 때
          ),
        ],
      ),
    );
  }
}
