import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/login_screen/verify_phoneno_screen.dart';


class SucessFullyVerifiedForgetPasswordScreen extends StatefulWidget {
  @override
  _SucessFullyVerifiedForgetPasswordScreenState createState() => _SucessFullyVerifiedForgetPasswordScreenState();
}

class _SucessFullyVerifiedForgetPasswordScreenState extends State<SucessFullyVerifiedForgetPasswordScreen> {


  @override
  void initState() {
    super.initState();
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
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenpadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height*0.07,),
              Center(
                child: Image.asset(
                  "assets/images/splashlogo.png",
                  scale: 3.5,
                ),
              ),
              Spacer(),
              Center(
                child: Image.asset(
                  "assets/icons/phone.png",
                  scale: 3,
                ),
              ),
              SizedBox(
                height: height * 0.03,),
              Center(
                child: VariableText(
                  text: "Reset Successfully",
                  fontsize: 18,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  fontcolor: textcolorblack,
                  fontFamily: fontMedium,
                  weight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: height * 0.02,),
              Center(
                child: VariableText(
                  text: "Your password has been changed",
                  fontsize: 15,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  fontcolor: textcolorgrey,
                  fontFamily: fontRegular,
                  weight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: height * 0.005,),
              Center(
                child: VariableText(
                  text: "successfully.",
                  fontsize: 15,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  fontcolor: textcolorgrey,
                  fontFamily: fontRegular,
                  weight: FontWeight.w400,
                ),
              ),


            Spacer(),
              Spacer(),




            ],
          ),
        ),
        floatingActionButton:FloatingActionButton.extended(
    backgroundColor: themeColor1,
    elevation: 1,
    foregroundColor: themeColor2,
    onPressed: () {
      Navigator.push(
      context, MaterialPageRoute(builder: (context)=>VerifyPhoneNoScreen()));
      },

    label:      Row(
      children: [
    VariableText(
      text: "Login Now",
      fontsize: 15,
      textAlign: TextAlign.start,
      line_spacing: 1,
      fontcolor: themeColor2,
      fontFamily: fontMedium,
    ),
    SizedBox(width: height*0.015,),
    Image.asset('assets/icons/arrow_forward.png',scale: 2.3,),
      ],
    ),

    ),
    );
  }
}
