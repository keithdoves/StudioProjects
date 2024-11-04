import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/model/shopping_item_model.dart';

//.select는 불필요한 랜더링을 하지 않기 위해 watch할 대상을 선택하는 메소드
final selectProvider = StateNotifierProvider<SelectNotifier, ShoppingItemModel>(
  (ref) => SelectNotifier(),
);

class SelectNotifier extends StateNotifier<ShoppingItemModel> {
  SelectNotifier()
      : super(
          ShoppingItemModel(
            name: '김치',
            quantity: 3,
            hasBought: false,
            isSpicy: true,
          ),
        );

  void toggleHasBought() {
    state = state.copyWith(
      hasBought: !state.hasBought,
    );
  }

  void toggleIsSpicy() {
    state = state.copyWith(
      isSpicy: !state.isSpicy,
    );

    // final ts = TextStyle(
    //   fontWeight: FontWeight.w500,
    //   fontSize: 20,
    // );
    //
    // final ts2 = ts.copyWith(
    //   fontSize: 10.0,
    // );

    // copyWith() 없으면 이렇게 변경하지 않은 것들도 써줘야함
    //  state = ShoppingItemModel(
    //    name: state.name,
    //    quantity: state.quantity,
    //    hasBought: state.hasBought,
    //    isSpicy: !state.isSpicy,
    //  );
  }
}
