import 'package:flutter/material.dart';
import 'package:flutter_examples/OOP/oop_example.dart';

class OopExample3 extends StatelessWidget {
  const OopExample3({super.key});

  @override
  Widget build(BuildContext context) {
    Lecture lecture = Lecture(id: 123, name: 'OOP');

    lecture.printIdType(); //T의 타입 확인

    return Container(
      color: Colors.blueAccent,
      child: const Icon(
        size: 100.0,
        Icons.snowboarding_outlined,
        color: Colors.lime,
      ),
    );
  }
}

//break - 루프를 나와라
//continue - 현재 루프의 인덱스를 무시하고,  루프의 다음 인덱스로 넘어가라.
//interface
abstract class IdolInterface {
  String name;

  IdolInterface({required this.name});

  void sayName(); //abstract 키워드로 메서드의 바디가 필요없어짐.
}

class BoyGroup implements IdolInterface {
  String name;

  BoyGroup({required this.name});

  void sayName() {
    print('저희는 $name입니다');
  }
}

// generic - 타입을 외부에서 받을 때 사용
class Lecture<T> {
  final T id;
  final String name;

  Lecture({
    required this.id,
    required this.name,
  });

  void printIdType() {
    print(id.runtimeType);
  }

// 이건 positional로 생성자 선언하는 것
// Lecture(this.id, this.name);
}

// final로 클래스를 선언하면
// extends, implement, 또는 mixin 으로 사용이 불가능
// 다만 같은 파일 안에선 할 수 있다.
final class Person {
  final String name;
  final int age;

  Person({
    required this.name,
    required this.age,
  });
}

// base로 선언하면 eextend는 가능하지만 implement는 불가능하다.
// base, sealed, final로 선언된 클래스만 extend가 가능하다.
base class PersonBase {
  final String name;
  final int age;

  PersonBase({
    required this.name,
    required this.age,
  });
}

// interface로 선언하면 implement만 가능하다
interface class PersonIF {
  final String name;
  final int age;

  PersonIF({
    required this.name,
    required this.age,
  });
}

//sealed 클래스는 abstruct이면서 final이다.
//그리고 패턴매칭을 사용 할 수 있도록 해준다.
sealed class PersonSealed {}

class Idol extends PersonSealed {}
class Engineer extends PersonSealed {}
class Chef extends PersonSealed {}

//sealed class를 사용하면 모든 클래스가 다 매칭되었는지 확인할 수 있다(_ 빼면 에러남)
String whoIsHe(PersonSealed personSealed) => switch(personSealed){
  Idol i => '아이돌', //Idol 타입일 경우 아이돌 리턴
  Engineer e => '엔지니어', //Engineer 타입일 경우 엔지니어 리턴
  _=>'디펄트 나머지,' //Try adding a wildcard pattern or cases that match 'Chef()'.
};

// 모든 class는 Object를 상속한 것
