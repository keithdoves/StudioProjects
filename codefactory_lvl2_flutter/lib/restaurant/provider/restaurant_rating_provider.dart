import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/provider/pagination_provider.dart';
import 'package:codefactory_lvl2_flutter/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../rating/model/rating_model.dart';

part 'restaurant_rating_provider.g.dart';

@riverpod
class RestaurantRating extends _$RestaurantRating {
  @override
  CursorPaginationBase build(String id) {
    final repository = ref.watch(restaurantRatingRepositoryProvider(id));
    return initialize(repository);
  }
}
