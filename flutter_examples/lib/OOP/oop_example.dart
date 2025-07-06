import 'package:flutter/material.dart';

class OopExample extends StatelessWidget {
  const OopExample({super.key});

  @override
  Widget build(BuildContext context) {
    Idol blackpink =   Idol(
      name: '블핑',
      members: ['지수', '제니', '리사', '로제'],
    );

    Idol blackpink2 =   Idol(
      name: '블핑',
      members: ['지수', '제니', '리사', '로제'],
    );

    print(blackpink == blackpink2);
    // const를 붙이고 파라미터를 똑같이 입력하면 같은 인스턴스(true)
    // const 없이 인스턴스화했으면 false가 나옴

    Idol bts = Idol.fromList(['진', 'RM']);
    print(bts.name);

    String fm = blackpink.firstMember;
    String setterdMember = blackpink.firstMember = 'Lloyd';
    print('1st member $fm And setterdMember is $setterdMember');



    return Column(
      children: blackpink.members.map((e) {
        return Text(
          e,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        );
      }).toList(),
    );
  }
}

// Idol앞에 _를 붙이면 private 하게 됨 = 다른 파일에서 import 안 됨.
class Idol {
  //프로퍼티에 final을 붙이는 순간
  //immutable 한 클래스가 됨.
  //black.name='bts'; 이런 값 변경이 불가함.
  //개발자들은 이런 불변객체를 선호. 값을 바꿔야하면, 새로운 인스턴스 생성
   String name;
   List<String> members;

  /*
 positional parameter
 Idol(String name, List<String> members)
      : this.name = name,
        this.members = members;
  Idol(this.name, this.members);
*/

   Idol({
    required this.name,
    required this.members,
  });

  Idol.fromList(List values)
      : this.members = [values[0], values[1]],
        this.name = values[1];

  void sayHello() {
    print('Hello we are Black');
  }

  void introduce() {
    members.map(
      (e) {
        print(e);
      },
    ).toList();
  }
  // getter&setter는 함수로 기능적 차이는 없음.
  // getter
  String get firstMember{
    return this.members[0];
  }
  // setter : 현대엔 immutable을 위해 setter를 거의 안 씀.
  set firstMember(String name){
    this.members[0] = name;
  }
}
