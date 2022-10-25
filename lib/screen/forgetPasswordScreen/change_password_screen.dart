
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/ForgetPasswordScreen/sucessfully_forget_password_screen.dart';


class ChangePasswordScreen extends StatefulWidget {
  var phoneNo;
  ChangePasswordScreen({this.phoneNo});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController newPassword=new TextEditingController();
  TextEditingController confirmNewPassword=new TextEditingController();
  bool show_password = true;
  bool show_newpassword = true;
  bool checkbox = true;
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    print("phone number is"+widget.phoneNo.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    var width = media.width;
    return Stack(
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
                    text: "Reset Password",
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
                    text: "Enter your new password",
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
                      scrollPadding:
                          EdgeInsets.only(top: 0, bottom: 0, left: 0),

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
                      controller: newPassword,
                      //onChanged: enableBtn,
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
                  Container(
                    height: height * 0.05,
                    child: TextFormField(
                      scrollPadding:
                      EdgeInsets.only(top: 0, bottom: 0, left: 0),

                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      obscuringCharacter: '*',
                      style: TextStyle(
                        fontSize: 15,
                        color: textcolorblack,
                      ),
                      obscureText: show_newpassword ? true : false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        } else {
                          return null;
                        }
                      },
                      controller: confirmNewPassword,
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
                              if (show_newpassword == true) {
                                setState(() {
                                  show_newpassword = false;
                                });
                              } else if (show_newpassword == false) {
                                setState(() {
                                  show_newpassword = true;
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
                        hintText: 'Enter Confirm Password',
                        hintStyle:
                        TextStyle(fontSize: 15,       color: textcolorlightgrey,),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Center(
                    child: LoginButton(
                      width: width*0.45,
                      text: "Reset Password",
                      onTap: ()  {
                          if(validateFields()) {
                            // forgetPassword();
                          }
                   },
                    ),
                  )

                ],
              ),
            ),
),isLoading ? Positioned.fill(child: CircularProgressIndicator()) : Container(),
      ],
    );
  }

  bool ValidatePassword(String newPassword,String confirmNewPassword){
    if(newPassword==confirmNewPassword){
      return true;
    }
    else{
      return false;
    }

  }
  bool validateFields(){
    bool ok=false;
    bool validatepassword=ValidatePassword(newPassword.text,confirmNewPassword.text);
    if(newPassword.text.isNotEmpty) {
      if(confirmNewPassword.text.isNotEmpty){
      if(validatepassword==true){

        ok = true;
    }
      else{
        Fluttertoast.showToast(msg: "Password and Confirm Password Doesn't Match", toastLength: Toast.LENGTH_SHORT);
      }}
      else{
        Fluttertoast.showToast(msg: "Please Enter Confirm Password", toastLength: Toast.LENGTH_SHORT);
      }

    }
    else{
      Fluttertoast.showToast(msg: "Please Enter Password", toastLength: Toast.LENGTH_SHORT);
    }
    return ok;
  }
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  // void forgetPassword() async{
  //   try {
  //     setLoading(true);
  //    var response =await  OnlineAuth.forgetPassword(widget.phoneNo.toString(),newPassword.text);
  //     if (response.statusCode == 201) {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       print("Response is" + data.toString());
  //         var str =data['results'][0].toString();
  //       const start = ";";
  //       const end = "}";
  //       final startIndex = str.indexOf(start);
  //       final endIndex = str.indexOf(end, startIndex + start.length);
  //       final resultToast=str.substring(startIndex + start.length, endIndex);
  //       resultToast.toString()=='Invalid Userid or Password'?failed():Sucess();
  //
  //     }
  //     else {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       setLoading(false);
  //       Fluttertoast.showToast(
  //         // msg: "${data.toString()}",
  //           msg: "Internet issue",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //
  //     }
  //   } catch (e, stack) {
  //     print('exception is'+e.toString());
  //     setLoading(false);
  //     Fluttertoast.showToast(
  //         msg: "Something went wrong try again letter",
  //         toastLength: Toast.LENGTH_SHORT,
  //         backgroundColor: Colors.black87,
  //         textColor: Colors.white,
  //         gravity: ToastGravity.BOTTOM,
  //         fontSize: 16.0);
  //   }
  // }
  failed(){
   setLoading(false);
    Fluttertoast.showToast(
        msg: "Invalid Userid or Password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);



  }

  Sucess(){
    setLoading(false);
    Fluttertoast.showToast(
        msg: "Password changed successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.push(
        context, MaterialPageRoute(builder: (context)=>SucessFullyVerifiedForgetPasswordScreen()));

  }


}
