import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/provider/pagination_provider.dart';
import 'package:codefactory_lvl2_flutter/order/model/order_model.dart';
import 'package:codefactory_lvl2_flutter/order/model/post_order_body.dart';
import 'package:codefactory_lvl2_flutter/order/repository/order_repository.dart';
import 'package:codefactory_lvl2_flutter/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'order_provider.g.dart';

@riverpod
class Order extends _$Order {
  @override
  CursorPaginationBase build() {
    final repository = ref.watch(orderRepositoryProvider);
    return initialize(repository);
  }

  Future<bool> postOrder() async {
    try {
      final uuid = Uuid();
      final id = uuid.v4();
      final basketState = ref.read(basketProvider);

      await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: basketState
              .map(
                (e) => PostOrderBodyProduct(
                  productId: e.product.id,
                  count: e.count,
                ),
              )
              .toList(),
          totalPrice: basketState.fold<int>(
            0,
            (p, n) => p + (n.count * n.product.price),
          ),
          createdAt: DateTime.now().toString(),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
