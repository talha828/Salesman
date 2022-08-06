import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/new_customer_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/checkinScreen/checkin_screen.dart';
import 'package:salesmen_app_new/screen/mainScreen/mainScreen.dart';


class SucessFullyRecivePaymentScreen extends StatefulWidget {

  @override
  _SucessFullyRecivePaymentScreenState createState() => _SucessFullyRecivePaymentScreenState();
}

class _SucessFullyRecivePaymentScreenState extends State<SucessFullyRecivePaymentScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<bool> _onWillPop(){
    return   Navigator.push(context, MaterialPageRoute(builder: (_)=>MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    var width = media.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xffFFEEE0),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenpadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height*0.07,),
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>MainScreen()));

                    },
                    child: Image.asset(
                      "assets/icons/cross.png",
                      scale: 3.5,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Center(
                child: Image.asset(
                  "assets/icons/payment_success.png",
                  scale: 1.5,
                ),
              ),
              SizedBox(
                height: height * 0.03,),
              Center(
                child: VariableText(
                  text: "Payment Recieved",
                  fontsize: 18,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  fontcolor: textcolorblack,
                  fontFamily: fontMedium,
                  weight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: height * 0.015,),
              Center(
                child: VariableText(
                  text: "Congratulations, Your payment has",
                  fontsize: 15,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  fontcolor: textcolorgrey,
                  fontFamily: fontRegular,
                  weight: FontWeight.w400,
                ),
              ),

              Center(
                child: VariableText(
                  text: "been recieved successfully.",
                  fontsize: 15,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  fontcolor: textcolorgrey,
                  fontFamily: fontRegular,
                  weight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: height * 0.02,),
              InkWell(
                onTap: (){
                  //var customer=Provider.of<CustomerList>(context).singleCustomer;
                  //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>CheckInScreen(shopDetails: widget.shopDetails,lat: widget.lat,long: widget.long,fromShop: true,)), (route) => route.isCurrent);
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>MainScreen()));
                },
                child: Center(
                  child: Container(
                    height: height*0.06,
                    width: width*0.50,
                    decoration: BoxDecoration(
                      color: themeColor1,
                      borderRadius: BorderRadius.circular(4),

                    ),

                    child:   Padding(
                      padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                      child: Center(
                        child: VariableText(
                          text: 'CONTINUE',
                          weight: FontWeight.w700,
                          fontsize: 16,
                          fontFamily: fontRegular,
                          fontcolor: themeColor2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Spacer(),





            ],
          ),
        ),

      ),
    );
  }
}
