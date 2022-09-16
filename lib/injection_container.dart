import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl..registerLazySingleton(() => Dio()
  ..interceptors.add(Logging()));
}



class Logging extends Interceptor {

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = await sharedPreferences.getString('token')??'';
    options.headers['X-Authorization'] = 'Bearer $accessToken';
    options.headers['accept'] = '*/*';
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response}] => PATH:s ${response.requestOptions.path}',
    );

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print(
      'ERROR[${err.response}] => PATH: ${err.requestOptions.path}',
    );

    // if(err.response!.statusCode==401){
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //   String? refreshToken = await sharedPreferences.getString('refreshToken');
    //   await sharedPreferences.setString('token',refreshToken!);
    // }
    return super.onError(err, handler);
  }
}
