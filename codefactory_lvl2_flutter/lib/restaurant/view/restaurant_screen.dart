import 'dart:convert';

import 'package:codefactory_lvl2_flutter/restaurant/component/restaurant_card.dart';
import 'package:codefactory_lvl2_flutter/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateResturant() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );

    return resp.data['data']; //data키 안의 값만 갖고 옴
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: FutureBuilder(
            future: paginateResturant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (_, index) {
                  return SizedBox(height: 16.0);
                },
                itemBuilder: (_, index) {
                  final item = snapshot.data![index];
                  final pItem = RestaurantModel.fromJson(json: item);

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

                  return RestaurantCard.fromModel(model: pItem);

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
