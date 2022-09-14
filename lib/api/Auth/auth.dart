
import 'package:http/http.dart'as http;
import 'package:salesmen_app_new/api/Auth/online_database.dart';

class Auth{
  static Future<dynamic> getLogin({ String phoneNo, String password, onSuccess,onError})async{
    var url=Uri.parse(directory+'getlogin?pin_cmp=20&pin_kp=A&pin_keyword1=6731&pin_keyword2=U09Z&pin_userid=$phoneNo&pin_password=$password&pin_version=030922');
    print("login url is: "+url.toString());
    final response = await http.get(url).then(onSuccess,onError: onError);
    print(response);
    //print(response.statusCode.toString());
    //print("login data is: "+response.body.toString());
    return response;
  }
}