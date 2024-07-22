import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Home Screen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'button Style',
                ),
                style: ButtonStyle(
                  //Material State
                  //
                  // hovered - 호버잉 상태(마우스 커서 올려 놓은 상태/ 모바일 X)
                  // focused - 포커스 됐을때(텍스트 필드/ 버튼 해당 없음)
                  // pressed - 눌렀을 때
                  // dragged - 드래그 됐을때
                  // selected - 선택됐을 때(체크박스, 라디오 버튼)
                  // scrollUnder - 다른 컴포넌트 밑으로 스크롤링 됐을 때
                  // disabled - 비활성화 됐을때
                  // error - 에러 상태
                  textStyle: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      );
                    }
                    return TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    );
                  }),
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.grey;
                    }
                    return Colors.amber;
                  }), //resolveAll : 모든 상태에 적용
                  foregroundColor:
                      MaterialStateProperty.resolveWith(//상태에 따라 다른 색 적용
                          (Set<MaterialState> states) {
                    //states에 MaterialState가 저장됨
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.white;
                    }

                    return Colors.red;
                  }),
                  padding: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return EdgeInsets.all(100.0);
                    }
                    return EdgeInsets.all(20.0);
                  }),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Elevated Button',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white, //그림자 색깔
                  shadowColor: Colors.green, // 3D 입체감 높이
                  elevation: 4.0, //입체감을 더 줌
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                  padding: EdgeInsets.all(18.0),
                  side: BorderSide(color: Colors.green, width: 4.0),
                ),
              ),
              OutlinedButton(
                  onPressed: () {},
                  child: Text('Outlined Button'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                  )),
              TextButton(
                onPressed: () {},
                child: Text('Text Button'),
              ),
            ],
          ),
        ));
  }
}
