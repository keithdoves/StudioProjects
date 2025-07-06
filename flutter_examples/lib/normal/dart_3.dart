import 'package:flutter/material.dart';

class Idol {
  final String name;
  final int age;

  Idol({
    required this.name,
    required this.age,
  });
}

class Dart3 extends StatelessWidget {
  const Dart3({super.key});

  @override
  Widget build(BuildContext context) {
    //디스트럭쳐링_ 변수를 따로 선언할 필요가 없음
    final (name, age) = ('민지', 20);
    print(name);
    print(age);

    //List_디스트럭쳐링
    final newJeans = ['민지', '해린'];
    final [String a, String b] = newJeans;
    print(a); //민지

    final numbers = [1, 2, 3, 4, 5, 6, 7, 8];
    final [x, y, ..., z] = numbers; //rest 매칭 / ...은 한 번만 쓸 수 있음.
    print(x); //1
    print(y); //2
    print(z); //8

    final [xx, yy, ...rest, zz] = numbers;
    print(xx);
    print(yy);
    print(zz);
    print(rest); // [3, 4, 5, 6, 7]

    //_ : 무시됨(삭제됨)
    final [xxx, _, yyy, ...rest1, zzz, _] = numbers;
    print(xxx); // 1
    print(yyy); // 3
    print(zzz); // 7

    final minJiMap = {'name': '민지', 'age': 19};
    final {'name': name3, 'age': age3} = minJiMap;
    print(name3);
    print(age3);

    final minJiIdol = Idol(name: '민지', age: 19);
    final Idol(name: name4, age: age4) = minJiIdol;
    print(name4);


    //Patten Matching _Validation


    final minJi =('민지', 2);
    final (name5 as String, age5 as int) = minJi;
    print(name5); // 만약 as int로 했다면 런타임 에러가 남./ 더 큰 문제를 미연에 방지
    // 즉 조용히 잘못된 상태로 흘러가지 않음.
    print(age5);

    bool hasNameAndAgeTypes(Map<String, dynamic> map) {
      return switch (map) {
        {'name': String name, 'age': int age} => true,
        _ => false,
      };
    }

    hasNameAndAgeTypes(minJiMap);

    void switcher(dynamic anything){
      switch(anything){
        case 'aaa':
          print('match: aaa');
        case ['1','2']:
          print('match[1,2]');
        case [_, _, _]:
          print('match [_, _, _]');
        case [int a, int b]:
          print('match [int $a, int $b]');
        default:
          print('no match');
      }
    }

    void ifMatcher(){
      final minji = {
        'name' : '민지',
        'age' : '20',
      };

      print('---');
      //패턴매칭 minji가 저런 형태의 map이 아니면 false가 됨
      if(minji case{'name':String name, 'age':int age}){
        print(name);
        print(age);
      }
    }


    // Map은 Value를 dynamic할 수 밖에 없음
    // Map<String, dynamic> /name => String, age =>int 이기 때문
    // Record로 받으면 타입 지정 가능
    (String, int) nameAndAge(Map<String, dynamic> json) {
      return (json['name'] as String, json['age'] as int);
    }

    // 레코드는 튜플과 같은 형태로
    // 요소 추가, 이동, 삭제가 불가능한 고정형
    // 비교 시 값 기반 비교 가능(클래스는 인스턴스 기반)
    // 위치 기반 레코드
    (String, int, bool) info = ('Alice', 30, true);
    print(info.$1); // 'Alice'
    print(info.$2); // 30

    // 명명된 필드 레코드
    ({String name, int age}) person = (name: 'Bob', age: 25);
    print(person.name); // 'Bob'
    print(person.age); // 25

    //Destrucuring(구조분해)
    var (x3, y3) = (10, 'ten');
    var (name: n3, age: a3) = (name: 'Carol', age: 28);
    print(x3); //10
    print(n3); //Carol

    switcher('aaa');
    switcher([1,2]); //no match
    switcher(['a', 'b', 'c']); //match [_, _, _]
    switcher([6, 7]); //match [int 6, int 9]
    return const Placeholder();
  }
}
