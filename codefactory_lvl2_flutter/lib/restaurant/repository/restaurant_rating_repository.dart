import 'package:codefactory_lvl2_flutter/common/dio/dio.dart';
import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/repository/base_pagination_repository.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';
import '../../common/model/pagination_params.dart';
import '../../rating/model/rating_model.dart';

part 'restaurant_rating_repository.g.dart';

//만들고 Provider에 담는다.
final restaurantRatingRepositoryProvider = Provider.family<
    RestaurantRatingRepository,
    String>((ref, id) {
      final dio = ref.watch(dioProvider);
      return RestaurantRatingRepository(dio, baseUrl: 'http://$ip/restaurant/$id/rating');
});

// http://ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository implements IBasePaginationRepository<RatingModel>{

  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
  _RestaurantRatingRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}