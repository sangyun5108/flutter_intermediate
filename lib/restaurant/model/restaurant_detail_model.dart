import 'package:flutter_intermediate/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/const/data.dart';
import '../../common/utills/data_utils.dart';

part 'restaurant_detail_model.g.dart';

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.ratingsCount,
    required this.detail,
    required this.products,
  });



  factory RestaurantDetailModel.fromJson(Map<String,dynamic>json)
  => _$RestaurantDetailModelFromJson(json);
}

@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(
      fromJson: DataUtils.pathToUrl
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });
  
  factory RestaurantProductModel.fromJson(Map<String,dynamic>json)
  => _$RestaurantProductModelFromJson(json);
}
