import 'package:codefactory_lvl2_flutter/common/dio/dio.dart';
import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/secure_storage/secure_storage.dart';
import 'package:codefactory_lvl2_flutter/common/utils/pagination_utils.dart';
import 'package:codefactory_lvl2_flutter/restaurant/component/restaurant_card.dart';
import 'package:codefactory_lvl2_flutter/restaurant/model/restaurant_model.dart';
import 'package:codefactory_lvl2_flutter/restaurant/provider/restaurant_provider.dart';
import 'package:codefactory_lvl2_flutter/restaurant/repository/restaurant_repository.dart';
import 'package:codefactory_lvl2_flutter/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(
        restaurantProvider.notifier,
      ),
    );

    // 현재 위치가
    // 최대 길이보다 조금 덜되는 위치까지 왔다면
    // 새로운 데이터를 추가 요청
    // if(controller.offset > controller.position.maxScrollExtent - 300){
    //   ref.read(restaurantProvider.notifier).paginate(
    //     fetchMore: true,
    //   );
    // }
  }

  /* Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
    final dio = ref.watch(dioProvider);
    // final dio = Dio();
    // dio.interceptors.add(
    //   CustomInterceptor(storage: storage),
    // );

    // CursorPagination 객체가 리턴되고
    // 그 안에 RestaurantModel이 data란 프로퍼티에
    // 들어 있음
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
  } 이 함수도 riverpod에 의해 대체됨*/
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    //타입 비교 할 때 is 사용
    // 완전 처음 로딩일 때
    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    //에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination 아래 두개는 자식들임.
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    //data를 CursorPagination 타입으로 캐스팅
    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: ListView.separated(
        controller: controller, //ListView 속성을 갖고 올 수 있음
        itemCount: cp.data.length + 1, //한 개의 추가 위젯을 그리겠다는 의미
        separatorBuilder: (_, index) {
          return SizedBox(height: 16.0);
        },
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: data is CursorPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text('마지막 데이터입니다아....'),
              ),
            );
          }
          final pItem = cp.data[index];
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
      ),
    );
  }
}
