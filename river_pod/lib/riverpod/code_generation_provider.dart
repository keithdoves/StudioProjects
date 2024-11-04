import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'code_generation_provider.g.dart';

// 1) 어떤 Provider를 사용할지 결정활 고민 할 필요 없도록 알아서 정해줌
//    Proider, FutureProvider, StreamProvider

final _testProvider = Provider<String>((ref) => 'Hello Code Generation');

//함수 형태로 작성하여 직관적임(위 _testProvider와 gState는 같음)
@riverpod
String gState(GStateRef ref) {
  return 'Hello Code Generation';
}

@riverpod
Future<int> gStateFuture(GStateFutureRef ref) async {
  await Future.delayed(
    Duration(seconds: 3),
  );
  return 10;
}

@Riverpod(
  //살려둘지 : false가 기본값
  keepAlive: true,
) //대문자 Riverpod에 괄호 붙이기
Future<int> gStateFuture2(GStateFuture2Ref ref) async {
  await Future.delayed(
    Duration(seconds: 3),
  );
  return 10;
}

class Parameter {
  final int number1;
  final int number2;

  Parameter({
    required this.number1,
    required this.number2,
  });
}

// 2) Parameter => Family 파라미터를 일반 함수처럼 사용할 수 있도록
// 원래는 복수의 값을 받기 위해 클래스 선언을 했었음
final _testFamilyProvider = Provider.family<int, Parameter>(
  (ref, parameter) => parameter.number1 * parameter.number2,
);

@riverpod //_testFamilyProvider와 같음(여러 값을 받기 위해Class를 만들 필요 없음)
int gStateMultiply(GStateMultiplyRef ref,{
  required int number1,
  required int number2,
}){
  return number1 * number2;
}

//    StateNotifierProvider는 명시적 선언 가능
@riverpod
class GStateNotifier extends _$GStateNotifier{
  @override
  int build(){
    return 0; //기본 상태값
  }

  increment(){
    state++;
  }
  decrement(){
    state--;
  }

}