import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/model/area_model.dart';
import 'package:salesmen_app_new/model/bank_account_model.dart';
import 'package:salesmen_app_new/model/box_model.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
import 'package:salesmen_app_new/model/city_model.dart';
import 'package:salesmen_app_new/model/complain_issue.dart';
import 'package:salesmen_app_new/model/delivery_model.dart';
import 'package:salesmen_app_new/model/partycategories.dart';
const String Server="http://api.visionsoft-pk.com:8181/ords/skr2/";
const String directory=Server+"app/";
class OnlineDatabase{
  static const String _something='Something went wrong';
  static int _secs=20;
  static const String _timeoutString="Response Timed Out";
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
   static Future<dynamic> getLedger({String customerCode,String ledgerType,String fromDate,String toDate}) async {
    var url=Uri.parse(directory+'gettransactions?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_datatype=$ledgerType&pin_fromdate=$fromDate&pin_todate=$toDate');
    print('get ledger url is: '+url.toString());
    var response= await http.get(url);
    print(response.statusCode.toString());
    return response;
  }
  static Future<dynamic> getStockLedger({ String ledgerType,String fromDate,String toDate}){
    var url=Uri.parse(directory+'getstocks?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_datatype=$ledgerType&pin_fromdate=$fromDate&pin_todate=$toDate');
    // var url=Uri.parse(directory+'getstocks?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=+923163301494&pin_password=555&pin_datatype=$ledgerType&pin_fromdate=$fromDate&pin_todate=$toDate');
    print('getStockLedger url is'+url.toString());
    var response=http.get(url);
    return response;
  }
  static Future<dynamic> getWalletLedger({ String ledgerType,String fromDate,String toDate}){
    var url=Uri.parse(directory+'getwalletstatus?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_datatype=$ledgerType&pin_fromdate=$fromDate&pin_todate=$toDate');
    // var url=Uri.parse(directory+'getwalletstatus?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=+923119806626&pin_password=555&pin_datatype=$ledgerType&pin_fromdate=$fromDate&pin_todate=$toDate');
    print('getWalletLedger url is'+url.toString());
    var response=http.get(url);
    return response;
  }
  static Future<List<City>> getAllCities({Function task}) async{
    List<City> cities;
    var url = Uri.parse(directory+'getcities?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_city_code=');
    print("get city url: "+url.toString());
    await  http.get(
        url).then((response) {
      print(response.statusCode.toString());
      if(response.statusCode==200){
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        //print("data is: "+data.toString());
        var datalist=data['results'];
        if(datalist!=null) {
          cities = [];
          for(var item in data['results']){
            City city=City(cityCode:(item["CITY_CODE"].toString()),cityName:item["CITY"],cityNickName:item["NICK_NAME"],cityDialCode:item["DIAL_CODE"],cityCountryName:item["COUNTRY"]);
            cities.add(city);
          }
        }
        else if(response.statusCode==204||response.statusCode==404){
          Fluttertoast.showToast(msg: "City  not found", toastLength: Toast.LENGTH_LONG);
        }
        else {
          String msg = data["message"].toString().replaceAll("{", "").replaceAll(
              "}", "")
              .replaceAll(",", "\n");
          Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
        }
      }})
        .catchError((ex,stack){
      print("exception iss"+ex.toString()+stack.toString());
      Fluttertoast.showToast(
          msg:ex.toString(), toastLength: Toast.LENGTH_SHORT);
    }).timeout(Duration(seconds: _secs),onTimeout:(){
      Fluttertoast.showToast(
          msg: _timeoutString, toastLength: Toast.LENGTH_SHORT);
    });
    return cities;
  }
  static Future<List<Area>> getAreaByCity(cityID) async{
    List<Area> areas;
    var url =Uri.parse(directory+'getcityareas?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_city_code=$cityID');
    print("get city url: "+url.toString());
    await  http.get(url).then((response) {

      if(response.statusCode==200){
        var data=jsonDecode(utf8.decode(response.bodyBytes));
        //print("data is"+data.toString());
        var datalist=data['results'];
        //print("data is"+datalist.toString());
        if(datalist!=null) {
          areas = [];
          for(var item in data['results']){
            Area area = Area(
                areaCode:(item["AREA_CODE"].toString()),areaName:item["AREA_NAME"],areacityCode:(item["CITY_CODE"].toString()),areacityName:item["CITY"],areacityNickName:item["NICK_NAME"],areacityDialCode:item["DIAL_CODE"],areacityCountryName:item["COUNTRY"]);
            areas.add(area);
            // print("area is" + areas.toString());
          }}
      }
      else if(response.statusCode==204 ||response.statusCode==404){
        Fluttertoast.showToast(msg: "Area  not found", toastLength: Toast.LENGTH_LONG);
      }
      else {
        Fluttertoast.showToast(msg: _something, toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((ex,stack){
      print("exception iss"+ex.toString()+stack.toString());
      Fluttertoast.showToast(
          msg:ex.toString(), toastLength: Toast.LENGTH_SHORT);
    }).timeout(Duration(seconds: _secs),onTimeout:(){
      Fluttertoast.showToast(
          msg: _timeoutString, toastLength: Toast.LENGTH_SHORT);
    });
    return areas;
  }
  static Future<List<PartyCategories>> getPartyCategories() async{
    List<PartyCategories> partyCategories;
    var url =Uri.parse(directory+'getpartycategories?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cat_code=');
    print("get getPartyCategories url: "+url.toString());
    await  http.get(url).then((response) {
      if(response.statusCode==200){
        var data=jsonDecode(utf8.decode(response.bodyBytes));
        print("data is: "+data.toString());
        var datalist=data['results'];
        if(datalist!=null) {
          partyCategories = [];
          for(var item in data['results']){
            PartyCategories partyCategorie = PartyCategories(
              partyCategoriesCode:(item["CAT_CODE"].toString()),partyCategoriesName:item["CATEGORY"],);
            partyCategories.add(partyCategorie);
          }}
      }
      else if(response.statusCode==204||response.statusCode==404){
        Fluttertoast.showToast(msg: "Party Categories  not found", toastLength: Toast.LENGTH_LONG);

      }
      else {
        Fluttertoast.showToast(msg: _something, toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((ex,stack){
      print("exception iss"+ex.toString()+stack.toString());
      Fluttertoast.showToast(
          msg:ex.toString(), toastLength: Toast.LENGTH_SHORT);
    }).timeout(Duration(seconds: _secs),onTimeout:(){
      Fluttertoast.showToast(
          msg: _timeoutString, toastLength: Toast.LENGTH_SHORT);
    });
    return partyCategories;
  }
  static Future<dynamic> getPartyTrialLedger({ String ledgerType,String fromDate,String toDate}){
    // var url=Uri.parse(directory+ 'gettransactions?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=+923163301494&pin_password=555&pin_cust_code=&pin_datatype=$ledgerType&pin_fromdate=$fromDate&pin_todate=$toDate');
    var url=Uri.parse(directory+ 'gettransactions?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=&pin_datatype=$ledgerType&pin_fromdate=$fromDate&pin_todate=$toDate');
    print('getPartyTrialLedger url is'+url.toString());
    var response=http.get(url);
    return response;
  }
  static Future<List<MainIssue>> getMainIssue({Function task}) async{
    List<MainIssue> mainissue;
    var url = Uri.parse(directory+ 'getmainissue?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_maintype=');
    // print("get city url: "+url.toString());
    await  http.get(url).then((response) {
      var data=jsonDecode(utf8.decode(response.bodyBytes));
      if(response.statusCode==200){
        //  print("data is"+data.toString());
        var datalist=data['results'];
        //   print("data is"+datalist.toString());
        if(datalist!=null) {
          mainissue = [];
          for(var item in data['results']){
            mainissue.add(MainIssue.fromJson(item));
          }
        }
        else if(response.statusCode==204||response.statusCode==404){
          Fluttertoast.showToast(msg: "mainissue  not found", toastLength: Toast.LENGTH_LONG);
        }
        else {
          String msg = data["message"].toString().replaceAll("{", "").replaceAll(
              "}", "")
              .replaceAll(",", "\n");
          Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
        }
      }}).catchError((ex,stack){
      print("exception iss"+ex.toString()+stack.toString());
      Fluttertoast.showToast(
          msg:ex.toString(), toastLength: Toast.LENGTH_SHORT);
    }).timeout(Duration(seconds: _secs),onTimeout:(){
      Fluttertoast.showToast(
          msg: _timeoutString, toastLength: Toast.LENGTH_SHORT);
    });
    return mainissue;
  }
  static Future<List<SubIssue>> getSubIssueByMainIssue(mainissueId) async{
    List<SubIssue> subissue;
    var url =Uri.parse(directory+ 'getsubissue?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_maintype=$mainissueId');
    print("get subissue url: "+url.toString());
    await  http.get(url).then((response) {

      if(response.statusCode==200){
        var data=jsonDecode(utf8.decode(response.bodyBytes));
        print("data is"+data.toString());
        var datalist=data['results'];
        print("data is"+datalist.toString());
        if(datalist!=null) {
          subissue = [];
          for(var item in data['results']){
            subissue.add(SubIssue.fromJson(item));
            // print("area is" + areas.toString());
          }}
      }
      else if(response.statusCode==204 ||response.statusCode==404){
        Fluttertoast.showToast(msg: "subissue  not found", toastLength: Toast.LENGTH_LONG);
      }
      else {
        Fluttertoast.showToast(msg: _something, toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((ex,stack){
      print("exception iss"+ex.toString()+stack.toString());
      Fluttertoast.showToast(
          msg:ex.toString(), toastLength: Toast.LENGTH_SHORT);
    }).timeout(Duration(seconds: _secs),onTimeout:(){
      Fluttertoast.showToast(
          msg: _timeoutString, toastLength: Toast.LENGTH_SHORT);
    });
    return subissue;
  }
  static Future<dynamic> postComplaint({String customercode,String complainDetails,String reasonID,String issueID}){
    var url=Uri.parse(directory+'postcustcomplain?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_maintype=$reasonID&pin_subtype=$issueID&pin_details=$complainDetails&pin_cust_code=$customercode');
    print("post complain url is"+url.toString());
    try{
      var response=http.post(url,body: null);
      return response;
    }
    catch(e){
      print("exception in post complain is"+e.toString());
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
    // var url =Uri.parse(directory+'postempvisitlog?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_loc_code=&pin_longitude='+'$long'+'&pin_latitude='+'$lat'+'&pin_purpose=$purpose&pin_photo');
    //  print('post employee url is'+url.toString());
    // final response = await http.get(url);
    Map<String,dynamic> data={
      "employee_id":emp_id,
      "customer_id":customerCode,
      "phone":phoneNumber,
      "password":password,
      "lat":lat,
      "long":long,
    };
    var dio = Dio();
    String url='http://erp.suqexpress.com/api/checkin';
    print(data);
    FormData formData = new FormData.fromMap(data);
    var response=await dio.post(url,data: formData);
    return response;
  }
  // Arsalan post box
  static Future<dynamic> newpostBoxDeliverDetails({BoxModel boxDetails, int code_id,String customerCode,String amount,String emp_name,String lat, String long,emp_id}) async {
    Map<String,dynamic> data={
      "employee_id":emp_id,
      "emp_name":emp_name,
      "customer_id":customerCode,
      "phone":phoneNumber,
      "password":password,
      "lat":lat,
      "long":long,
      "box_no":boxDetails.trNumber,
      "amount":amount,
      "code_id":code_id,
    };
    var dio = Dio();
    print(data);
    String url="https://erp.suqexpress.com/api/deliverybox";
    FormData formData = new FormData.fromMap(data);
    var response=await dio.post(url,data: formData);
    // final response = await http.post(
    //   url,
    // );

    return response;
  }

  static Future<dynamic> editShop({String customerCode,String imageUrl, String lat,String long,String address,String customerName,String customerName2,String customerPhoneNo,String CustomerPhoneNo2, String shopname,String partyCategory,String city,String area ,}){
    String url=directory+'posteditshop?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_shopname=${shopname}&pin_address=$address&pin_partycategory=$partyCategory&'
        'pin_image_url=${imageUrl}&pin_city=${city??''}&pin_mobile=${customerPhoneNo}&pin_phone1=${customerPhoneNo}&pin_phone2=$CustomerPhoneNo2&pin_ntn=1'
        '&pin_person1=$customerName&pin_person2=$customerName2&pin_longitude=$long&pin_latitude=$lat&po_cust_code&pin_area=${area??''}';
    print("edit customer url is: "+url);
    print("edit area url is: "+area);
    try{
      var response=http.post(Uri.parse(url),body: null);
      return response;
    }
    catch(e){
      print("exception in edit shop api is"+e.toString());
    }
  }

  static Future<dynamic> getTranactionDetails({String customerCode}) async {
    var url =Uri.parse(directory+ 'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_datatype=CRLB');
    print('getTranactionDetails url is: '+url.toString());
    final response = await http.get(url);
    return response;
  }
  static Future<dynamic> getDeliveryDetails({String customercode,String dataType,String orderId,bool showFullDetails}) async{
    var url=Uri.parse(
        showFullDetails? directory+ 'gettransactions?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customercode&pin_datatype=$dataType&pin_order_no=$orderId'
            : directory+ 'gettransactions?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customercode&pin_datatype=$dataType');
    print("get PSO delivery details url is "+url.toString());

    final response=await http.get(url);
    return response;
  }
  static Future<dynamic> getBoxDeliveries({String customercode,String dataType}) async{
    var url=Uri.parse(directory+ 'getorders?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customercode&pin_datatype=$dataType');
    print("get delivery details url is: "+url.toString());
    final response=await http.get(url);
    return response;
  }

  static Future<dynamic> postDeliverDetails({List<DeliveryModel> deliverydata, String customerCode, String lat, String long,String orderNumber}) async {
    // var url =Uri.parse(directory+ 'postdelivery?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_longitude=$long&pin_latitude=$lat&pin_order_no=$orderNumber&file_type=json&file_name=');
    var url =Uri.parse(directory+ 'postdelivery?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_longitude=$long&pin_latitude=$lat&pin_order_no=$orderNumber&file_type=json&file_name=');
    print("post delivery order url is: "+url.toString());

    Map<String,dynamic> postData={
      "Orderitems": []
    };
    for(int i=0;i<deliverydata.length;i++){
      postData['Orderitems']+=[ {"Prod_code":deliverydata[i].productCode,
        "OrderLine": deliverydata[i].orderLine,
        "Qty": deliverydata[i].quantity,
        "Rate": deliverydata[i].rate,
        "Amount": deliverydata[i].quantity*deliverydata[i].rate,
      },
      ];
    }
    print("post data is: "+jsonEncode(postData));
    final response = await http.post(
      url,
      body: jsonEncode(postData),
    );
    return response;
  }
  static Future<dynamic> uploadImage({String type, var image}) async {
    Dio dio = new Dio();

    var url = 'https://suqexpress.com/api/uploadimage';
    print("Url is: "+url.toString());
    try{
      FormData postData= new FormData.fromMap({"type": type,});
      postData.files.add(MapEntry("image", image));

      var response = await dio.post(url, data: postData, options:
      Options(contentType: 'multipart/form-data; boundary=1000')
      );
      if(response.statusCode == 200)
        return true;
      else
        return false;

    }catch(e){
      e.toString();
      return false;
    }
  }
  static Future<dynamic> postBoxDeliverDetails({BoxModel boxDetails, String customerCode, String lat, String long}) async {
    var url =Uri.parse(directory+ 'postboxdelivery?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_longitude=$long&pin_latitude=$lat&pin_box_tr=${boxDetails.trNumber}');
    print("post box delivery url is: "+url.toString());

    final response = await http.post(
      url,
    );
    return response;
  }
  static Future<dynamic> getWalletStatus() async {
    var url=Uri.parse(directory+'getwalletstatus?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password');
    print("url is: "+url.toString());
    final response=await http.get(url);
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
        'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_datatype=INFO&pin_cust_code=$custCode';
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
  static Future<dynamic> getOrderDetails(String startDate,String endDate,String empNo)async{
    Uri url=Uri.parse("http://124.29.202.191:8181/ords/skr2/app/gettransactions?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_datatype=PSO&pin_order_no=&pin_fromdate=$startDate&pin_todate=$endDate&pin_app_for=&pin_cmp_id=&pin_cust_code=&pin_emp_userid=$empNo");
    var response =await http.get(url);
    print(url);
    print(response.statusCode.toString());
    return response;
  }
  static Future<List<BankAccountModel>> getbankAccount() async{
    List<BankAccountModel> bankaccounts;
    var url=Uri.parse(directory+'getbankaccounts?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_bacc_no=');
    print(url.toString());
    await http.get(url).then((response){
      print(response.statusCode.toString());
      var data=jsonDecode(utf8.decode(response.bodyBytes));
      if(response.statusCode==200){
        var dataList=data['results'];
        if(dataList!=null){
          bankaccounts=[];
          for(var item in dataList){
            bankaccounts.add(BankAccountModel.fromJson(item));
          }
        }
      }
      else{
        Fluttertoast.showToast(msg: "Some thing went wrong", toastLength: Toast.LENGTH_SHORT);
      }
    } ).catchError((ex,stack){
      Fluttertoast.showToast(msg: "Some thing went wrong", toastLength: Toast.LENGTH_SHORT);
      print('exception in get bank account is'+ex.toString());
    });
    return bankaccounts;
  }
  static Future<dynamic> postCashDeposite({String lat,String long,String accountNumber,String amount, String imageUrl}){
    var url=Uri.parse(directory+'postcashdeposit?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_longitud=$long&pin_latitude=$long&pin_acc_no=$accountNumber&pin_amount=$amount&pin_image_url=$imageUrl');
    var response=http.post(url,body: null);
    return response;
  }
  static Future<dynamic> getHistory(){
    var url=Uri.parse(directory+'getempvisitlog?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=&pin_loguserid=$phoneNumber&pin_longitude=&pin_latitude=&pin_from_date=&pin_to_date=');
    print('history url is'+url.toString());
    var response=http.get(url);
    return response;
  }
  static Future<dynamic> signIn2(String phoneno,String password) async {
    var url=Uri.parse(directory+'getlogin?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneno&pin_password=$password&pin_version=230622');
    print("login url is: "+url.toString());
    final response = await http.get(url);
    print(response.statusCode.toString());
    print("login data is: "+response.body.toString());
    return response;
  }
}