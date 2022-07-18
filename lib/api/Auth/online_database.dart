import 'package:dio/dio.dart';
import 'package:http/http.dart'as http;
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
const String Server="http://api.visionsoft-pk.com:8181/ords/skr2/";
const String directory=Server+"app/";
class OnlineDatabase{
  static Future<dynamic> getAllproductsubcategory({String maintypeId,String subTypeId}) async {
    //var url=Uri.parse(getproductsubcategoryListUrl+'?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=+923002233297&pin_password=654321&pin_cust_code=&pin_itcd=&pin_main_type=$maintypeId&pin_sub_type=$subTypeId');
    var url=Uri.parse(directory +"getprodprice?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=&pin_itcd=&pin_main_type=$maintypeId&pin_sub_type=$subTypeId&pin_app_for=");
    print("getAllproductsubcategory url is "+url.toString());
    final response = await http.get(url);
    return response;
  }
  static Future<dynamic> newpostPayment({String emp_id,String customerCode, String imageUrl, String lat, String long, String paymentMode, String checkNumber, String amount, String name, String date})async{

    String url="http://erp.suqexpress.com/api/collection";
    Map<String,dynamic> cash={
      "employee_id":emp_id,
      "customer_id":customerCode,
      "phone":phoneNumber,
      "password":password,
      "lat":lat,
      "long":long,
      "payment_method":paymentMode,
      "amount":amount,
      "received_from":name,
    };
    Map<String,dynamic> cheque={
      "employee_id":emp_id,
      "customer_id":customerCode,
      "phone":phoneNumber,
      "password":password,
      "lat":lat,
      "long":long,
      "payment_method":paymentMode,
      "amount":amount,
      "received_from":name,
      "cheque_no":checkNumber,
      "cheque_date":date,
      "cheque_image":imageUrl,
      "create_at":0,
    };
    try{
      var dio = Dio();
      print(paymentMode=="1"?cash:cheque);
      String url="http://erp.suqexpress.com/api/collection";
      FormData formData = new FormData.fromMap(paymentMode=="1"?cash:cheque);
      var response=await dio.post(url,data: formData);
      return response;
    }
    catch(e){
      print("exception in post payment api is: "+e.toString());
    }
  }
  static Future<dynamic> postPayment({String customerCode, String imageUrl, String lat, String long, String paymentMode, String checkNumber, String amount, String name, String date}){
    String url=
    paymentMode=='1'?
    directory+'postcollection?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_longitude=$long&pin_latitude=$lat&pin_pay_mode=$paymentMode&pin_cheq_date=&pin_amount=$amount&pin_rcvd_from=$name&file_type&file_name'
        :directory+'postcollection?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_image_url=${imageUrl}&pin_longitude=$long&pin_latitude=$lat&pin_pay_mode=$paymentMode&pin_cheq=$checkNumber&pin_cheq_date=$date&pin_amount=$amount&pin_rcvd_from=$name&file_type&file_name';

    print("post payment method url is: "+url);
    try{
      var response=http.post(Uri.parse(url),body: null);
      return response;
    }
    catch(e){
      print("exception in post payment api is");
    }

  }

