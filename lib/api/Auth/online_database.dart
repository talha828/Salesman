import 'package:dio/dio.dart';
import 'package:http/http.dart'as http;
const String Server="http://api.visionsoft-pk.com:8181/ords/skr2/";
const String directory=Server+"app/";
class OnlineDatabase{
  static Future<dynamic> getAllproductsubcategory({String maintypeId,String subTypeId}) async {
    //var url=Uri.parse(getproductsubcategoryListUrl+'?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=+923002233297&pin_password=654321&pin_cust_code=&pin_itcd=&pin_main_type=$maintypeId&pin_sub_type=$subTypeId');
    var url=Uri.parse("http://api.visionsoft-pk.com:8181/ords/skr2/app/getprodprice?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=+923340243440&pin_password=8888&pin_cust_code=&pin_itcd=&pin_main_type=001&pin_sub_type=006&pin_app_for=");
    print("getAllproductsubcategory url is "+url.toString());
    final response = await http.get(url);
    return response;
  }
  Future<dynamic>getCustomer()async{
    http.Response response=await http.get(Uri.parse("https://erp.suqexpress.com/api/customer"));
    print(response.body);
    return response;
  }
}