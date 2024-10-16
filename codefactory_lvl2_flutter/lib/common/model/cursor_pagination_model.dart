import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

// 아래와 같이 API에서 넘어오는 데이터는
// Restaurant Model만 담고있는게 아니라
// meta도 담고 있음. meta와 data 중
// data가 Restaurant Model에 해당함
// {
// "meta": {
// "count": 20,
// "hasMore": true
// },

// "data": [
// {
// "id": "1952a209-7c26-4f50-bc65-086f6e64dbbd",
// "products": [
// {
// "product": {
// "id": "1952a209-7c26-4f50-bc65-086f6e64dbbd",
// "restaurant": {
// "id": "1952a209-7c26-4f50-bc65-086f6e64dbbd",
// "name": "우라나라에서 가장 맛있는 짜장면집",
// "thumbUrl": "/img/thumb.png",
// "tags": [
// "신규",
// "세일중"
// ],
// "priceRange": "cheap",
// "ratings": 4.89,
// "ratingsCount": 200,
// "deliveryTime": 20,
// "deliveryFee": 3000
// },
// "name": "마라맛 코팩 떡볶이",
// "imgUrl": "/img/img.png",
// "detail": "서울에서 두번째로 맛있는 떡볶이집! 리뷰 이벤트 진행중~",
// "price": 8000
// },
// "count": 10
// }
// ],
// "restaurant": {
// "id": "1952a209-7c26-4f50-bc65-086f6e64dbbd",
// "name": "우라나라에서 가장 맛있는 짜장면집",
// "thumbUrl": "/img/thumb.png",
// "tags": [
// "신규",
// "세일중"
// ],
// "priceRange": "cheap",
// "ratings": 4.89,
// "ratingsCount": 200,
// "deliveryTime": 20,
// "deliveryFee": 3000
// },
// "totalPrice": 10000,
// "createdAt": "string"
// }
// ]
// }

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> {
  final CursorPaginationMeta meta;

  // 구조는 똑같은데 여기에 들어갈 Model이 다르다면
  // <T>로 class 받음 /OOP강의 보기
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

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

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}
