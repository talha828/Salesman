import 'package:flutter/material.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/mainScreen/mainScreen.dart';

class SucessFullyAddCustomerScreen extends StatefulWidget {
  @override
  _SucessFullyAddCustomerScreenState createState() => _SucessFullyAddCustomerScreenState();
}

class _SucessFullyAddCustomerScreenState extends State<SucessFullyAddCustomerScreen> {


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
            SizedBox(
              height: height * 0.07,),

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
                text: "Customer Added Successfully",
                fontsize: 18,
                textAlign: TextAlign.start,
                line_spacing: 1,
                fontcolor: textcolorblack,
                fontFamily: fontMedium,
                weight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: height * 0.01,),
            Center(
              child: VariableText(
                text: "Congratulations! You",
                fontsize: 15,
                textAlign: TextAlign.start,
                line_spacing: 1,
                fontcolor: textcolorgrey,
                fontFamily: fontRegular,
                weight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: height * 0.002,),
            Center(
              child: VariableText(
                text: " were added as customer ",
                fontsize: 15,
                textAlign: TextAlign.start,
                line_spacing: 1,
                fontcolor: textcolorgrey,
                fontFamily: fontRegular,
                weight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: height * 0.002,),
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
      floatingActionButton:new FloatingActionButton(onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>MainScreen()));

      },
        backgroundColor: themeColor1,
        elevation: 1,
       child: Image.asset('assets/icons/arrow_forward.png',scale: 2.3,),)
    );
  }
}
