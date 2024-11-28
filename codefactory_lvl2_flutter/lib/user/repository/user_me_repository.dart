import 'package:codefactory_lvl2_flutter/common/const/data.dart';
import 'package:codefactory_lvl2_flutter/common/dio/dio.dart';
import 'package:codefactory_lvl2_flutter/user/model/basket_item_model.dart';
import 'package:codefactory_lvl2_flutter/user/model/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../model/patch_basket_body.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>(
  (ref) {
    print('2.userMeRepositoryProvider 초기화');
    final Dio dio = ref.watch(dioProvider);
    return UserMeRepository(
      dio,
      baseUrl: 'http://$ip/user/me',
    );
  },
);

// http://$ip/user/me
@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getMe();

  @GET('/basket')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<BasketItemModel>> getBasket();

  @PATCH('/basket')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<BasketItemModel>> fetchBasket({
    @Body() required PatchBasketBody body,
  });
}
