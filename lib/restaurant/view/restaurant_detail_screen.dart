import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_intermediate/common/const/data.dart';
import 'package:flutter_intermediate/common/dio/dio.dart';
import 'package:flutter_intermediate/common/layout/default_layout.dart';
import 'package:flutter_intermediate/product/component/product_card.dart';
import 'package:flutter_intermediate/restaurant/component/restaurant_card.dart';
import 'package:flutter_intermediate/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_intermediate/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RestaurantDetailScreen extends StatelessWidget {

  final String title;
  final String id;

  const RestaurantDetailScreen({Key? key, required this.title, required this.id}) : super(key: key);

  Future<RestaurantDetailModel> getRestaurantDetail() async{
    final dio = Dio();
    const storage = FlutterSecureStorage();

    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    final repository = RestaurantRepository(dio,baseUrl: 'http://$ip/restaurant');

    return repository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context) {

    return DefaultLayout(
      title: title,
      backgroundColor: null,
      child: FutureBuilder<RestaurantDetailModel>(
        future: getRestaurantDetail(),
        builder: (_,AsyncSnapshot<RestaurantDetailModel> snapshot){

          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }

          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomScrollView(
            slivers: [
              renderTop(model:snapshot.data!),
              renderLabel(),
              renderProducts(products: snapshot.data!.products)
            ],
          );
        },
      )
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantDetailModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(model: model,isDetail: true,),
    );
  }

  SliverPadding renderLabel(){
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text('메뉴',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500),),
      ),
    );
  }

  SliverPadding renderProducts({required List<RestaurantProductModel> products}){
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index){
              return Padding(padding: const EdgeInsets.only(top: 16.0),child: ProductCard.fromModel(model: products[index],));
            },
          childCount: products.length
        ),
      ),
    );
  }
}
