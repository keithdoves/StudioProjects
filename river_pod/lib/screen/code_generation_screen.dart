import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/layout/default_layout.dart';
import 'package:river_pod/riverpod/code_generation_provider.dart';

class CodeGenerationScreen extends ConsumerWidget {
  const CodeGenerationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build');
    //아래 5개 중 어느 것이 상태가 변경되더라도
    //모두 다 rebuild됨
    // state를 하나를 빼서 위젯클래스를 만들고 위젯을 랜더링하면
    // 그 위젯만 리랜더링됨 (_StateFiveWidget).
    // 그러나 클래스 만드는 건 비효율적임
    final state1 = ref.watch(gStateProvider);
    final state2 = ref.watch(gStateFutureProvider);
    final state3 = ref.watch(gStateFuture2Provider);
    final state4 = ref.watch(gStateMultiplyProvider(
      number1: 10,
      number2: 20,
    ));

    return DefaultLayout(
      title: 'CodeGenerationScreen',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('State1 : $state1'),
          state2.when(
            data: (data) {
              return Text(
                'State2 : ${data.toString()}',
                textAlign: TextAlign.center,
              );
            }, //데이터가 있을 때
            error: (err, stack) => Text(
              err.toString(),
            ), //에러가 날 때
            loading: () => Center(child: CircularProgressIndicator()), //로딩중 일 때
          ),
          state3.when(
            data: (data) {
              return Text(
                'State3 : ${data.toString()}',
                textAlign: TextAlign.center,
              );
            }, //데이터가 있을 때
            error: (err, stack) => Text(
              err.toString(),
            ), //에러가 날 때
            loading: () => Center(child: CircularProgressIndicator()), //로딩중 일 때
          ),
          Text('State4 : $state4'),
          // Text('State5 : $state5'),
          //_StateFiveWidget(),
          Consumer(
            builder: (
              BuildContext context,
              WidgetRef ref,
              Widget? child,
            ) {
              //state5 상태가 변하여 Consumer의 builder만 재실행됨
              final state5 = ref.watch(gStateNotifierProvider);

              return Row(
                children: [
                  Text('State5 : $state5'),
                  child!, //이렇게 하는 이유는 부분적으로 리랜더링을 하기 위해서
                  //child는 리랜더링 안 됨.
                ],
              );
            }, //child 파라미터에 넣으면 단 한번만 빌드됨.
            child: Text('  hello'), //child 파라미터에 넣으면 위에 쓸 수 있음
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () =>
                    ref.read(gStateNotifierProvider.notifier).increment(),
                child: Text('Increment'),
              ),
              ElevatedButton(
                onPressed: () =>
                    ref.read(gStateNotifierProvider.notifier).decrement(),
                child: Text('Decrement'),
              ),
            ],
          ),
          // invalidate()
          // 유효하지 않게 하다
          // state를 유효하지 않게 하여 초기 상태로 돌림
          ElevatedButton(
            onPressed: () {
              ref.invalidate(gStateNotifierProvider);
            },
            child: Text(
              'Invalidate()',
            ),
          ),
        ],
      ),
    );
  }
}

class _StateFiveWidget extends ConsumerWidget {
  const _StateFiveWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state5 = ref.watch(gStateNotifierProvider);

    return Text('State5 : $state5');
  }
}
