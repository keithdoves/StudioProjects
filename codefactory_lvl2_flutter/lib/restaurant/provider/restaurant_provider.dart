import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/model/pagination_params.dart';
import 'package:codefactory_lvl2_flutter/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/restaurant_model.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

//CursorPaginationBase를 상태로 관리하면
//CursorPaginationBase를 extends 한 클래스가 모두 올 수 있음
class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    //이 RestaurantStateNotifier가 인스턴스화 될 때
    //바로 데이터를 넣어주기 위해
    //바로 paginate를 실행시켜 줌
    //이를 통해 화면에서는 따로 함수를 실행할 필요 없음
    paginate();
  }

  // 위젯이 상태를 바라보다 이 함수가 실행되면
  // 값이 업데이트 됨.
  void paginate({
    int fetchCount = 20,
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침(현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try {
      // 5가지 가능성
      // state의 상태
      //[상태가]
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올 때
      // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을 때

// 데이터 갖고 올 필요 없는 로직 시작-------------------------------------------------------------
      // Z1 바로 반환하는 상황(바로 함수가 종료되는 상황)
      // 1) 더 이상 데이터가 없을 경우
      // hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      // 2) 이미 로딩중이라서 중복된 네트워크 요청을 방지하기 위해서
      // 로딩중    - fetchMore(맨아래로스크롤후데이터를가져와야하는상황) = true
      //          !- fetchMore = false - 새로고침 의도가 있을 수 있어 반환하지 않는다.

      //데이터를 성공적으로 가져온 적이 있었다면 state의 타입은
      //CursorPagination이거나 CursorPagination을 extends한 타입이다.
      // Z1-1
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isRefetchingMore = state is CursorPaginationFetchingMore;
      //Z1-2
      if (fetchMore && (isLoading || isRefetching || isRefetchingMore)) {
        return;
      }
//데이터 갖고 오는 로직 시작-------------------------------------------------------------
      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore = true
      // 데이터를 추가로 더 가져오는 상황(20개 있을 때 다음 데이터 더 갖고 올 때)
      if (fetchMore) {
        final pState = state as CursorPagination;
        //데이터를 유지한 채, state 타입만 바꿈
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        //데이터를 처음부터 가져오는 상황(첫20개부터)
        //만약에 데이터가 있는 상황이라면
        //기존 데이터를 보존한채로 Fetch (API 요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;
          state = CursorPaginationRefetching(
            //기존 데이터를 보여준 채 로딩함
            meta: pState.meta,
            data: pState.data,
          );
          //나머지 상황(데이터 유지가 필요 없는 상황)
          //forceRefetch가 true인 상황으로 아에 로딩원만 보여주면 되는 상황.
        } else {
          state = CursorPaginationLoading();
        }
      }
      //요청보내기
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        // 기존 데이터에
        // 새로운 데이터 추가/ resp 는 CursorPagination 타입으로
        // 자동 캐스팅 됨
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
        //state가 CursorPaginationRefetchingMore가 아니면
        //state가 CursorPaginationLoading나 CursorPaginationRefetching이면
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
    //resp.data 대신에 resp를 쓰면 받을 수 있음.
    //paginate() 정의로 가면
    //Future<CursorPagination<RestaurantModel>>를
    //리턴하는 함수로 정의되어 있기 때문
    // state = resp;
  }
}
