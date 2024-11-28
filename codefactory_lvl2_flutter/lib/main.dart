import 'package:codefactory_lvl2_flutter/common/component/custom_text_form_field.dart';
import 'package:codefactory_lvl2_flutter/common/view/splash_screen.dart';
import 'package:codefactory_lvl2_flutter/user/provider/auth_provider.dart';
import 'package:codefactory_lvl2_flutter/user/repository/auth_repository.dart';
import 'package:codefactory_lvl2_flutter/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/provider/go_router.dart';

void main() {
  runApp(
    ProviderScope(
      child: _App(),
    ),
  );
}

class _App extends ConsumerWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false,
      routerConfig : router,
    );
  }
}
