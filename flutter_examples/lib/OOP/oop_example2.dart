import 'package:flutter/material.dart';

class OopExample2 extends StatelessWidget {
  const OopExample2({super.key});

  @override
  Widget build(BuildContext context) {
    Idol apink = Idol(name: '에핑', membersCount: 5);

    TimesTwo tt = TimesTwo(number: 2);
    TimesFour tf = TimesFour(number: 2);

    Employee seulgi = Employee(name: '슬기');
    Employee chorong = Employee(name: '초롱');


    seulgi.name = '리사'; //인스턴스에 값이 귀속됨
    Employee.building = '해남빌딩'; //Class에 값이 귀속됨(Static)
    seulgi.printNameAndBuilding();
    chorong.printNameAndBuilding();

    Employee.printBuilding(); // Class에 값이 귀속됨(Static)
    //Static은 인스턴스화하지 않고 바로 class. 으로 접근하여 사용

    print('tf : ${tf.calculate()}');

    return Column(
      children: [
        Expanded(
          child: Container(color: Colors.deepOrange),
        ),
      ],
    );
  }
}

class Idol {
  String name;
  int membersCount;

  Idol({
    required this.name,
    required this.membersCount,
  });

  void sayName() {
    print('저는 ${this.name}입니다.');
  }

  void sayMembersCount() {
    print('${this.name}그룹은 ${this.membersCount}명의 멤버가 있습니다.');
  }
}

class BoyGroup extends Idol {
  BoyGroup({
    required super.name,
    required super.membersCount,
  });
}

//method - function(class 내부에 있는 함수)
class TimesTwo {
  final int number;

  TimesTwo({required this.number});

  int calculate() {
    return number * 2;
  }
}

//override - 덮어쓰다(우선시하다)
class TimesFour extends TimesTwo {
  TimesFour({required super.number});

  @override
  int calculate() {
    return super.calculate() * 2;
    //부모 클래스 메서드 자체를 불러올 수도 있음.
    //this.calculate()를 쓰면 지금 이 메서드를 호출하여 무한루프에 빠짐

    //return super.number * 4;
    //super 쓴 이유는 변수가 부모에 저장되어 있기 때문
    //사실 TimesFour의 인스턴스에도 있기 때문에 this 써도 됨
    //this는 생략 가능하니, 그냥 number만 써도 됨
  }
}

class Employee {
  // static은 instance에 귀속되지 않고 class에 귀속된다.
  static String? building;
  String name;

  Employee({required this.name});

  void printNameAndBuilding(){
    print('제 이름은 $name입니다. $building 건물에서 근무하고 있습니다.');
  }

  static void printBuilding(){
    print('저는 $building 건물에서 근무 중입니다.');
  }
}
