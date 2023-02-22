import 'package:json_annotation/json_annotation.dart';

import '../../common/utills/data_utils.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int deliveryTime;
  final int deliveryFee;
  final int ratingsCount;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratingsCount,
  });

  factory RestaurantModel.fromJson(Map<String,dynamic> json)
  => _$RestaurantModelFromJson(json);

  Map<String,dynamic> toJson() => _$RestaurantModelToJson(this);
}
