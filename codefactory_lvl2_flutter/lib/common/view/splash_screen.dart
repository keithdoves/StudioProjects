import 'package:codefactory_lvl2_flutter/common/const/colors.dart';
import 'package:codefactory_lvl2_flutter/common/const/data.dart';
import 'package:codefactory_lvl2_flutter/common/layout/default_layout.dart';
import 'package:codefactory_lvl2_flutter/common/view/root_tab.dart';
import 'package:codefactory_lvl2_flutter/user/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // inintState에서 await 할 수 없기에 따로 함수를 만듬
    // deleteToken();
    checkToken(); //이 함수가 실행될 때까지 SplashScreen이 보임
  }

  void deleteToken() async {
    await storage.deleteAll();
  }

  void checkToken() async {
    //storage로 부터 토큰 갖고오기
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio = Dio();

    try {
      //refreshToken으로 accessToken 발급 받기
      final resp = await dio.post(
        'http://$ip/auth/token',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ),
      );
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      //accessToken발급시 에러가 없으면 루트탭으로
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => RootTab(),
        ),
            (route) => false,
      );
    } catch (e) {
      //accessToken발급시 에러가 있으면 로그인탭으로
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        //column의 center 정렬을 위해 화면 만큼 너비를 가진 사이즈드박스로 감싸줌
        width: MediaQuery.of(context).size.width, //lvl_1 컬럼로우 섹션 다시보기
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(
              height: 16.0,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
