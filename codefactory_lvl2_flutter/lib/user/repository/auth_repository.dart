import 'package:codefactory_lvl2_flutter/common/const/data.dart';
import 'package:codefactory_lvl2_flutter/common/dio/dio.dart';
import 'package:codefactory_lvl2_flutter/product/model/login_response.dart';
import 'package:codefactory_lvl2_flutter/product/model/token_response.dart';
import 'package:dio/dio.dart' hide headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/utils/data_utils.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref){
  print('1. authRepositoryProvider 초기화');
  final Dio dio = ref.watch(dioProvider);
  return AuthRepository(baseUrl: 'http://$ip/auth', dio: dio);
}
);

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<LoginResponse> login({
    required String username,
    required String password,
})async{
  final serialized = DataUtils.plainToBase64('$username:$password');

  final resp = await dio.post(
    '$baseUrl/login',
    options: Options(
      headers: {'authorization': 'Basic $serialized'},
    )
  );
  return LoginResponse.fromJson(resp.data);
  }

  Future<TokenResponse> token() async{
    final resp = await dio.post(
      '$baseUrl/token',
      options: Options(
        headers: {
          'refreshToken': 'true',
        }
      ),
    );
    return TokenResponse.fromJson(resp.data);
  }

}
