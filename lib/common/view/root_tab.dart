import 'package:flutter/material.dart';
import 'package:flutter_intermediate/restaurant/view/restaurant_screen.dart';

import '../const/colors.dart';
import '../layout/default_layout.dart';

class RootTap extends StatefulWidget {
  const RootTap({Key? key}) : super(key: key);

  @override
  State<RootTap> createState() => _RootTapState();
}

class _RootTapState extends State<RootTap> with SingleTickerProviderStateMixin{

  late TabController controller;

  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener);
  }

  void tabListener(){
    setState(() {
      index = controller.index;
    });
  }

  @override
  void dispose() {

    controller.removeListener(tabListener); // tabListener 제거

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '오늘의 배달',
      backgroundColor: null,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed, // 선택된 탭이 좀 더 크게 표현된다.
        onTap: (int index) {
          // 클릭한 경우
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined), label: '음식'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: '주문'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: '프로필'),
        ],
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(), // 스크롤 막기
        controller: controller,
        children: const [
          RestaurantScreen(title: '홈',),
          RestaurantScreen(title: '음식',),
          RestaurantScreen(title: '주문',),
          RestaurantScreen(title: '프로필',),
        ],
      ),
    );
  }
}
