import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

// 클래스의 상태를 구분하려면 BASE CLASS가 필요하다
// 이 추상 class를 만들어 밑에서 extends 하는 이유는
// CursorPaginationBase과 호환이 된다는 것을 판단
// 아래 클래스들은 CursorPaginationBase의 타입들이다.
abstract class CursorPaginationBase {}

// 에러났을 때, 상태
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

// 로딩중 일 때, 상태
class CursorPaginationLoading extends CursorPaginationBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;

  // 구조는 똑같은데 여기에 들어갈 Model이 다르다면
  // <T>로 class 받음 /OOP강의 보기
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  //fromJsonT에는 T의 fromJson이 들어감
  factory CursorPagination.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

//새로고침 할 때(위로 당길때)
//이미 데이터가 있다는 것을 전제로 하기 때문에 CursorPagination을 extends함
//instance is CursorPagination >>true
//instance is CursorPaginationBase >>true
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

// 리스트의 맨 아래로 내려서
// 추가 데이터를 요청하는 중 일 때
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
