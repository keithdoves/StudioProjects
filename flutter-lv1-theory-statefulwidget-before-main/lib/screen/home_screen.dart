import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Color color;

  HomeScreen({
    required this.color,
    Key? key, //부모에게 키를 전달받음
  }) : super(key: key) {
    //부모 클래스의 생성자를 초기화하여 key를 다시 부모에게 전달함.
    print('HomeScreen constructor');
  }

  @override
  State<StatefulWidget> createState() {
    print('HomeScreen createState');
    return _HomeScreenState();
    // creaeteState()는 StatefulWidget과 연결될 State 객체를 생성해서 반환해주는 팩토리 메서드
    // createState()는 위젯이 Element 트리에 처음 삽입될 때 한 번만 호출됨.
    // 같은 위젯 인스턴스가 rebuild 되더라도 createState()는 다시 호출되지 않음.
    // createState() 내에서는 context가 아직 할당되지 않았고, 위젯 트리와 연결도 되지 않은 상태
    // 따라서 context나 widget에 접근 불가(애초에 widget은 State 클래스 안에서 해당 위젯 인스턴스를 가리키기 위해 정의된 프로퍼티) 
    // widget : State 내에서 위젯 인스턴스를 가리킴
    // 따라서 createState()에는 코드작성 하지 않는 것이 유지보수, 테스트에 유리하고 설계 의도에 부합함.
  }
}

class _HomeScreenState extends State<HomeScreen> {
  //State<HomeScreen>은 HomeScreen의 State를 의미함
  //<>는 제네릭으로, 'has a' 또는 'operates on' 관계를 나타냄 : HomeScreen has a HomeScreenState.
  //State는 StatefulWidget과 세트로 들어감. StatefulWidget이 생성되면 State도 생성됨
  int number = 0;

  @override
  void initState() {
    print('HomeScreenState initState');
    super.initState(); //무조건 super.initState()를 호출해야 함
    //state를 만들기 위해 몇가지 실행하는 게 있기 때문
  }

  @override
  void didChangeDependencies() {
    print('HomeScreenState didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    print('HomeScreenState deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return GestureDetector(
      //화면에서 인식할 수 있는 모든 행동을 넣을 수 있음(터치, 드래그, 스크롤 등)
      onTap: () {
        setState(() {
          //setState()는 함수를 파라미터로 넣음
          number++;
        });
      },
      child: Container(
        width: 50.0,
        height: 50.0,
        color: widget.color, //widget은 StatefulWidget을 의미함
        child: Center(
          child: Text(
            number.toString(),
          ),
        ),
      ),
    );
  }
}
