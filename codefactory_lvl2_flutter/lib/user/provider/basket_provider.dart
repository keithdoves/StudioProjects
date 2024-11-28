import 'package:codefactory_lvl2_flutter/user/model/basket_item_model.dart';
import 'package:codefactory_lvl2_flutter/user/model/patch_basket_body.dart';
import 'package:codefactory_lvl2_flutter/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../product/model/product_model.dart';

final basketProvider =
    StateNotifierProvider<BasketStateNotifier, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);

  return BasketStateNotifier(
    repository: repository,
  );
});

class BasketStateNotifier extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketStateNotifier({
    required this.repository,
  }) : super([]);

  Future<void> patchBasket() async {
    await repository.fetchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                  productId: e.product.id, count: e.count),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 요청을 먼저 보내고
    // 응답이 오면
    // 캐시를 업데이트 했다.(반응느림)
    // 요청이 성공할 것이라는 가정아래
    // 캐시를 먼저 업데이트

    // 1) 아직 장바구니에 해당되는 상품이 없다면
    //    장바구니에 상품을 추가한다.
    // 2) 만약에 이미 들어있다면
    //    장바구니에 있는 값에 +1한다.
    final exists = //null이 아닐 때, 존재함.
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map(
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count + 1,
                  )
                : e,
          )
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        ),
      ];
    }
    // Optimistic Response : 요청 시점
    // 응답이 성공할거라고 가정하고 상태를 먼저 업데이트 함.
    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    // true면 count와 관계없이 아예 삭제한다.
    bool isDelete = false,
  }) async {
// 1) 장바구니에 상품이 존재할 때,
//   a) 상품의 카운트가 1보다 크면 -1한다.
//   b) 상품의 카운트가 1이면 삭제한다.
// 2) 상품이 존재하지 않을 때,
//    즉시 함수를 반환하고 아무것도 하지 않는다.
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    } else {
      final existingProduct =
          state.firstWhere((e) => e.product.id == product.id);
      if (existingProduct.count == 1 || isDelete == true) {
        state = state
            .where(
              (e) => e.product.id != product.id,
            )
            .toList();
      } else {
        state = state
            .map(
              (e) => e.product.id == product.id
                  ? e.copyWith(count: e.count - 1)
                  : e,
            )
            .toList();
      }
    }
    await patchBasket();
  }
}
