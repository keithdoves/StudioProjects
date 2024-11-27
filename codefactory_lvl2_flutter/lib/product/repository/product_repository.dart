import 'package:codefactory_lvl2_flutter/common/dio/dio.dart';
import 'package:codefactory_lvl2_flutter/common/model/pagination_params.dart';
import 'package:codefactory_lvl2_flutter/common/repository/base_pagination_repository.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../model/product_model.dart';

part 'product_repository.g.dart';


final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductRepository(
    dio,
    baseUrl: 'http://$ip/product',
  );
});

// http://$ip/product
@RestApi()
abstract class ProductRepository implements IBasePaginationRepository<ProductModel> {
  factory ProductRepository(
    Dio dio, {
    String baseUrl,
  }) = _ProductRepository;

  @GET('/')
  @Headers({'accessToken': true})
  @override
  Future<CursorPagination<ProductModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
