import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/provider/pagination_provider.dart';
import 'package:codefactory_lvl2_flutter/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../rating/model/rating_model.dart';

//id를 받기위해 family modifier 사용
final restaurantRatingProvider = StateNotifierProvider.family<
    RestaurantRatingStateNotifier,
      // state의 타입을 넣어줌
      //즉 StateNotifier<T> T에 있는 타입을 넣어줌
      //PaginationProvider로 가서 T를 찾아야함
    CursorPaginationBase,
      //family 타입
    String
    >((ref, id) {
      final repo = ref.watch(restaurantRatingRepositoryProvider(id));
  return RestaurantRatingStateNotifier(repository: repo);
});

class RestaurantRatingStateNotifier
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  //final RestaurantRatingRepository repository;

  RestaurantRatingStateNotifier({
    required super.repository,
  });
}
