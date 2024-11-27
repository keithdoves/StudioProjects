import 'package:codefactory_lvl2_flutter/common/model/model_with_id.dart';
import 'package:codefactory_lvl2_flutter/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/cursor_pagination_model.dart';
import '../model/pagination_params.dart';

//IBasePaginationRepository를 Implement하면 U 타입이 될 수 있음
//Pagination할 모델의 타입(T)과 Repository 타입(U)을 제네릭에 넣어주면
//이 PaginationProvider는 자동으로 페이지네이션 로직을 구현한다.
class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  // 위젯이 상태를 바라보다 이 함수가 실행되면
  // 값이 업데이트 됨.
  Future<void> paginate({
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
      final isFetchingMore = state is CursorPaginationFetchingMore;
      //Z1-2
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
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
        final pState = state as CursorPagination<T>;
        //데이터를 유지한 채, state 타입만 바꿈
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        //일반화를 위해 IModelWithID를 만듬
        //extends IModelWithId 한 T이기 때문에 id가 무조건 존재함.
        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        //만약에 데이터가 있는 상황이라면
        //기존 데이터를 보존한채로 Fetch (API 요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
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
        final pState = state as CursorPaginationFetchingMore<T>;

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
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
    //resp.data 대신에 resp를 쓰면 받을 수 있음.
    //paginate() 정의로 가면
    //Future<CursorPagination<RestaurantModel>>를
    //리턴하는 함수로 정의되어 있기 때문
    // state = resp;
  }
}
