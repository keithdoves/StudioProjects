import 'package:codefactory_lvl2_flutter/common/const/data.dart';
import 'package:codefactory_lvl2_flutter/common/secure_storage/secure_storage.dart';
import 'package:codefactory_lvl2_flutter/user/model/user_model.dart';
import 'package:codefactory_lvl2_flutter/user/repository/auth_repository.dart';
import 'package:codefactory_lvl2_flutter/user/repository/user_me_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_me_provider.g.dart';

@riverpod
class UserMe extends _$UserMe {
  late final AuthRepository _authRepository;
  late final UserMeRepository _userMeRepository;
  late final FlutterSecureStorage _storage;

  @override
  UserModelBase? build() {
    _authRepository = ref.watch(authRepositoryProvider);
    _userMeRepository = ref.watch(userMeRepositoryProvider);
    _storage = ref.watch(secureStorageProvider);

    getMe();

    return UserModelLoading();
  }

  Future<void> getMe() async {
    final refreshToken = await _storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await _storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    final resp = await _userMeRepository.getMe();
    state = resp;
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await _authRepository.login(
        username: username,
        password: password,
      );
      await _storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await _storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp = await _userMeRepository.getMe();

      state = userResp;

      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait(
      [
        _storage.delete(key: REFRESH_TOKEN_KEY),
        _storage.delete(key: ACCESS_TOKEN_KEY),
      ],
    );
  }
}
