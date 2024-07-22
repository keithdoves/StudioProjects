import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<int>( //streamBuilder는 스트림 닫는 것을 해줌
          stream: streamNumbers(),
          //getNumber 이 함수가 값을 반환할 때마다 새로 Build(of FutureBuilder)
          //그리고 setState에 의해 다시 build가 실행될 때도, 다시 FutureBuilder 실행됨
          //그러나 setState에 의해 다시 FutureBuilder가 실행될 때엔, 기존의 snapshot값을 기억하고 있음

          //처음에는 conState - waiting -> done
          //처음에는 data     - null  -> done
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      /*      if (!snapshot.hasData) { //한번도 데이터가 들어오지 않았을 때(최초에)
              return Center(
                child: CircularProgressIndicator(),
              );
            }*/

            if(snapshot.hasData){
              //데이터가 있을 때 위젯 렌더링
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'StreamBuilder',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'conState : ${snapshot.connectionState}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Data : ${snapshot.data}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Error : ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('setState',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              );
            }
            if(snapshot.hasError){
              //에러가 있을 때 위젯 렌더링
              return Center(
                child: Text(
                  '에러 발생 : ${snapshot.error}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
            //로딩중일 때, 위젯 렌더링


          },
        ),
      ),
    );
  }

  Future<int> getNumber() async {
    await Future.delayed(
      Duration(seconds: 3),
    );
    final random = Random();
    //throw Exception('에러 발생!');
    return random.nextInt(100);
  }

 //stream의 상태는 waiting, active, done, error
  Stream<int> streamNumbers() async* {
    for(int i = 0; i <10; i++){
    await Future.delayed(Duration(seconds: 1));


      yield i;
    }
  }
}
