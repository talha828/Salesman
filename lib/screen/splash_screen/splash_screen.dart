import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:salesmen_app_new/api/Auth/auth.dart';
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/child_lock/security_screen.dart';
import 'package:salesmen_app_new/screen/splash_screen/get_started_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _serviceEnabled=false;
  // getVersion() async {
  //   Location location = new Location();
  //   _serviceEnabled = await location.serviceEnabled();
  //   Uri url = Uri.parse("https://erp.suqexpress.com/api/appversion/1");
  //   var response = await http.get(url);
  //   var data = jsonDecode(response.body);
  //   if (data['data'] == "0") {
  //     openLocationFirst();
  //   } else {
  //     AwesomeDialog(
  //         context: context,
  //         dialogType: DialogType.INFO_REVERSED,
  //         animType: AnimType.BOTTOMSLIDE,
  //         title: "Up-date your app",
  //         desc:
  //         "New version is available on play store. Please update your app",
  //         btnOkText: "Update Now",
  //         btnCancelText: "Ok",
  //         dismissOnBackKeyPress: false,
  //         dismissOnTouchOutside: false,
  //         btnOkOnPress: () async {
  //           getVersion();
  //         }).show();
  //   }
  // }
  getLogin()async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    phoneNumber = pref.getString("phoneno");
    password = pref.getString("password");
    if (phoneNumber != null && password != null) {
      var response = await Auth.getLogin(phoneNo: phoneNumber,
          password: password,
          onSuccess: (response) async {
            if (response.statusCode == 200) {
              var data = jsonDecode(utf8.decode(response.bodyBytes));
              await Provider.of<UserModel>(context, listen: false).userSignIn(data);
              Uri url = Uri.parse(
                  "http://api.visionsoft-pk.com:8181/ords/skr2/app/getappvrs?pin_cmp=20&pin_kp=A&pin_keyword1=6731&pin_keyword2=U09Z&pin_userid=$phoneNumber&pin_password=$password&pin_appname=SALESMAN");
              var versionResponse = await http.get(url);
              var versionDecode = jsonDecode(utf8.decode(versionResponse.bodyBytes));
              var version = versionDecode['results'][0]['VERSION'];
              print(version);
              if (version.toString() == "101122"){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => SecurityScreen()));
              } else {
                Future.delayed(Duration(seconds: 1),(){
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "New Version is available",
                    desc: "Please update your app first",
                    style: AlertStyle(
                        descStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                    buttons: [
                      DialogButton(
                        color: Colors.red,
                        child: Text(
                          "Update Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {},
                        width: 120,
                      )
                    ],
                  ).show();
                });
              }
              // FirebaseAuth _auth = FirebaseAuth.instance;
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => SecurityScreen()));
            } // Navigator.push(context, MaterialPageRoute(builder: (context)=>VerificationCodeScreen(verificationCode: "123",phoneNo: widget.phoneNumber,password: _passController.text,)))
            else if (response.statusCode == 401) {
              Alert(
                context: context,
                type: AlertType.error,
                title: "Authentication Failed",
                desc: "please check your phone number and password",
                buttons: [
                  DialogButton(
                    color: themeColor1,
                    child: Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    width: 120,
                  )
                ],
              ).show();
            }
            else {
              var data = jsonDecode(utf8.decode(response.bodyBytes));
              Alert(
                context: context,
                type: AlertType.error,
                title: "Somethings wants wrongs",
                desc: data["results"][0]["A"].toString(),
                buttons: [
                  DialogButton(
                    color: themeColor1,
                    child: Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    width: 120,
                  )
                ],
              ).show();
            }
          },
          onError: (e) {
            Alert(
              context: context,
              type: AlertType.error,
              title: "Something want wrong",
              desc: "Error:" + e.toString(),
              buttons: [
                DialogButton(
                  color: themeColor1,
                  child: Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                )
              ],
            ).show();
            print("Login Error: $e");
          });
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>GetStartedScreen()));
    }
  }
  openLocationFirst()async{
    Location location = new Location();
    bool  _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled){
      Alert(
        context: context,
        type: AlertType.info,
        title: "Please Enable your Location",
        desc: "Your Location is not available",
        style: AlertStyle(
            descStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.normal)
        ),
        buttons: [
          DialogButton(
            color: themeColor1,
            child: Text(
              "Enable Now",
              style: TextStyle(color: Colors.white, fontSize:15,fontWeight: FontWeight.bold),
            ),
            onPressed: ()async{
              _serviceEnabled = await location.requestService();
              var _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  getLogin();
                }
              }
              else if(_permissionGranted == PermissionStatus.granted){
                getLogin();
              }
            },
            width: 120,
          )
        ],
      ).show();
    }
    else{
      getLogin();
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
  Future<void> launchAppStore(String appStoreLink) async {
    debugPrint(appStoreLink);
    if (await canLaunch(appStoreLink)) {
      await launch(appStoreLink);
    } else {
      throw 'Could not launch appStoreLink';
    }
  }
}