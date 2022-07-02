import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier{
    String success;
    String message;
    String id;
    String firstName;
    String lastName;
    String email;
    String phone;
    String image;
    String isActive;
    String dateOfBirth;
    String createdAt;
    String updateAt;
    String token;

   fetchData(Map<String, dynamic> json){
    success=json['success'].toString();
    message=json['message'].toString();
    token =json['data']['token'].toString();
    id =json['data']['user']['id'].toString();
    firstName =json['data']['user']['first_name'].toString();
    lastName =json['data']['user']['last_name'].toString();
    email =json['data']['user']['email'].toString();
    phone =json['data']['user']['phone'].toString();
    image =json['data']['user']['image'].toString();
    isActive =json['data']['user']['is_active'].toString();
    dateOfBirth =json['data']['user']['date_of_birth'].toString();
    createdAt =json['data']['user']['created_at'].toString();
    updateAt =json['data']['user']['updated_at'].toString();
   }

}
