import 'package:flutter/material.dart';
import 'package:salesmen_app_new/model/history_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/other/other.dart';

class HistoryDetailsScreen extends StatefulWidget {
OrderModel orderData;
  HistoryDetailsScreen({this.orderData});
  @override
  _HistoryDetailsScreenState createState() => _HistoryDetailsScreenState();
}

class _HistoryDetailsScreenState extends State<HistoryDetailsScreen> {
  double total=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for(var item in widget.orderData.product){
      total+=item.price;
    }

  }

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;
    double width=media.width;
    return Scaffold(
      appBar: MyAppBar(title:widget.orderData.orderid,ontap: (){
        Navigator.pop(context);
      },) ,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(

                    boxShadow:[ BoxShadow(
                      color:Color(0xffE0E0E099).withOpacity(0.6),)],
                    color: themeColor2
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex:2,
                      child: Container(
                        child: Image.asset('assets/icons/markericon.png',scale: 2.2,),
                      ),
                    ),
                    Expanded(
                      flex:12,
                      child: Container(

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Expanded(
                              child: VariableText(
                                text: 'Plot # k-13-5/58, Hazara Masjid Road, Near LyariGeneral Hospital ',
                                fontsize:13,fontcolor: textcolorgrey,
                                weight: FontWeight.w400,
                                fontFamily: fontRegular,
                                line_spacing: 1.4,
                                textAlign: TextAlign.start,

                                max_lines: 3,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),



                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height*0.03,),
                    Row(
                      children: [
                        VariableText(
                          text: 'Personal Details',
                          fontsize:18,fontcolor: textcolorblack,
                          weight: FontWeight.w500,
                          fontFamily: fontMedium,
                        ),
                        Spacer(),
                        VariableText(
                          text: widget.orderData.status,
                          fontsize:14,fontcolor: widget.orderData.status=="Check-In"?themeColor1:Colors.blue,
                          weight: FontWeight.w700,
                          fontFamily: fontRegular,
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.03/2,),
                    Container(
                      height: height*0.13,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:themeColor2,
                          boxShadow: [
                            BoxShadow(color: Color(0xff000000).withOpacity(0.25))
                          ]
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              flex:4,
                              child: Container(
                                  height: height*0.15,
                                  child:ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: LayoutBuilder(
                                      builder: (_, constraints) => Image(
                                        fit: BoxFit.fill,
                                        width: constraints.maxWidth,
                                        image: AssetImage(widget.orderData.image),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding:  EdgeInsets.only(left: height*0.015,),
                                child: Container(


                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: height*0.009,),

                                      VariableText(
                                        text:'Shop name',
                                        fontsize:14,
                                        fontcolor:textcolorblack,
                                        weight: FontWeight.w500,
                                        fontFamily: fontMedium,
                                      ),
                                      SizedBox(height: height*0.007,),
                                      VariableText(
                                        text:'Person name',
                                        fontsize:14,
                                        fontcolor:textcolorblack,
                                        weight: FontWeight.w500,
                                        fontFamily: fontMedium,
                                      ),
                                      SizedBox(height: height*0.007,),
                                      VariableText(
                                        text:'Booking Time',
                                        fontsize:14,
                                        fontcolor:textcolorblack,
                                        weight: FontWeight.w500,
                                        fontFamily: fontMedium,
                                      ),
                                      SizedBox(height: height*0.007,),
                                      VariableText(
                                        text:'Phone No',
                                        fontsize:14,
                                        fontcolor:textcolorblack,
                                        weight: FontWeight.w500,
                                        fontFamily: fontMedium,
                                      ),




                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(


                                child: Padding(
                                  padding:  EdgeInsets.only(right: height*0.01),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: height*0.009,),
                                      VariableText(
                                        text:widget.orderData.shopname,
                                        fontsize:13,
                                        fontcolor:textcolorblack,
                                        weight: FontWeight.w400,
                                        fontFamily: fontRegular,
                                      ),
                                      SizedBox(height: height*0.007,),
                                      VariableText(
                                        text:widget.orderData.personname,
                                        fontsize:13,
                                        fontcolor:textcolorblack,
                                        weight: FontWeight.w400,
                                        fontFamily: fontRegular,
                                      ),
                                      SizedBox(height: height*0.007,),
                                      VariableText(
                                        text:widget.orderData.bookingtime,
                                        fontsize:13,
                                        fontcolor:textcolorblack,
                                        weight: FontWeight.w400,
                                        fontFamily: fontRegular,
                                      ),
                                      SizedBox(height: height*0.007,),
                                      VariableText(
                                        text:widget.orderData.phoneno,
                                        fontsize:13,
                                        fontcolor:textcolorblack,
                                        weight: FontWeight.w400,
                                        fontFamily: fontRegular,
                                      ),




                                    ],
                                  ),
                                ),
                              ),
                            ),



                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height*0.03/2,),
                    Container(height: 1,color: themeColor1,),
                    SizedBox(height: height*0.03/2,),
                    VariableText(
                      text: 'Total Items Summary',
                      fontsize:14,fontcolor: textcolorblack,
                      weight: FontWeight.w500,
                      fontFamily: fontMedium,
                    ),
                    SizedBox(height: height*0.03/2,),
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount:widget.orderData.product.length ,
                        itemBuilder: (BuildContext context,int index){
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height:25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: themeColor1
                                    ),


                                    child: Center(
                                      child: VariableText(
                                        text:  widget.orderData.product[index].productCode.toString(),
                                        fontsize:12,fontcolor: themeColor2,
                                        weight: FontWeight.w400,
                                        textAlign: TextAlign.start,
                                        fontFamily: fontRegular,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: height*0.008,),
                                  VariableText(
                                    text: widget.orderData.product[index].name,
                                    fontsize:13,fontcolor: textcolorblack,
                                    weight: FontWeight.w400,
                                    textAlign: TextAlign.start,
                                    fontFamily: fontRegular,
                                  ),
                                  Spacer(),

                                  VariableText(
                                    text:"Rs .${ widget.orderData.product[index].price.toString()}",
                                    fontsize:13,fontcolor: textcolorblack,
                                    weight: FontWeight.w400,
                                    textAlign: TextAlign.start,
                                    fontFamily: fontRegular,
                                  ),
                                ],
                              ),
                              SizedBox(height: height*0.01,),
                            ],
                          );
                        }),
                    SizedBox(height: height*0.02,),

                    Container(height: 1,color: themeColor1,),
                    SizedBox(height: height*0.02,),
                    Row(
                      children: [
                        VariableText(
                          text: 'Total',
                          fontsize:14,fontcolor: textcolorblack,
                          weight: FontWeight.w500,
                          fontFamily: fontMedium,
                        ),
                        Spacer(),
                        VariableText(
                          text: 'Rs. ${total.toString()}',
                          fontsize:14,fontcolor: themeColor1,
                          weight: FontWeight.w500,
                          fontFamily: fontMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.02,),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>OtherScreen()));

                      },
                      child: Center(
                        child: Container(
                          height: height*0.06,
                          width: width*0.60,
                          decoration: BoxDecoration(
                            color: themeColor1,
                            borderRadius: BorderRadius.circular(4),

                          ),

                          child:   Padding(
                            padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                            child: Center(
                              child: VariableText(
                                text: 'Report a problem',
                                weight: FontWeight.w500,
                                fontsize: 18,
                                fontFamily: fontRegular,
                                fontcolor: themeColor2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),




                  ],
                ),
              )




            ]

        ),
      ),
   );
  }

}
