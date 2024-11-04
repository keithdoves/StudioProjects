import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/layout/default_layout.dart';
import 'package:river_pod/riverpod/auto_dispose_modifier_provider.dart';

//autoDispose : 자동으로 캐시를 삭제한다는 뜻
class AutoDisposeModifierScreen extends ConsumerWidget {
  const AutoDisposeModifierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(autoDisposeProvider);

    return DefaultLayout(
      title: 'Auto Dispose Modifier Screen',
      body: Center(
        child: state.when(
          data: (data)=> Text(data.toString()),
          error: (err, stack) => Text(err.toString()),
          loading: ()=> CircularProgressIndicator(),
        ),
      ),
    );
  }
}
