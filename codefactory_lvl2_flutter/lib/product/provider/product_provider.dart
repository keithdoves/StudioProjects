import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/provider/pagination_provider.dart';
import 'package:codefactory_lvl2_flutter/product/model/product_model.dart';
import 'package:codefactory_lvl2_flutter/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

 final productProvider = StateNotifierProvider<
ProductStateNotifier, CursorPaginationBase>(
         (ref){
  final repo = ref.watch(productRepositoryProvider);
  return ProductStateNotifier(repository: repo);
});

class ProductStateNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({
    required super.repository,
  });
}
