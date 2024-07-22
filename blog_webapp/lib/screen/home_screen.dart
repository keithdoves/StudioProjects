import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final homeUrl = Uri.parse('https://blog.codefactory.ai');

class HomeScreen extends StatelessWidget {
  WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted) //webview에서 자바스크립트를 사용하도록 설정
  ..loadRequest(homeUrl);
  //..을 붙이지 않으면 loadRequest에서 반환된 값이 controller에 입력됨.
  //..을 붙이면 이 함수를 실행한 대상을 리턴함
  //ex : WebViewController();는 WebViewController를 리턴함
  //ex : WebViewController()..loadRequest(homeUrl);는 loadRequest(homeUrl)을 실행한 WebViewController를 리턴함
  //보통 controller를 파라미터로 넣으면, 컨트롤러로 해당 위젯을 제어 가능
  HomeScreen({super.key}); //const로 선언하려면 그 안의 값 모두 const로 선언해야 함

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Junglim Architecture',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [ //appbar에 들어갈 버튼
          IconButton(
            onPressed: () { //callback function : 누르면 다시 돌아와서 실행함
              controller.loadRequest(homeUrl);
            },
            icon: Icon(Icons.home),
          )
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
