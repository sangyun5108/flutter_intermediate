import 'package:flutter/material.dart';
import 'package:flutter_intermediate/common/const/colors.dart';

import '../../restaurant/model/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String detail;
  final String name;
  final int price;

  const ProductCard(
      {Key? key,
      required this.image,
      required this.detail,
      required this.name,
      required this.price})
      : super(key: key);

  factory ProductCard.fromModel({required RestaurantProductModel model}) {
    return ProductCard(
        image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ),
        detail: model.detail,
        name: model.name,
        price: model.price);
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      // 내부의 모든 위젯이 최대 크기만큼 차지한다.
      child: Row(
        // Row 내부에서 각각 위젯의 높이는 정해져있다.
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: image,
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch, // 너비를 최대한으로 쭉~!
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0),
                ),
                Text(
                  '₩$price',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
