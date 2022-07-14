import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:salesmen_app_new/api/Auth/auth.dart';
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/loginScreen/login_screen.dart';
import 'package:salesmen_app_new/screen/loginScreen/verify_phoneno_screen.dart';
import 'package:salesmen_app_new/screen/mainScreen/mainScreen.dart';
import 'package:salesmen_app_new/screen/splash_screen/get_started_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  getLogin()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    phoneNumber = pref.getString("phoneno");
    password=pref.getString("password");
    if (phoneNumber != null && password != null) {
      var response=await Auth.getLogin(phoneNo:phoneNumber, password:password,onSuccess: (response)async{
        //print("status ${response.statusCode}");
        if(response.statusCode==200){
          var data=jsonDecode(response.toString());
          print(data['success']);
          await  Provider.of<UserModel>(context,listen: false).fetchData(data);
          FirebaseAuth _auth=  FirebaseAuth.instance;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));

          // Navigator.push(context, MaterialPageRoute(builder: (context)=>VerificationCodeScreen(verificationCode: "123",phoneNo: widget.phoneNumber,password: _passController.text,)));
        }
        else if(response.statusCode==401){
          Alert(
            context: context,
            type: AlertType.error,
            title: "Authentication Failed",
            desc: "please check your phone number and password",
            buttons: [
              DialogButton(
                color:themeColor1 ,
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.white  ,fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
        else{
          Alert(
            context: context,
            type: AlertType.error,
            title: "Somethings wants wrongs",
            desc: "please try again after few Mints",
            buttons: [
              DialogButton(
                color:themeColor1 ,
                child: Text(
                  "CANCEL",
                  style: TextStyle(color:Colors.white , fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
      },onError: (e){
        Alert(
          context: context,
          type: AlertType.error,
          title: "Something want wrong",
          desc: "Error:"+ e.toString(),
          buttons: [
            DialogButton(
              color:themeColor1 ,
              child: Text(
                "CANCEL",
                style: TextStyle(color: Colors.white ,fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
        print("Login Error: $e");});
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>GetStartedScreen()));
    }
  }
  @override
  void initState() {
    getLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Center(child: Image.asset("assets/images/splashIcon.png", scale: 2)),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("SKR Service 2021. All Right Reserved.",style: TextStyle(color: Colors.red,fontSize: 14),)
              )
            ],
          ),
        ));
  }
}