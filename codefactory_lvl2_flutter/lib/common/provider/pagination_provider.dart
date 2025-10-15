import 'dart:async';

import 'package:codefactory_lvl2_flutter/common/model/model_with_id.dart';
import 'package:codefactory_lvl2_flutter/common/repository/base_pagination_repository.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/cursor_pagination_model.dart';
import '../model/pagination_params.dart';

class _PaginationInfo {
  final int fetchCount;
  final bool fetchMore;
  final bool forceRefetch;

  const _PaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

/// [구 코드 주석] IBasePaginationRepository를 Implement하면 U 타입이 될 수 있음
/// [구 코드 주석] Pagination할 모델의 타입(T)과 Repository 타입(U)을 제네릭에 넣어주면
/// [구 코드 주석] 이 PaginationProvider는 자동으로 페이지네이션 로직을 구현한다.
abstract class CursorPaginationController<T extends IModelWithId> {
  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  });
}

abstract class CursorPaginationNotifier<T extends IModelWithId,
        R extends IBasePaginationRepository<T>>
    extends AutoDisposeNotifier<CursorPaginationBase>
    implements CursorPaginationController<T> {
  late final R repository;
  late final Throttle<_PaginationInfo> _paginationThrottle;
  StreamSubscription<_PaginationInfo>? _throttleSubscription;

  CursorPaginationBase initialize(R repository) {
    this.repository = repository;
    _paginationThrottle = Throttle<_PaginationInfo>(
      const Duration(seconds: 3),
      initialValue: const _PaginationInfo(),
      checkEquality: false,
    );

    _throttleSubscription =
        _paginationThrottle.values.listen(_throttledPagination);

    ref.onDispose(() async {
      await _throttleSubscription?.cancel();
    });

    // Future.microtask는 마이크로태스크 큐에 작업을 등록해 build 이후에 paginate가 실행되도록 도와준다.
    Future.microtask(() => paginate());

    return CursorPaginationLoading();
  }

  @override
  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    _paginationThrottle.setValue(
      _PaginationInfo(
        fetchMore: fetchMore,
        fetchCount: fetchCount,
        forceRefetch: forceRefetch,
      ),
    );
  }

  Future<void> _throttledPagination(_PaginationInfo info) async {
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;

    try {
      // [구 코드 주석] 5가지 가능성
      // [구 코드 주석] state의 상태
      // [구 코드 주석] [상태가]
      // [구 코드 주석] 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // [구 코드 주석] 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // [구 코드 주석] 3) CursorPaginationError - 에러가 있는 상태
      // [구 코드 주석] 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올 때
      // [구 코드 주석] 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을 때

      // [구 코드 주석] 데이터 갖고 올 필요 없는 로직 시작-------------------------------------------------------------
      // [구 코드 주석] Z1 바로 반환하는 상황(바로 함수가 종료되는 상황)
      // [구 코드 주석] 1) 더 이상 데이터가 없을 경우
      // [구 코드 주석] hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      // [구 코드 주석] 2) 이미 로딩중이라서 중복된 네트워크 요청을 방지하기 위해서
      // [구 코드 주석] 로딩중    - fetchMore(맨아래로스크롤후데이터를가져와야하는상황) = true
      // [구 코드 주석]         !- fetchMore = false - 새로고침 의도가 있을 수 있어 반환하지 않는다.

      // [구 코드 주석] 데이터를 성공적으로 가져온 적이 있었다면 state의 타입은
      // [구 코드 주석] CursorPagination이거나 CursorPagination을 extends한 타입이다.
      // [구 코드 주석] Z1-1
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;
      // [구 코드 주석] Z1-2
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }
      // [구 코드 주석] 데이터 갖고 오는 로직 시작-------------------------------------------------------------
      // [구 코드 주석] PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // [구 코드 주석] fetchMore = true
      // [구 코드 주석] 데이터를 추가로 더 가져오는 상황(20개 있을 때 다음 데이터 더 갖고 올 때)
      if (fetchMore) {
        final pState = state as CursorPagination<T>;
        // [구 코드 주석] 데이터를 유지한 채, state 타입만 바꿈
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        // [구 코드 주석] 일반화를 위해 IModelWithID를 만듬
        // [구 코드 주석] extends IModelWithId 한 T이기 때문에 id가 무조건 존재함.
        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        // [구 코드 주석] 만약에 데이터가 있는 상황이라면
        // [구 코드 주석] 기존 데이터를 보존한채로 Fetch (API 요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
            // [구 코드 주석] 기존 데이터를 보여준 채 로딩함
            meta: pState.meta,
            data: pState.data,
          );
          // [구 코드 주석] 나머지 상황(데이터 유지가 필요 없는 상황)
          // [구 코드 주석] forceRefetch가 true인 상황으로 아에 로딩원만 보여주면 되는 상황.
        } else {
          state = CursorPaginationLoading();
        }
      }
      // [구 코드 주석] 요청보내기
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        // [구 코드 주석] 기존 데이터에
        // [구 코드 주석] 새로운 데이터 추가/ resp 는 CursorPagination 타입으로
        // [구 코드 주석] 자동 캐스팅 됨
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
        // [구 코드 주석] state가 CursorPaginationRefetchingMore가 아니면
        // [구 코드 주석] state가 CursorPaginationLoading나 CursorPaginationRefetching이면
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
    // [구 코드 주석] resp.data 대신에 resp를 쓰면 받을 수 있음.
    // [구 코드 주석] paginate() 정의로 가면
    // [구 코드 주석] Future<CursorPagination<RestaurantModel>>를
    // [구 코드 주석] 리턴하는 함수로 정의되어 있기 때문
    // [구 코드 주석] state = resp;
  }
}
