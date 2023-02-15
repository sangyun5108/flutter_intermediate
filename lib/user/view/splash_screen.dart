import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/user/view/login_screen.dart';
import '../../common/const/colors.dart';
import '../../common/const/data.dart';
import '../../common/layout/default_layout.dart';
import '../../common/view/root_tab.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async { // 토큰 확인

    // secure_storage
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    String rawString = 'test@codefactory.ai:testtest'; // :은 까먹으면 안된다.

    // base64 인코딩
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String token = stringToBase64.encode(rawString);

    final dio = Dio();

    try {
      final res = await dio.post(
        'http://$ip/auth/token',
        options: Options(
            headers:{
              'authorization': 'Bearer $refreshToken'
            }
        ),
      );

      final newRefreshToken = res.data['refreshToken'];
      final newAccessToken = res.data['accessToken'];

      // token 갱신
      await storage.write(key: REFRESH_TOKEN_KEY, value: newRefreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: newAccessToken);

      // refresh 토큰이 만료되지 않은 경우
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const RootTap()), // RootTap으로 이동
              (route) => false,);

    } catch(error){ // refresh 토큰이 만료된경우 에러 발생
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()), // login Screen으로 이동
              (route) => false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(
              height: 16.0,
            ),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
