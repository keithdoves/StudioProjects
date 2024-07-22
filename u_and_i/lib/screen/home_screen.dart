import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
 //최상위 위젯에서 모두 데이터(상태)를 관리하고 있음
 //복잡해보이나 데이터 공유시 필수적임.
 //데이터는 무조건 부모 클래스에서 자식 클래스로 흐르기 때문에(자식클래스에서 부모 클래스로 데이터를 올려줄 수 없음)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[500],
      body: SafeArea(
        bottom: false,
        child: Container(
          width: MediaQuery.of(context)
              .size
              .width, //컬럼의 가로길이 설정 2줄 외우기(Container, MediaQuery)
          child: Column(
            children: [
              _TopPart(
                selectedDate: selectedDate,
                onPressed: onHeartPressed,
              ),
              _BottomPart(),
            ],
          ),
        ),
      ),
    );
  }

  void onHeartPressed() {
    //함수
    final DateTime now = DateTime.now();
    //dialog
    showCupertinoDialog(
      //showCupertinoDialog는 ios 스타일의 다이얼로그를 보여준다.
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Align(
          //flutter에서 어디에 정렬할 지 정하지 않으면 전체화면을 차지하게 된다.
          //Align 위젯을 사용하여 정렬을 해준다.
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 300.0,
            child: CupertinoDatePicker(
              //CupertinoDatePicker는 ios 스타일의 날짜 선택 위젯이다.
              mode: CupertinoDatePickerMode.date, //날짜만 선택할 수 있도록 설정
              initialDateTime: selectedDate,
              maximumDate: DateTime(
                //현재 날짜까지만 선택할 수 있도록 설정
                now.year,
                now.month,
                now.day,
              ),
              onDateTimeChanged: (DateTime date) {
                //날짜가 변경되면 호출되는 콜백함수
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),

        );
      },
    );
  }
}
//플러터 복습
//플러터 함수형프로그래밍 다시보기
//플러터 인강 듣기

class _TopPart extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPressed;

  _TopPart({required this.selectedDate, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //build에 변수선언함
    final theme = Theme.of(context); //가장 가까운 부모 클래스의 테마를 가져옴
    final textTheme = theme.textTheme;
    //final size = MediaQuery.of(context).size; //가장 가까운 부모 클래스의 사이즈를 가져옴
    final now = DateTime.now();

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Talking Backwards',
          style: textTheme.displayLarge,
          ),
          Column(
            children: [
              Text(
                'Real Estate',
                style: textTheme.displayMedium,
              ),
              Text(
                '${selectedDate.year}.${selectedDate.month}.${selectedDate.day}',
                style: textTheme.bodyText2,
              ),
            ],
          ),
          IconButton(
            iconSize: 60.0,
            onPressed: onPressed, //(){} 함수를 제공하고 있음
            //(){} 형태가 아닌 변수로 제공하는 사고의 흐름
            //1. 상태를 자식 내부가 아닌, 외부에서 관리하고 싶음
            //2. onPressed에는 함수를 전달해야함.
            //3. 어떤 함수가 필요한지 확인하기 위해서 onPressed 우클릭 후, Go to Definition을 눌러서 확인함
            //4. onPressed에는 VoidCallback이 필요함을 확인함 (final VoidCallback? onPressed;)
            //5. 부모 클래스에 void onHeartPressed(){} 함수를 만들어서 _TopPart 호출시 전달함
            //6. _TopPart에서 VoidCallback타입의 변수를 선언하고, 생성자를 통해서 부모로부터 전달받음
            //7. onPressed를 통해서 부모로부터 전달받은 함수를 onPressed : 에 전달함
            icon: Icon(
              Icons.egg_alt_rounded,
              color: Colors.yellow[400],
              size: 70.0,
            ),
          ),
          Text(
            'D+${DateTime(
                  now.year,
                  now.month,
                  now.day,
                ).difference(selectedDate).inDays + 1}',
                style: textTheme.headline2,
          ),
        ],
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Image.asset(
        'asset/img/middle_image.png',
      ),
    );
  }
}
