import 'package:codefactory_lvl2_flutter/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../user/model/user_model.dart';
import '../../user/provider/user_me_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // watch - 값이 변경될때마다 다시 빌드
  // read = 한번만 읽고 값이 변경되도 다시 빌드하지 않음
  final provider = ref.watch(authProvider);


  print('GoRouter 초기화');
  return GoRouter(
    routes: provider.routes,
    initialLocation: '/splash',
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );


});
