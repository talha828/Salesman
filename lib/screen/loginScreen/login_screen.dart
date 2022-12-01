import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:salesmen_app_new/api/Auth/auth.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/screen/ForgetPasswordScreen/verify_phone_no_screen.dart';
import 'package:salesmen_app_new/screen/loginScreen/verificationcodescreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../others/common.dart';
import '../../others/style.dart';


class LoginScreen extends StatefulWidget {
  var phoneNumber;
  LoginScreen({this.phoneNumber});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _passController=new TextEditingController();
  bool show_password = true;
  bool checkbox = true;
  bool isLoading = false;

  Future<bool> _onWillPop() async {
    // This dialog will exit your app on saying yes
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () =>
                exit(0),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }


  getLogin(context)async{
    setLoading(true);
    var response=await Auth.getLogin(phoneNo:widget.phoneNumber, password:_passController.text,onSuccess: (response)async{
      //print("status ${response.statusCode}");
      if(response.statusCode==200){
        var data = jsonDecode(utf8.decode(response.bodyBytes));
       // var data=jsonDecode(response.toString());
         // print(data['success']);
         await  Provider.of<UserModel>(context,listen: false).userSignIn(data);
        Uri url = Uri.parse(
            "http://api.visionsoft-pk.com:8181/ords/skr2/app/getappvrs?pin_cmp=20&pin_kp=A&pin_keyword1=6731&pin_keyword2=U09Z&pin_userid=${widget.phoneNumber}&pin_password=${_passController.text}&pin_appname=SALESMAN");
        var versionResponse = await http.get(url);
        var versionDecode = jsonDecode(utf8.decode(versionResponse.bodyBytes));
        var version = versionDecode['results'][0]['VERSION'];
        print(version);
        if (version.toString() == "011222") {
          FirebaseAuth _auth=  FirebaseAuth.instance;
          _auth.verifyPhoneNumber(
              phoneNumber: widget.phoneNumber,
              timeout: Duration(seconds: 120),
              verificationCompleted: (AuthCredential credential){
              },
              verificationFailed: (FirebaseAuthException exception){
                print("OTP failed");
                setLoading(false);
                Fluttertoast.showToast(
                    msg: "OTP failed, Try again later",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: 16.0);
                print(exception);
              },
              codeAutoRetrievalTimeout:(authException){
                Alert(
                  context: context,
                  type: AlertType.error,
                  title: "Authentication Failed",
                  desc: "Please check your number ",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      width: 120,
                    )
                  ],
                ).show();
                print(authException);
                setLoading(false);
              } ,
              codeSent: ( verificationId, [forceResendingToken]) async {
                setLoading(false);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>VerificationCodeScreen(verificationCode: verificationId,phoneNo: widget.phoneNumber,password: _passController.text,)));
              }
          );
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
                  onPressed: () {

                  },
                  width: 120,
                )
              ],
            ).show();
          });
        }

              // Navigator.push(context, MaterialPageRoute(builder: (context)=>VerificationCodeScreen(verificationCode: "123",phoneNo: widget.phoneNumber,password: _passController.text,)));

      }
      else if(response.statusCode==401){
        setLoading(false);
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
        setLoading(false);
      }
    },onError: (e){
      setLoading(false);
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
      print("Login Error: $e");}).catchError((e){
      Alert(
        context: context,
        type: AlertType.error,
        title: "Something want wrong",
        desc: e.response.data["results"][0],
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    });
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    var width = media.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenpadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: height*0.07,),
                  Center(
                      child: Image.asset(
                        "assets/images/splashlogo.png",
                        scale: 3.5,
                      )),
                  SizedBox(
                    height: height * 0.05,
                  ),

                  VariableText(
                    text: "Login Account",
                    fontsize: 22,
                    textAlign: TextAlign.start,
                    line_spacing: 1,
                    fontcolor: textcolorblack,
                    fontFamily: fontMedium,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  VariableText(
                    text: "Enter your password for login.",
                    fontsize: 14,
                    textAlign: TextAlign.start,
                    line_spacing: 1,
                    fontcolor: textcolorgrey,
                    fontFamily: fontRegular,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Container(
                    height: height * 0.05,
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      obscuringCharacter: '*',
                      style: TextStyle(
                        fontSize: 15,
                        color: textcolorblack,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        } else {
                          return null;
                        }
                      },
                      obscureText: show_password ? true : false,
                      controller: _passController,
                      // onChanged: enableBtn,
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                          child: Image.asset(
                            'assets/icons/lock.png',
                            scale: 3,
                          ),
                        ),
                        suffixIcon: InkWell(
                            onTap: () {
                              if (show_password == true) {
                                setState(() {
                                  show_password = false;
                                });
                              } else if (show_password == false) {
                                setState(() {
                                  show_password = true;
                                });
                              }
                            },
                            child: Container(
                              transform: Matrix4.translationValues(10.0, 0.0, -10.0),

                              child: Image.asset(
                                'assets/icons/eye.png',
                                scale: 3,
                              ),
                            )),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: feildunderlineColor),
                        ),
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hintText: 'Enter Password',
                        hintStyle:
                        TextStyle(fontSize: 15,       color: textcolorlightgrey,),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (checkbox == true) {
                            setState(() {
                              checkbox = false;
                            });
                          } else if (checkbox == false) {
                            setState(() {
                              checkbox = true;
                            });
                          }
                        },
                        child: Container(
                          height: height * 0.025,
                          width: height * 0.025,
                          decoration: BoxDecoration(
                              color: checkbox == true ? themeColor1 : Colors.white,
                              border: Border.all(
                                  color: checkbox == true
                                      ? themeColor1
                                      : Color(0xFFB7B7B7)),
                              borderRadius: BorderRadius.circular(3)),
                          child: Center(
                              child:
                              Icon(Icons.check, size: 15, color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: height*0.025,),
                      VariableText(
                        text: "Keep me logged in",
                        fontsize: 13,
                        fontcolor: textcolorlightgrey2,
                        fontFamily: fontRegular,
                      ),
                      Spacer(),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context)=> ForgetPasswordVerifyPhoneNoScreen()));
                          },
                        child: VariableText(
                          text: "Forget password ?",
                          fontsize: 13,
                          fontcolor: themeColor1,
                          fontFamily: fontMedium,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            floatingActionButton: new FloatingActionButton(
                elevation: 1.0,
                child: Image.asset(
                  'assets/icons/arrow_forward.png',
                  scale: 1.8,
                ),
                backgroundColor: themeColor1,
                onPressed: () =>getLogin(context),
                )),isLoading ?Positioned.fill(child: ProcessLoading()) : Container(),
      ],
    );
  }


  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
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

