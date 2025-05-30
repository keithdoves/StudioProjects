import 'package:codefactory_lvl2_flutter/common/model/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/const/data.dart';
import '../../common/utils/data_utils.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  cheap,
  medium,
}

@JsonSerializable()
class RestaurantModel implements IModelWithId{
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

   factory RestaurantModel.fromJson(Map<String, dynamic> json)
   => _$RestaurantModelFromJson(json);

   Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

   static pathToUrl(String value){
     return 'http://$ip$value';
   }

  // factory RestaurantModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantModel(
  //       id: json['id'],
  //       name: json['name'],
  //       thumbUrl: 'http://$ip${json['thumbUrl']}',
  //       tags: List.from(json['tags']),
  //       priceRange: RestaurantPriceRange.values
  //           .firstWhere((e) => e.name == json['priceRange']),
  //       ratings: json['ratings'],
  //       ratingsCount: json['ratingsCount'],
  //       deliveryTime: json['deliveryTime'],
  //       deliveryFee: json['deliveryFee']);
  // }
}
