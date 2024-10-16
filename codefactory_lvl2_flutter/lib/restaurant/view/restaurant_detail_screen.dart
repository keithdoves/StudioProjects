import 'package:codefactory_lvl2_flutter/common/const/data.dart';
import 'package:codefactory_lvl2_flutter/common/dio/dio.dart';
import 'package:codefactory_lvl2_flutter/common/layout/default_layout.dart';
import 'package:codefactory_lvl2_flutter/product/component/product_card.dart';
import 'package:codefactory_lvl2_flutter/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../component/restaurant_card.dart';
import '../model/restaurant_detail_model.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  RestaurantDetailScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();

    //인터셉터 추가
    dio.interceptors.add(
      CustomInterceptor(
        storage: storage,
      ),
    );

    final repository =
        RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
    return repository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
        future: getRestaurantDetail(),
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // final item = RestaurantDetailModel.fromJson(snapshot.data!);
          //더 이상 필요없음. Model에 Mapping된 Data가 나오기 때문

          return CustomScrollView(
            slivers: [
              renderTop(model: snapshot.data!),
              renderLabel(),
              renderProducts(products: snapshot.data!.products),
            ],
          );
        },
      ),
    );
  }
}

SliverToBoxAdapter renderTop({
  required RestaurantDetailModel model,
}) {
  return SliverToBoxAdapter(
    //sliver안에 일반 위젯을 넣으려면 이걸로 감싸야함.
    child: RestaurantCard.fromModel(
      model: model,
      isDetail: true,
    ),
  );
}

SliverPadding renderLabel() {
  return SliverPadding(
    padding: EdgeInsets.symmetric(
      horizontal: 16.0,
    ),
    sliver: SliverToBoxAdapter(
      child: Text(
        '메뉴',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

SliverPadding renderProducts({
  required List<RestaurantProductModel> products,
}) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(
      horizontal: 16.0,
    ),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final model = products[index];
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ProductCard.fromModel(
              model: model,
            ),
          );
        },
        childCount: products.length,
      ),
    ),
  );
}
