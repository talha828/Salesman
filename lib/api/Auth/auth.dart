import 'package:dio/dio.dart';

class Auth{
  static Future<dynamic> getLogin({ String phoneNo, String password, onSuccess,onError})async{
    var dio = Dio();
    String url='https://erp.suqexpress.com/public/api/login';
    FormData formData = new FormData.fromMap({
      'phone': phoneNo,
      'password': password,
      'user_type':1,
    });
    var response = await dio.post(url, data: formData,
      options: Options(
        contentType: "application/json",
      ),
    ).then(onSuccess,onError: onError);
    return response;
  }
}