import 'package:flutter/cupertino.dart';
class UserModel extends ChangeNotifier{
  String userID;
  String userName;
  String email;
  String phoneNumber;
  String userDesignation;
  String userEmpolyeeNumber;
  String usercashReceive;
  String usercashLimit;
  UserModel();
  userSignIn(Map<String,dynamic> json){
    print(json.toString());
    try{
      userID=json['results'][0]["USERID"].toString();
      userName =json['results'][0]["USERNAME"];
      email  =json['results'][0]["EMAIL"];
      phoneNumber =json['results'][0]["CELL"];
      userDesignation =json['results'][0]["DESIG"];
      userEmpolyeeNumber =json['results'][0]["EMPNO"];
      notifyListeners();
    }
    catch(e){
      print('user model exception is'+e.toString());
    }
     // Map<String, dynamic>map={
     //  // customer attribute
     //   "code":"01658",
     //   "category":"Customer.OFFICE/TESTING",
     //   "Shop_name":"Hadi Autos",
     //   "addres":"plot xyz,street xyz,sector xyz, bla bla",
     //   "owner_name":"Ahsan Iqbal",
     //   "person2_name":"Ahsan Iqbal",
     //   "person3_name":"Ahsan Iqbal",
     //   "owner_phone":"+923012070920",
     //   "phone2":"+923012070920",
     //   "phone3":"+923012070920",
     //   "last_visit":"Never" ,// 1hr ,2 day ago ,today,
     //   "dues":"4010",
     //   "last_trans":"Never", // 1hr ,2 day ago ,today,
     //   "outstanding":"500",
     //   "image":"http://sgjgkjgjhgjgl.jpg",
     //   "info":[
     //     //"rahat sahab batai gay"
     //     "key":"kdas",
     //     "value":"as",
     //
     //     "key":"kdas",
     //     "value":"as",
     //   ]
     // },
    // Map<String, dynamic>map={
    //   "user_name":"talha iqbal",
    //   "phone_no":"+923012070920",
    //   "EMPNO":"00042",
    //   "userDesignation":"App_wala_bhai",
    //   "usercashReceive":"40000",
    //   "usercashLimit":"40000",
    // };
  }

  getWalletStatus(Map<String,dynamic> json){
    try{
      usercashReceive=json['results'][0]['CASH_RECEIVED'].toString();
      usercashLimit=json['results'][0]['CASH_LIMIT'].toString();
    }
    catch(e){
      print('exception in get wallet status is'+e.toString());
    }
  }
}