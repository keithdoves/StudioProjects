import 'package:codefactory_lvl2_flutter/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청 보낼 때
  // CustomInterceptor가 적용된 dio를 사용해서 요청할 때마다 onRequest가 불림.
  // 요청이 보내질 때마다 만약에 요청의 Header에 accesstion : true라는 값이 있다면
  // 실제 토큰을 가져와서 (storage에서) authorization: bearer $token으로
  // 헤더를 변경한다
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      //헤더 삭제
      options.headers.remove('accessToken');

      //실제 토큰으로 대체
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      //헤더 삭제
      options.headers.remove('refreshToken');

      //실제 토큰으로 대체
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

// 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    return super.onResponse(response, handler);
  }
// 3) 에러가 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을 때(status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    //스토리지에서 refreshToken을 가져온다.
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken이 아예 없으면
    // 당연히 에러를 던진다
    if (refreshToken == null) {
      // 에러를 던질 때는 handler.reject를 사용한다.
      return handler.reject(err); // reject : 에러를 발생시킴
    }
    final isStatus401 = err.response?.statusCode == 401; //.reponse : 응답내용
    final isPathRefresh =
        err.requestOptions.path == '/auth/token'; //requestOptions : 요청내용

    // a.401에러이고, accessToken을 받으려는 요청이 아니었다면
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();
      try {
        // b. refreshToken을 이용하여 accessToken을 재발급 받는다.
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );
        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        // c. 원래 요청 헤더에서 토큰 추가(원래만료된 토큰이 있었으면 덮어씀)
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });
        // d. storage에 새 accessToken 저장
        await storage.write(key : ACCESS_TOKEN_KEY, value: accessToken);
        // e. 원래 보내려던 요청 재전송 함.
        final response = await dio.fetch(options);

        // resolve : 에러없이 요청을 끝낼 수 있음
        // f. 즉 실제 에러가 났지만, 에러가 나지 않은 것처럼 됨
        return handler.resolve(response);

         // g. on DioException : Dio관련된 Exception만 잡힘.
      } on DioException catch (e) {
        return handler.reject(e); //try에서 에러나면 에러 발생시킴.
      }
    }
    return handler.reject(err);
  }

//Interceptor를 상속하면 기본적으로 Interceptor의 기능을 이용할 수 있음
}
