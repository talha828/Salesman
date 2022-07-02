import 'package:dio/dio.dart';

class Auth{
  static Future<dynamic> getLogin({ String phoneNo, String password, onSuccess,onError})async{
    var dio = Dio();
    String url='https://erp.codeboxsolutions.com/public/api/login';
    FormData formData = new FormData.fromMap({
      'phone': phoneNo,
      'password': password,
    });
    var response = await dio.post(url, data: formData,
      options: Options(
        contentType: "application/json",
      ),
    ).then(onSuccess,onError: onError);
    return response.status;
  }
}