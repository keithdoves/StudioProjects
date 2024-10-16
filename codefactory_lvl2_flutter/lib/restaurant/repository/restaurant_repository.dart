import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../model/restaurant_model.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository{ //인스턴스화 되지 않도록 추상으로 선언
  // http://$ip/restaurant
 factory RestaurantRepository(Dio dio, {String baseUrl})
  = _RestaurantRepository; // =으로 factory constructor 선언가능

  // http://$ip/restaurant/
  @GET('/')
  @Headers({
   'accessToken' : 'true',
  }) //RestaurantModel을 받을 수 없음. 반환 하는 데이터가 다름.
   Future<CursorPagination<RestaurantModel>>paginate();

 // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
   'accessToken' : 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
   @Path() required String id,
    //id의 변수를 이 파라미터의 값으로 대체함. 괄호 안에 실제 초기값을 넣어도 됨.
}); //retrofit은 api응답과 완전히 똑같은 클래스(model)가 필요함.
}