  static Future<dynamic> newpostSalesOrder({CartModel cartData, String customerCode, String lat, String long,String paymentMethod,String emp_id,String sub_total, String brand}) async {
    // var url =Uri.parse(directory+ 'postsalesorder?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_longitude=$long&pin_latitude=$lat&file_type=json&file_name=&pin_cash_credit=$paymentMethod');
    // print("post Sales order url is"+url.toString());

    Map<String,dynamic> postData={
      "employee_id":emp_id,
      "customer_id":customerCode,
      "phone":phoneNumber,
      "password":password,
      "lat":lat,
      "long":long,
      "brand_id":brand,
      "sub_total":sub_total,
      "payment_method":paymentMethod,
      "created_by":0,
      "items": []
    };
    for(var item in cartData.cartItemName){
      print("Prod_code is "+item.productName.productCode.toString());
      print("Qty is ${item.itemCount}");
      print("Rate is ${item.itemPrice}");
      print("Amount is ${item.itemCount*item.itemPrice}");
      //Orderitems old json name
      postData['items']+= [
        {"Prod_code":item.productName.productCode.toString(),
          "Qty": item.itemCount,
          "Rate": item.itemPrice,
          "Amount": item.itemCount*item.itemPrice
        },
      ];}
    Map<String,dynamic> temp={
      "Orderitems": []
    };
    List<CartItem> templist = [];

    for(int i=0;i<cartData.cartItemName.length;i++){
      bool isExist=false;
      print("data is"+cartData.cartItemName[i].productName.productCode.toString());
      int totalCount = cartData.cartItemName[i].itemCount;
      for(int j=i+1; i<cartData.cartItemName.length && j < cartData.cartItemName.length; j++){
        if(cartData.cartItemName[i].productName.productCode ==
            cartData.cartItemName[j].productName.productCode){
          totalCount += cartData.cartItemName[j].itemCount;
        }
      }
      print(totalCount.toString());
      for(int k=0; k<templist.length; k++){
        if(templist[k].productName.productCode == cartData.cartItemName[i].productName.productCode){
          isExist=true;
        }
      }
      if(!isExist){
        templist.add(cartData.cartItemName[i]);
        //print("temp list is"+templist[0].productName.name);
        temp['Orderitems']+=[ {"Prod_code":cartData.cartItemName[i].productName.productCode.toString(),
          "Qty": totalCount,
          "Rate": cartData.cartItemName[i].itemPrice,
          "Amount": totalCount*cartData.cartItemName[i].itemPrice
        },
        ];
      }

    }
    print("length is"+cartData.cartItemName.length.toString());
    print("post data is"+temp.toString());
    print(postData);
    var dio = Dio();
    String url='http://erp.suqexpress.com/api/saleorder';

    FormData formData = new FormData.fromMap(postData);
    var response=await dio.post(url,data: formData);
    // final response = await http.post(
    //    url,
    //    body: jsonEncode(temp),
    //  );
    return response;
  }
  static Future<dynamic> sendText(String receiver, String msgData) async {
    String url = 'https://lifetimesms.com/json?api_token=573faa073b82e10a0d9c18b6e5215aa87f2f717165&api_secret=SUQ&to=$receiver&from=8584&message=$msgData';
    // String url = 'https://jsims.com.pk/OnPointSMS.aspx?key=$smsApiKey&sender=SKR&receiver=$receiver&msgdata=$msgData';
    print(url);
    var response = await http.post(Uri.parse(url));
    print(response.statusCode.toString());
    return response;
  }
  static Future<dynamic> postEmployee({String customerCode,String purpose,String lat,String long,String emp_id}) async {
    var url =Uri.parse(directory+'postempvisitlog?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_loc_code=&pin_longitude='+'$long'+'&pin_latitude='+'$lat'+'&pin_purpose=$purpose&pin_photo');
     print('post employee url is'+url.toString());
    final response = await http.get(url);
    // Map<String,dynamic> data={
    //   "employee_id":emp_id,
    //   "customer_id":customerCode,
    //   "phone":phoneNumber,
    //   "password":password,
    //   "lat":lat,
    //   "long":long,
    // };
    // var dio = Dio();
    // String url='http://erp.suqexpress.com/api/checkin';
    // print(data);
    // FormData formData = new FormData.fromMap(data);
    // var response=await dio.post(url,data: formData);
    return response;
  }
  static Future<dynamic> getTranactionDetails({String customerCode}) async {
    var url =Uri.parse(directory+ 'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_datatype=CRLB');
    print('getTranactionDetails url is: '+url.toString());
    final response = await http.get(url);
    return response;
  }
  static Future<dynamic> getAllCategories() async {
    //var url=Uri.parse(getProductListUrl+'?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=+923002233297&pin_password=654321&pin_itemtype=');
    var url=Uri.parse(directory+'getmainitemtypes?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_itemtype=&pin_app_for=');
    print("get product url is: "+url.toString());
    final response = await http.get(url);
    return response;
  }
  static Future<dynamic> getSingleCustomer(String custCode) async {
    String url=directory+
        'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_datatype=&pin_cust_code=$custCode';
    print("url is: "+url);
    final response = await http.get(
        Uri.parse(url));
    return response;
  }
  Future<dynamic>getCustomer()async{
    http.Response response=await http.get(Uri.parse("https://erp.suqexpress.com/api/customer"));
    print(response.body);
    return response;
  }
  static Future<dynamic> getAllCustomer() async {
    String url = directory +
        'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_datatype=INFO';
    print("url is: " + url);
    final response = await http.get(Uri.parse(url));
    return response;
  }
  static Future<dynamic> sendTextMultiple(List<String> receivers, String msgData) async {
    String url = 'https://lifetimesms.com/json?api_token=573faa073b82e10a0d9c18b6e5215aa87f2f717165&api_secret=SUQ';
    url+='&to=$receivers&from=8584&message=$msgData';
    // String url = 'https://jsims.com.pk/OnPointSMS.aspx?key=$smsApiKey&sender=SKR';
    // url += '&receiver=';

    for(int i=0; i < receivers.length; i++){
      if(i != 0){
        url += ','+receivers[i].toString();
      }else{
        url += receivers[i].toString();
      }
    }
    // url += '&msgdata=$msgData';
    //url += '&camp=camp1';
    print(url);
    var response = await http.post(Uri.parse(url));
    print(response.statusCode.toString());
    return response;
  }
}