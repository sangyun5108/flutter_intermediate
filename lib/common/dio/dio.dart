import 'package:dio/dio.dart';
import 'package:flutter_intermediate/common/const/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {

  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: implement onRequest

    // 요청이 보내질때마다, 요청의 헤더에 accessToken true라는 값이 있다면
    // 실제 토큰을 가져오서 (storage에서) authorization : Bearer accessToken 을 넣어준다.

    // 토큰 자동 적용 코드
    if(options.headers['accessToken'] == 'true'){

      // 헤더 삭제
      options.headers.remove('accessToken');

      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization' : 'Bearer $accessToken',
      });
    }

    if(options.headers['refreshToken'] == 'true'){

      options.headers.remove('refreshToken');

      final refresthToken = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization' : 'Bearer $refresthToken'
      });

    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // TODO: implement onError

    // accessToken이 만료가 된경우
    // 401 에러가 났을때 (status code)
    // 토큰을 재발급하는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을 한다.

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken이 아예 존재하지 않는 경우
    if(refreshToken == null) {
      // 에러를 던질때는 handler.reject를 사용한다.
      return handler.reject(err); // 에러 돌려주기
    }


    final isStatus401 = err.response?.statusCode == 401;

    final isPathRefresh = err.requestOptions.path == '/auth/token';

    return handler.resolve(response);

    return super.onError(err, handler);
  }
}