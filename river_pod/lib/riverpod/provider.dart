import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/model/shopping_item_model.dart';
import 'package:river_pod/riverpod/state_notifier_provider.dart';

// provider 안에 provider 강의 다시 들어보기
// ref.watch를 하고 provider를 넣으면 다른 provider를 볼 수 있음
final filteredShoppingListProvider = Provider<List<ShoppingItemModel>>(
  (ref) {
    //filterProvider 실행시, 이 Provider가 작동함
    //2가지 상태를 Watch(리스닝)
    final filterState = ref.watch(filterProvider);
    final shoppingListState = ref.watch(shoppingListProvider);

    // filterState에 따라서 shoppingListState를 갖고 오고자 함.
    // ALL을 누르면 모든 리스트 반환
    if (filterState == FilterState.all) {
      return shoppingListState; //그대로 리턴
    }
    //
    return shoppingListState
        .where(
          (element) => filterState == FilterState.spicy
              ? element.isSpicy
              : !element.isSpicy,
        )
        .toList();
  }, //filteredShoppingListProvider는 2가지 상태를 리스닝하면서
     //filterState에 따라 알맞는 shoppingListState를 리턴함.
);

enum FilterState {
  notSpicy,
  spicy,
  all,
}

final filterProvider = StateProvider<FilterState>((ref) => FilterState.all);
