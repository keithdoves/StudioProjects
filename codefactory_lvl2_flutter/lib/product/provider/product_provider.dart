import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/provider/pagination_provider.dart';
import 'package:codefactory_lvl2_flutter/product/model/product_model.dart';
import 'package:codefactory_lvl2_flutter/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_provider.g.dart';

@riverpod
class Product extends _$Product {
  @override
  CursorPaginationBase build() {
    final repository = ref.watch(productRepositoryProvider);
    return initialize(repository);
  }
}
