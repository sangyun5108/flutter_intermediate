import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/restaurant/component/restaurant_card.dart';
import 'package:flutter_intermediate/restaurant/model/restaurant_model.dart';
import 'package:flutter_intermediate/restaurant/view/restaurant_detail_screen.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  final String title;

  const RestaurantScreen({Key? key, required this.title}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY); // 유효기간 5분

    final res = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {'authorization': 'Bearer $accessToken'},
      ),
    );

    return res.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List>(
                future: paginateRestaurant(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (!snapshot.hasData) {
                    // 데이터가 없는 경우 Container()를 보여준다
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.separated(
                      itemBuilder: (_, index) {
                        final item = snapshot.data![index];
                        // parsed
                        final pItem = RestaurantModel.fromJson(item);

                        return GestureDetector(onTap:(){
                         Navigator.of(context).push(MaterialPageRoute(builder: (_)=> RestaurantDetailScreen(title: pItem.name,id: pItem.id,)));
                        },child: RestaurantCard.fromModel(model: pItem,));
                      },
                      separatorBuilder: (_, index) {
                        return const SizedBox(
                          height: 16.0,
                        );
                      },
                      itemCount: snapshot.data!.length);
                },
              ))),
    );
  }
}
