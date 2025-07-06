import 'package:flutter/material.dart';

List<String> blackPink = ['로제', '지수', '리사', '제니'];
Map blackPinkMap = blackPink.asMap();

Set blackPinkSet = Set.from(blackPink); //리스트로부터 set 만들기_toSet()과 같음.

//map - newBlackPink와 newBlackPink2는 다름
//map으로 새로운 리스트를 만든 것. 즉 깊은 복사가 이루어짐.
final newBlackPink = blackPink.map((e) => '⭐️ $e').toList();
final newBlackPink2 = blackPink.map((e) {
  return '⭐️ $e';
}).toList();

//split&map
String number = '13579';
final parsed = number.split('').map((x) => '$x.jpg').toList();

Map<String, String> harryPotter = {
  'Harry Potter': '해리 포터',
  'Ron Weasley': '론 위즐리',
  'Hermione Granger': '헤르미온느 그레인저',
};
//map()을 mapping하는 스타일( Map ➡️ Map )
final mappedHarry = harryPotter.map(
  (k, v) => MapEntry('Harry Potter Character $k', '해리포터 캐릭터 $v'),
); //  ➡️ Map을 리턴함

// Map  ➡️ List
final keys = harryPotter.keys.map((x) => 'HPC $x');
final values = harryPotter.values.map((x) => 'HPC $x');

//where
List<Map<String, String>> people = [
  {'name': '로제', 'group': '블랙핑크'},
  {'name': '지수', 'group': '블랙핑크'},
  {'name': 'RM', 'group': 'BTS'},
  {'name': '뷔', 'group': 'BTS'},
];

final blackPinkFromList = people.where((x) => x['group'] == '블랙핑크').toList();

//reduce : 멤버들의 타입과 리턴 타입이 같아야 한다.
List<int> numbers = [1, 3, 5, 7, 9];
List<String> words = ['Eclipse ', '민트향, ', '레몬향 ', '팝니다.'];
final sum = numbers.reduce((prev, next) {
  print('------');
  print('previous : $prev');
  print('next : $next');
  print('total : ${prev + next}');
  return prev + next;
});
final sentence = words.reduce((p, n) => p + n);

//fold : 멤버와 리턴 값이 달라, 제네릭으로 리턴 타입을 설정 해야함.
// 0이 맨처음에 들어감. 0+1
final foldSum = numbers.fold<int>(0, (prev, next) => prev + next);
final numberOfChar = words.fold<int>(0, (prev, next) => prev + next.length);

//cascade operator : 리스트 결합시 많이 사용함.
List<int> even = [2, 4, 6, 8];
final newEven = [...even]; //깊은 복사
List<int> odd = [1, 3, 5, 7, 9];

//실제 사용 예시
class Person {
  final String name;
  final String group;

  Person({
    required this.name,
    required this.group,
  });

//Map은 자유도가 높아서 class로 만듬.
//키에 오타가 있어도 프로그램적으로 알기 힘듬.
// nullable 등 더 세밀하게 설정 가능.
}

//Record : 여러 값을 하나의 그룹으로 묶는 튜플(tuple) 형태의 자료 구조
//Positional Parameter
(String, int) recordPerson = ('nginx', 20);
//print(recordPerson.$1); //'nginx'

//Named Parameter
({String name, int age}) namedRecordPerson = (name: 'jimmy', age: 27);
//print(namedRecordPerson.name);

List<Map<String, dynamic>> newJeans = [
  {'name': '하니', 'age': 18},
  {'name': '해린', 'age': 20},
];

List<(String, int)> recordNewJeans = [
  ('하니', 18),
  ('해린', 20),
];

//named 처럼 쓸 수 있음
List<({String name, int age})> recordNewJeans2 = [
  (
    name: '하니',
    age: 18,
  ),
  (
    name: '해린',
    age: 20,
  ),
];

final class FunctionalProgramming extends StatelessWidget {
  const FunctionalProgramming({super.key});

  @override
  Widget build(BuildContext context) {
    print(blackPink.asMap()); //List ➡️ Map : 인덱스가 키가 됨
    print(blackPink.toSet()); //List ➡️ Set : 중복 제거 됨
    print(blackPinkMap.keys); //Iterable 리턴이기 때문에 toList()해야 리스트 나옴
    print(blackPinkMap.values.toList());
    print(blackPinkSet.toList()); //Set ➡️ List

    print(newBlackPink);
    print(newBlackPink == newBlackPink2); //map - 깊은 복사

    print(parsed); //split()과 map을 이용한 사례

    print(mappedHarry); //MapEntry

    print(blackPinkFromList);
    print(sum);
    print(sentence);
    print(foldSum);
    print(numberOfChar);
    print([...even, ...odd]);

    final blackPinkClass = people
        .where((x) => x['group'] == '블랙핑크')
        .map((e) => Person(name: e['name']!, group: e['group']!))
        .toList();

    for (Person person in blackPinkClass) {
      print(person.name);
    }



    return Container(
      color: Colors.pinkAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Functional Programming',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30.0,
              color: Colors.lime,
            ),
          ),
        ],
      ),
    );
  }
}
