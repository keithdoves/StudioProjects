import 'package:flutter_riverpod/flutter_riverpod.dart';

final multipulesFutureProvider = FutureProvider<List<int>>((ref) async {
  await Future.delayed(
    Duration(
      seconds: 2,
    ),

  );

  throw Exception('Error 입니다.');
  return [1,2,3,4,5];
});
