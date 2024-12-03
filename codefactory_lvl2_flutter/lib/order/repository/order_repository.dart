import 'package:codefactory_lvl2_flutter/common/dio/dio.dart';
import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/model/pagination_params.dart';
import 'package:codefactory_lvl2_flutter/common/repository/base_pagination_repository.dart';
import 'package:codefactory_lvl2_flutter/order/model/order_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';
import '../model/post_order_body.dart';

part 'order_repository.g.dart';

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) {
    final Dio dio = ref.watch(dioProvider);

    return OrderRepository(
      dio,
      baseUrl: 'http://$ip/order',
    );
  },
);

//http://$ip/order
@RestApi()
abstract class OrderRepository
    implements IBasePaginationRepository<OrderModel> {
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<OrderModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @POST('')
  @Headers({
    'accessToken': 'true',
  })
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
