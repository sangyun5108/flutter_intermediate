import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/common/const/colors.dart';
import 'package:flutter_intermediate/common/const/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/layout/default_layout.dart';
import '../../common/view/root_tab.dart';
import '../../component/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String username = ''; // 입력한 email을 받기위한 string
  String password = ''; // 입력한 password를 받기위한 string

  @override
  Widget build(BuildContext context) {

    final dio = Dio();
    // 애뮬레이터는 localhost ip가 다르다.
    const emulatorIp = '10.0.2.2:3000';
    const simulatorIp = '127.0.0.1:3000';

    final String ip = Platform.isIOS ? simulatorIp : emulatorIp;

    String refreshToken = '';

    return DefaultLayout(
      backgroundColor: null,
      child: SingleChildScrollView(
        keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag, // 드래그 했을때, 키보드 내리기
        child: SafeArea(
          top: true, // SafeArea 위쪽에만 적용
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(
                  height: 16.0,
                ),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요',
                  onChanged: (String value) {
                    username = value;
                  },
                  autofocus: true,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  // 로그인 버튼
                  onPressed: () async {
                    // ID, 비밀번호
                    String rawString = '$username:$password'; // :은 까먹으면 안된다.

                    // base64 인코딩
                    Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    String token = stringToBase64.encode(rawString);

                    final res = await dio.post(
                      'http://$ip/auth/login',
                      options: Options(
                        headers: {
                          'authorization': 'Basic $token',
                        },
                      ),
                    );

                    final refreshToken = res.data['refreshToken'];
                    final accessToken = res.data['accessToken'];

                    // storage에 token 저장
                    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RootTap()));
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
                  child: const Text(
                    '로그인',
                  ),
                ),
                TextButton(
                  // 회원가입 글자 버튼
                  onPressed: () async {
                    final res = await dio.post(
                      'http://$ip/auth/token',
                      options: Options(
                        headers: {
                          'authorization': 'Bearer $refreshToken',
                        },
                      ),
                    );

                    print('새로 발급 받은 accessToken : ${res.data}');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('회원가입'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  // _Title 분리
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "환영합니다!",
      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500),
    );
  }
}

class _SubTitle extends StatelessWidget {
  // _SubTitle 분리
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요! \n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
