import 'package:codefactory_lvl2_flutter/common/dio/dio.dart';
import 'package:codefactory_lvl2_flutter/restaurant/component/restaurant_card.dart';
import 'package:codefactory_lvl2_flutter/restaurant/model/restaurant_model.dart';
import 'package:codefactory_lvl2_flutter/restaurant/repository/restaurant_repository.dart';
import 'package:codefactory_lvl2_flutter/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  RestaurantScreen({Key? key}) : super(key: key);

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    // CursorPagination 객체가 리턴되고
    // 그 안에 RestaurantModel이 data란 프로퍼티에
    // 들어있음
    final resp =
       await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
       .paginate();

    //CursorPagination의 List<T>타입의 data라는 프로퍼티를 갖고 옴
    return resp.data;

    // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    //
    // final resp = await dio.get(
    //   'http://$ip/restaurant',
    //   options: Options(
    //     headers: {
    //       'authorization': 'Bearer $accessToken',
    //     },
    //   ),
    // );

   // return resp.data['data']; //data키 안의 값만 갖고 옴
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: FutureBuilder<List<RestaurantModel>>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (_, index) {
                  return SizedBox(height: 16.0);
                },
                itemBuilder: (_, index) {
                  final pItem = snapshot.data![index];
                  // final pItem = RestaurantModel.fromJson(
                  //   item,
                  //);

                  /*final pItem = RestaurantModel(
                  // 이렇게 받아서 모델에 넣는 것을 모델에 구현함.
                      id: item['id'],
                      name: item['name'],
                      thumbUrl: 'http://$ip${item['thumbUrl']}',
                      tags: List.from(item['tags']),
                      priceRange: RestaurantPriceRange.values
                          .firstWhere((e) => e.name == item['priceRange']),
                      ratings: item['ratings'],
                      ratingsCount: item['ratingsCount'],
                      deliveryTime: item['deliveryTime'],
                      deliveryFee: item['deliveryFee']);*/

                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RestaurantDetailScreen(
                              id: pItem.id,
                            ),
                          ),
                        );
                      },
                      child: RestaurantCard.fromModel(model: pItem));
                },
              );

              print(snapshot.error);
              print(snapshot.data);
            },
          ),
        ),
      ),
    );
  }
}
