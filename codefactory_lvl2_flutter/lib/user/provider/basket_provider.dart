import 'dart:async';

import 'package:codefactory_lvl2_flutter/user/model/basket_item_model.dart';
import 'package:codefactory_lvl2_flutter/user/model/patch_basket_body.dart';
import 'package:codefactory_lvl2_flutter/user/repository/user_me_repository.dart';
import 'package:collection/collection.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../product/model/product_model.dart';

part 'basket_provider.g.dart';

@riverpod
class Basket extends _$Basket {
  late final UserMeRepository _repository;
  late final Debouncer<dynamic> _updateBasketDebounce;
  StreamSubscription<dynamic>? _debounceSubscription;

  @override
  List<BasketItemModel> build() {
    _repository = ref.watch(userMeRepositoryProvider);
    _updateBasketDebounce = Debouncer<dynamic>(
      const Duration(seconds: 1),
      initialValue: null,
      checkEquality: false,
    );

    _debounceSubscription = _updateBasketDebounce.values.listen((_) {
      patchBasket();
    });

    ref.onDispose(() async {
      await _debounceSubscription?.cancel();
      _updateBasketDebounce.dispose();
    });

    return [];
  }

  Future<void> patchBasket() async {
    await _repository.fetchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                productId: e.product.id,
                count: e.count,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    final exists =
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

    _updateBasketDebounce.setValue(null);
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false,
  }) async {
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }

    final existingProduct =
        state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
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

    _updateBasketDebounce.setValue(null);
  }
}
