import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/checkinScreen/checkin_screen.dart';


class SucessFullyGeneratedOrderScreen extends StatefulWidget {
  // CustomerModel shopDetails;
  // var lat,long;
  // String orderID;
  // SucessFullyGeneratedOrderScreen({this.shopDetails,this.lat,this.long, this.orderID});
  @override
  _SucessFullyGeneratedOrderScreenState createState() => _SucessFullyGeneratedOrderScreenState();
}

class _SucessFullyGeneratedOrderScreenState extends State<SucessFullyGeneratedOrderScreen> {

  // @override
  // void initState() {
  //   super.initState();
  // }
  // clearCart(){
  //   Provider.of<CartModel>(context,listen:false).clearCart();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
  // Future<bool> _onWillPop(){
  //   clearCart();
  //   return Navigator.push(context, MaterialPageRoute(builder: (_)=>CheckInScreen(shopDetails: widget.shopDetails,lat: widget.lat,long: widget.long,fromShop: true,)));
  // }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    var width = media.width;
    return Scaffold(
      backgroundColor: Color(0xffFFEEE0),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenpadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height*0.08,),
            Row(
              children: [
                Spacer(),

                InkWell(
                  onTap: (){
                    //Provider.of<CartModel>(context, listen: false).createCart();
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>CheckInScreen()));

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
                "assets/icons/checked.png",
                scale: 3,
              ),
            ),
            SizedBox(
              height: height * 0.03,),
            Center(
              child: VariableText(
                text: "Order Generated Successfully",
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
                text: "Congratulations, Your Order has been",
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
                text: " generated successfully. ",
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
                //Provider.of<CartModel>(context, listen: false).createCart();

                Navigator.push(context, MaterialPageRoute(builder: (_)=>CheckInScreen()));

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
            Center(
              child: VariableText(
                text: "Order ID: #}",
                fontsize: 16,
                textAlign: TextAlign.start,
                fontcolor: Color(0xffF6821F).withOpacity(0.5),
                fontFamily: fontRegular,
                weight: FontWeight.w500,
              ),
            ),
            SizedBox(height: height * 0.025,),




          ],
        ),
      ),

    );
  }
}
