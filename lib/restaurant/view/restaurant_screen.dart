import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/restaurant/component/restaurant_card.dart';

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
                    return Container();
                  }

                  print(snapshot.data);

                  return ListView.separated(
                      itemBuilder: (_, index) {

                        final item = snapshot.data![index];

                        return RestaurantCard(
                          image: Image.network(
                            'http://$ip${item['thumbUrl']}',
                            fit: BoxFit.cover,
                          ),
                          name: item['name'],
                          tags: List<String>.from(item['tags']),
                          ratingsCount: item['ratingsCount'],
                          deliveryTime: item['deliveryTime'],
                          deliveryFee: item['deliveryFee'],
                          ratings: item['ratings'],
                        );
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
