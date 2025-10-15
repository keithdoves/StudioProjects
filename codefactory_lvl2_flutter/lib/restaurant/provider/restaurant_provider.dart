import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/provider/pagination_provider.dart';
import 'package:codefactory_lvl2_flutter/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory_lvl2_flutter/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../model/restaurant_model.dart';

//Provider에 id값을 넣어, 가져오고 싶은 것의 상세정보를 갖고 온다.
//(id 값을 넣어 restaurantProvider의 값을 필터링 해 갖고 온다)
final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }
  return state.data.firstWhereOrNull((element) => element.id == id);
});
//---------------------------------------------------------------------------
final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

//CursorPaginationBase를 상태로 관리하면
//CursorPaginationBase를 extends 한 클래스가 모두 올 수 있음
class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  // final RestaurantRepository repository;

  RestaurantStateNotifier({
    required super.repository,
  });

  //: super(CursorPaginationLoading()) {
  //이 RestaurantStateNotifier가 인스턴스화 될 때
  //바로 데이터를 넣어주기 위해
  //바로 paginate를 실행시켜 줌
  //이를 통해 화면에서는 따로 함수를 실행할 필요 없음
  //paginate();
  //}

  void getDetail({
    required String id,
  }) async {
    //이미 id에 대한 DetailProvider가 DetailModel이면 데이터 안 갖고옴
    if(restaurantDetailProvider(id) is RestaurantDetailModel){
      return;
    }

    //만약에 아직 데이터가 하나도 없는 상태라면(CursorPagination이 아니라면)
    //데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await paginate();
    }

    // state가 CursorPagination이 아닐 때 그냥 리턴(500)
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;
    final resp = await repository.getRestaurantDetail(id: id);

    //[RestaurantModel(1), RestaurantModel(2), RestaurantModel(3)]
    //요청 id: 10
    //list.where((e)=> e.id == 10)) 데이터 X
    //데이터가 없을 때는 그냥 캐시의 끝에다가 데이터를 추가해버린다.
    //[RestaurantModel(1), RestaurantModel(2), RestaurantModel(3). RestaurantDetailModel(10)]

    if(pState.data.where((e)=> e.id==id).isEmpty){
      state = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          resp,
        ]
      );

    }else{

      //[RestaurantModel(1), RestaurantModel(2), RestaurantModel(3)]
      //id 가 2인 친구를 Detail 모델을 가져 와라
      // getDetail(id:2);
      //[RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3)]
      //detail 모델은 그냥 모델 데이터 포함하여 데이터를 더 들고 있음
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>(
              (e) => e.id == id ? resp : e,
        )
            .toList(),
      );
    }

  }
}
