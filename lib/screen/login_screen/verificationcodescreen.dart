
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/screen/login_screen/sucessfully_verified_screen.dart';
import '../../others/common.dart';
import '../../others/style.dart';



class VerificationCodeScreen extends StatefulWidget {
  var verificationCode;
  var phoneNo;
  var password;
  VerificationCodeScreen({this.verificationCode,this.phoneNo,this.password});

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  TextEditingController textEditingController1 = new TextEditingController();
  bool hasError = false;
  String currentText = "";
  late String otpCode;
  bool isLoading=false;
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    textEditingController1.dispose();
    super.dispose();
  }
  String _commingSms = 'Unknown';


  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;
    var width=media.width;
   var data= Provider.of<UserModel>(context).token;
   print(data);
    return Stack(
      children: [
        Scaffold(
          body:   Padding(
            padding:  EdgeInsets.symmetric(horizontal: screenpadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: height*0.07,),
                Center(child: Image.asset("assets/images/splashlogo.png",scale: 3.5,)),
                SizedBox(height: height*0.05,),
                VariableText(text: "Enter the 6-digit code sent to you at",
                  fontsize: 16,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  fontcolor: textcolorblack,
                  fontFamily: fontRegular,),
                SizedBox(height: height*0.01,),
                VariableText(text: widget.phoneNo,
                  fontsize: 16,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  fontcolor: textcolorblack,
                  fontFamily: fontMedium,),
                SizedBox(height: height*0.03,),

                PinCodeTextField(
                  appContext: context,
                  mainAxisAlignment: MainAxisAlignment.start,
                  pastedTextStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: fontRegular,
                      fontWeight: FontWeight.w500),
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      fieldHeight: 50,
                      fieldWidth: 35,
                      fieldOuterPadding: EdgeInsets.only(right: 8,top: 0),
                      borderWidth: 1,
                      errorBorderColor: Color(0xff7A7A7A),
                      disabledColor: Color(0xff7A7A7A),
                      inactiveFillColor: Colors.transparent,
                      inactiveColor: Color(0xff7A7A7A),
                      selectedColor:Color(0xff7A7A7A),
                      selectedFillColor:Colors.transparent,
                      activeFillColor:Colors.transparent,
                      activeColor: Color(0xff7A7A7A)
                  ),
                  cursorColor:Color(0xff7A7A7A),
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: textEditingController1,
                  keyboardType: TextInputType.number,
                  onCompleted: (value) {
                    setState(() {
                      otpCode = value;
                    });
                    // var _credential = PhoneAuthProvider.credential(verificationId: widget.verificationCode, smsCode: otpCode.toString());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SucessFullyVerifiedScreen()));
                    print("Completed");

                    // verifyOtp();
                  },
                  onChanged: (value) {
                    setState(() {
                      print('$value');
                    });
                  },
                ),


                /*OTPTextField(
                    length: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 35,
                    style: TextStyle(
                        fontSize: 16,
                      fontFamily: fontRegular,
                      fontWeight: FontWeight.w500
                    ),
                    keyboardType:TextInputType.number ,
                    textFieldAlignment: MainAxisAlignment.start,
                    otpFieldStyle: OtpFieldStyle(
                      enabledBorderColor: Color(0xff7A7A7A),
                      focusBorderColor: Color(0xff7A7A7A),
                    ),
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) {
                      setState(() {
                        otpCode=pin.toString();
                      });
                   *//*   Navigator.push(
                          context, NoAnimationRoute(widget: SucessFullyVerifiedScreen()));
*//*
                      verifyOtp();
                      print("Completed: " + pin);
                    },
                  ),*/

                SizedBox(height: height*0.03,),
                VariableText(text: "Resend code in 00:59",
                  fontsize: 13,
                  fontcolor: textcolorlightgrey2,
                  fontFamily: fontRegular,),
              ],
            ),
          ),
/*        floatingActionButton: new FloatingActionButton(
                elevation: 1.0,
                child:   Image.asset('assets/icons/arrow_forward.png',scale: 1.8,),
                backgroundColor: themeColor1,
                onPressed: (){
                  //verifyOtp();
                }
                  )*/
        ),
        isLoading ? Positioned.fill(child: CircularProgressIndicator()) : Container(),
      ],
    );
  }
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  // void verifyOtp() async{
  //   setLoading(true);
  //   FirebaseAuth _auth=FirebaseAuth.instance;
  //   try{
  //     AuthCredential credential=PhoneAuthProvider.credential(verificationId: widget.verificationCode.toString(), smsCode: otpCode);
  //     UserCredential result=await _auth.signInWithCredential(credential);
  //     User? user=result.user;
  //     if(user!=null){
  //       setLoading(false);
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setString('phoneno', widget.phoneNo.toString());
  //       prefs.setString('password',widget.password.toString());
  //       phoneNumber = prefs.getString('phoneno')!;
  //       password = prefs.getString('password')!;
  //       Fluttertoast.showToast(
  //           msg: "Successfully Logged in",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context)=>SucessFullyVerifiedScreen()));
  //     }
  //     else{
  //       setLoading(false);
  //       Fluttertoast.showToast(
  //           msg: "Invalid OTP , Try again later",
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity:  ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 3,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //
  //     }
  //
  //   }
  //   catch(e){
  //     setLoading(false);
  //     Fluttertoast.showToast(
  //         msg: "Invalid OTP , Try again later",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 3,
  //         backgroundColor: Colors.black87,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     print("exceptxc;ion is"+e.toString());
  //   }
  // }
}
