import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/shopping_item_model.dart';

//provider로 만들어야 위젯에서 사용 가능.
//StateNotifier를 상속한 클래스를 쓰려면
//StateNotifierProvider를 써야 함.
//제네릭에다 StateNotifier를 상속한 어떤 class를 쓸 것인지
//그리고 그 클래스가 관리하는 상태의 타입을 넣어줌
// 이 프로바이더를 호출하면, 어디서든
// ShoppingListNotifier() 인스턴스를 리턴받을 수 있음.
final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItemModel>>(
  (ref) => ShoppingListNotifier(), // 관리할 클래스를 인스턴스로 만들어줌.
);

//stateNotifier를 사용하려면 무조건 상태 관리하려는 값의 정의가 필요함
// 상태관리를 원하는 값 :
//  1.StateNotifer의 제네릭으로 넣어주기
//  2.super 컨스트럭터의 값으로 넣어주기
class ShoppingListNotifier extends StateNotifier<List<ShoppingItemModel>> {
  ShoppingListNotifier()
      : super([
          //처음에 어떤 값으로 상태를 초기화 할 지 넣어줌
          //여기 들어간 값이 state에 들어가고, 상태가 관리된다.
          ShoppingItemModel(
            name: '김치',
            quantity: 3,
            hasBought: false,
            isSpicy: true,
          ),
          ShoppingItemModel(
            name: '라면',
            quantity: 5,
            hasBought: false,
            isSpicy: true,
          ),
          ShoppingItemModel(
            name: '삼겹살',
            quantity: 10,
            hasBought: false,
            isSpicy: false,
          ),
          ShoppingItemModel(
            name: '수박',
            quantity: 3,
            hasBought: false,
            isSpicy: false,
          ),
          ShoppingItemModel(
            name: '카스테라',
            quantity: 3,
            hasBought: false,
            isSpicy: false,
          ),
        ]);

  //넣은 name과 같은 모델의 hasBought값을 토글해줌
  void toggleHasBought({required String name}) {
    //state는 extends StateNotifier가 제공하는 값
    state = state
        .map((e) => e.name == name
            ? ShoppingItemModel(
                name: e.name,
                quantity: e.quantity,
                hasBought: !e.hasBought,
                isSpicy: e.isSpicy,
              )
            : e)
        .toList();
  }
}
