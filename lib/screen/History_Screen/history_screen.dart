import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/history_model.dart';
import 'package:salesmen_app_new/model/history_model_new.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:shimmer/shimmer.dart';
class HistoryScreen extends StatefulWidget {

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  double subtotal=0;
  List<String> key=[];
  List<OrderModel> orderData=[];
  List<HistoryModel> historyData=[];

  Map<String,dynamic> history={
    'historyDetails':[
      {
        '15 July 2021':[
          {'shopname':'Mumtaz Tech Autos',
            'image':'assets/images/shop2.jpg',
            'orderid':'SKR_1001',
            'status':'Check-In',
            'time':'11: 53 AM',
            'subtotal':'20,120.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },
          {
            'shopname':'Jay’s Moto Bike',
            'image':'assets/images/shop1.jpg',
            'orderid':'SKR_1001',
            'status':'Check-Out',
            'time':'11: 53 AM',
            'subtotal':'2520.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },
          {
            'shopname':'Mumtaz Tech Autos',
            'image':'assets/images/shop3.png',
            'orderid':'SKR_1001',
            'status':'Check-Out',
            'time':'11: 53 AM',
            'subtotal':'1200.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },
       /*   {
            'shopname':'Mumtaz Tech Autos',
            'image':'assets/images/shop2.jpg',
            'orderid':'SKR_1001',
            'status':'Check-In',
            'time':'11: 53 AM',
            'subtotal':'20,120.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },
          {
            'shopname':'Jay’s Moto Bike',
            'image':'assets/images/shop1.jpg',
            'orderid':'SKR_1001',
            'status':'Check-Out',
            'time':'11: 53 AM',
            'subtotal':'2520.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },
          {
            'shopname':'Mumtaz Tech Autos',
            'image':'assets/images/shop3.png',
            'orderid':'SKR_1001',
            'status':'Check-Out',
            'time':'11: 53 AM',
            'subtotal':'1200.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },*/

        ],
      }
      ,{
        '14 July 2021':[
          {
            'shopname':'Mumtaz Tech Autos',
            'image':'assets/images/shop2.jpg',
            'orderid':'SKR_1001',
            'status':'Check-In',
            'time':'11: 53 AM',
            'subtotal':'20,120.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },
          {
            'shopname':'Jay’s Moto Bike',
            'image':'assets/images/shop1.jpg',
            'orderid':'SKR_1001',
            'status':'Check-Out',
            'time':'11: 53 AM',
            'subtotal':'2520.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },
          {
            'shopname':'Mumtaz Tech Autos',
            'image':'assets/images/shop3.png',
            'orderid':'SKR_1001',
            'status':'Check-Out',
            'time':'11: 53 AM',
            'subtotal':'1200.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },
          {
            'shopname':'Mumtaz Tech Autos',
            'image':'assets/images/shop2.jpg',
            'orderid':'SKR_1001',
            'status':'Check-In',
            'time':'11: 53 AM',
            'subtotal':'20,120.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },
          {
            'shopname':'Jay’s Moto Bike',
            'image':'assets/images/shop1.jpg',
            'orderid':'SKR_1001',
            'status':'Check-Out',
            'time':'11: 53 AM',
            'subtotal':'2520.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },
          {
            'shopname':'Mumtaz Tech Autos',
            'image':'assets/images/shop3.png',
            'orderid':'SKR_1001',
            'status':'Check-Out',
            'time':'11: 53 AM',
            'subtotal':'1200.00',
            'personname':'Mumtaz Ali',
            'bookingtime':'July 15, 11:53 AM',
            'phoneno':'0313-1234567',
            'product':[  {'name':"Motorcycle Brake Shoe",
              'price':3530.00,
              'quantity':121},
              {'name':"Motorcycle Engine Oil",
                'price':1530.00,
                'quantity':101},
              {'name':"Motorcycle Spark Plug",
                'price':2530.00,
                'quantity':20},
              {'name':"Motorcycle Cylinder",
                'price':3530.00,
                'quantity':10},]
          },

        ]
      }
    ]
  };
  bool isLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistory();
/*    List a=history['historyDetails'];
    for(int i=0;i<a.length;i++){
      var item=a[i];
      key.addAll(item.keys);
    }
    for(int i=0;i<a.length;i++){
     var item=a[i];
     for(var order in item[key[i]]){
       orderData.add(OrderModel.fromModel(order,key[i]));
     }
    }*/
  }
  setLoading(bool loading){
    setState(() {
      isLoading=loading;
    });
  }
  getHistory() async{
    setLoading(true);
    var response=await OnlineDatabase.getHistory();
    var data=jsonDecode(utf8.decode(response.bodyBytes));
    if(response.statusCode==200){
      var dataList=data['results'];
      print("history data is"+dataList.toString());
      if(dataList!=null){
        for(var item in dataList){
          historyData.add(HistoryModel.fromJson(item));
        }
      }
      setLoading(false);

    }
    else{
      setLoading(false);
      Fluttertoast.showToast(msg: "Some thing went wrong",toastLength: Toast.LENGTH_SHORT);
    }
    print("history length is"+historyData.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;
    double width=media.width;
    return Scaffold(
      appBar: MyAppBar(title: 'History',ontap: (){
        Navigator.pop(context);
      },) ,
      body:     Stack(
        children: [
          isLoading?Positioned.fill(child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: true,
            child:  Padding(
              padding:  EdgeInsets.all(screenpadding),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount:6 ,

                itemBuilder: (BuildContext context,int index){
                  return  Column(
                    children: [
                      Container(
                        height: height*0.12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:Colors.red,
                            boxShadow: [
                              BoxShadow(color: Color(0xff000000).withOpacity(0.25))
                            ]
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(8),
                          child: Row(
                            children: [

                              Expanded(
                                flex: 9,
                                child: Padding(
                                  padding:  EdgeInsets.only(left: height*0.015,),
                                  child: Container(

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: height*0.01/2.2,),
                                        VariableText(
                                          text:'',
                                          fontsize:15,
                                          fontcolor: textcolorblack,
                                          weight: FontWeight.w500,
                                          fontFamily: fontMedium,
                                        ),
                                        SizedBox(height: height*0.015,),
                                        VariableText(
                                          text:'',
                                          fontsize:12,
                                          fontcolor:Color(0xff4F4F4F),
                                          weight: FontWeight.w400,
                                          fontFamily: fontRegular,
                                        ),
                                        SizedBox(height: height*0.015,),
                                        Row(
                                          children: [
                                            VariableText(
                                              text:"",
                                              fontsize:12,
                                              fontcolor: "Check-In"=="Check-In"?themeColor1:Colors.blue,
                                              weight: FontWeight.w500,
                                              fontFamily: fontMedium,
                                            ),
                                            VariableText(
                                              text:'',
                                              fontsize:12,
                                              fontcolor:textcolorlightgrey2,
                                              weight: FontWeight.w400,
                                              fontFamily: fontRegular,
                                            ),
                                          ],
                                        ),



                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Padding(
                                    padding:  EdgeInsets.only(right:8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: height*0.01/2,),
                                        Image.asset('assets/icons/arrowright.png',scale: 2.5,color: Color(0xffCACACA),),
                                        SizedBox(height: height*0.01*2.5,),
                                        VariableText(
                                          text:'',
                                          fontsize:12,
                                          fontcolor:textcolorblack,
                                          weight: FontWeight.w500,
                                          fontFamily: fontMedium,
                                        ),
                                        SizedBox(height: height*0.01/2,),
                                        VariableText(
                                          text:'',
                                          fontsize:12,
                                          fontcolor:Color(0xffE91F22),
                                          weight: FontWeight.w500,
                                          fontFamily: fontMedium,
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
                      SizedBox(height: height*0.02,),
                    ],
                  );



                },
              ),
            ), )
          ):
          SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: screenpadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  SizedBox(height: height*0.03/2,),

                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                      itemCount:historyData.length ,
                   // itemCount:20 ,
                    itemBuilder: (BuildContext context,int index){
                      return  Column(
                        children: [
                          InkWell(
                            onTap:(){
                              //Navigator.push(context, MaterialPageRoute(builder: (_)=>HistoryDetailsScreen(orderData: orderData[index],)));
                            },
                            child: Container(
                              height: height*0.12,
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
                                    /*Expanded(
                                          flex:4,
                                          child: Container(
                                              height: height*0.11,
                                              child:ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: LayoutBuilder(
                                                  builder: (_, constraints) => Image(
                                                    fit: BoxFit.fill,
                                                    width: constraints.maxWidth,
                                                    image: AssetImage(orderData[index].image),
                                                  ),
                                                ),
                                              )
),
                                        ),*/
                                    Expanded(
                                      flex: 9,
                                      child: Padding(
                                        padding:  EdgeInsets.only(left: height*0.015,),
                                        child: Container(

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(height: height*0.01/2.2,),
                                              VariableText(
                                                text:historyData[index].purpose.toString(),
                                                fontsize:15,
                                                fontcolor:setPurposeColor(historyData[index].purpose),

                                                weight: FontWeight.w500,
                                                fontFamily: fontMedium,
                                              ),
                                              SizedBox(height: height*0.015,),
                                              VariableText(
                                                text:historyData[index].shopName.toString(),
                                                fontsize:12,
                                                fontcolor:Color(0xff4F4F4F),
                                                weight: FontWeight.w400,
                                                fontFamily: fontRegular,
                                              ),
                                              SizedBox(height: height*0.015,),
                                              Row(
                                                children: [
                                               /*   VariableText(
                                                    text:"Check-In",
                                                    fontsize:12,
                                                    fontcolor: "Check-In"=="Check-In"?themeColor1:Colors.blue,
                                                    weight: FontWeight.w500,
                                                    fontFamily: fontMedium,
                                                  ),*/
                                                  VariableText(
                                                    text:
                                                    datetimeFormater(historyData[index].datetime.toString()),
                                                    fontsize:12,
                                                    fontcolor:textcolorlightgrey2,
                                                    weight: FontWeight.w400,
                                                    fontFamily: fontRegular,
                                                  ),
                                                ],
                                              ),



                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    historyData[index].amount=='null'?Container(): Expanded(
                                      flex: 5,
                                      child: Container(
                                        child: Padding(
                                          padding:  EdgeInsets.only(right:8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(height: height*0.01/2,),
                                              //Image.asset('assets/icons/arrowright.png',scale: 2.5,color: Color(0xffCACACA),),
                                              SizedBox(height: height*0.01*2.5,),
                                              VariableText(
                                                text:'Total',
                                                fontsize:12,
                                                fontcolor:textcolorblack,
                                                weight: FontWeight.w500,
                                                fontFamily: fontMedium,
                                              ),
                                              SizedBox(height: height*0.01/2,),
                                              VariableText(
                                                text:'Rs. ${historyData[index].amount}',
                                                fontsize:12,
                                                fontcolor:Color(0xffE91F22),
                                                weight: FontWeight.w500,
                                                fontFamily: fontMedium,
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
                          ),
                          SizedBox(height: height*0.02,),
                        ],
                      );



                    },
                  )
/* nested list view
   ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount:1 ,
                      itemBuilder: (BuildContext context,int index){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VariableText(
                              text: '2021-11-29',
                              fontsize:16,fontcolor: textcolorblack,
                              weight: FontWeight.w600,
                            ),
                         SizedBox(height: 10,),
                         ListView.builder(
                           physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                          //  itemCount:historyData.length ,
                            itemCount:20 ,
                            itemBuilder: (BuildContext context,int index){
                              return  Column(
                                children: [
                                  InkWell(
                                    onTap:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (_)=>HistoryDetailsScreen(orderData: orderData[index],)));
                                    },
                                    child: Container(
                            height: height*0.12,
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
                                        *//*Expanded(
                                          flex:4,
                                          child: Container(
                                              height: height*0.11,
                                              child:ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: LayoutBuilder(
                                                  builder: (_, constraints) => Image(
                                                    fit: BoxFit.fill,
                                                    width: constraints.maxWidth,
                                                    image: AssetImage(orderData[index].image),
                                                  ),
                                                ),
                                              )
),
                                        ),*//*
                                        Expanded(
                                          flex: 9,
                                          child: Padding(
                                            padding:  EdgeInsets.only(left: height*0.015,),
                                            child: Container(

                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: height*0.01/2.2,),
                                                  VariableText(
                                                    text:historyData[index].shopname,
                                                    fontsize:15,
                                                    fontcolor: textcolorblack,
                                                    weight: FontWeight.w500,
                                                    fontFamily: fontMedium,
                                                  ),
                                                  SizedBox(height: height*0.015,),
                                                  VariableText(
                                                    text:'Order ID: ',
                                                    fontsize:12,
                                                    fontcolor:Color(0xff4F4F4F),
                                                    weight: FontWeight.w400,
                                                    fontFamily: fontRegular,
                                                  ),
                                                  SizedBox(height: height*0.015,),
                                                  Row(
                                                    children: [
                                                      VariableText(
                                                        text:"Check-In",
                                                        fontsize:12,
                                                        fontcolor: "Check-In"=="Check-In"?themeColor1:Colors.blue,
                                                        weight: FontWeight.w500,
                                                        fontFamily: fontMedium,
                                                      ),
                                                      VariableText(
                                                        text:'- 11:00',
                                                        fontsize:12,
                                                        fontcolor:textcolorlightgrey2,
                                                        weight: FontWeight.w400,
                                                        fontFamily: fontRegular,
                                                      ),
                                                    ],
                                                  ),



                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: Padding(
                                              padding:  EdgeInsets.only(right:8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: height*0.01/2,),
                                                  Image.asset('assets/icons/arrowright.png',scale: 2.5,color: Color(0xffCACACA),),
                                                  SizedBox(height: height*0.01*2.5,),
                                                  VariableText(
                                                    text:'Sub Total',
                                                    fontsize:12,
                                                    fontcolor:textcolorblack,
                                                    weight: FontWeight.w500,
                                                    fontFamily: fontMedium,
                                                  ),
                                                  SizedBox(height: height*0.01/2,),
                                                  VariableText(
                                                    text:'Rs.100',
                                                    fontsize:12,
                                                    fontcolor:Color(0xffE91F22),
                                                    weight: FontWeight.w500,
                                                    fontFamily: fontMedium,
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
                                  ),
                                  SizedBox(height: height*0.02,),
                                ],
                              );



                            },
                         )


                          ],
                        );
                      }),*/



                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  String datetimeFormater(String date) {
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedTime =DateFormat.jm().format(DateTime.parse(date));
    String formattedDate = formatter.format(DateTime.parse(date));
    return formattedDate+' '+formattedTime;
  }
  Color setPurposeColor(String purpose){
    if(purpose=='Check out'){
      return Colors.blue;
    }
    else if(purpose=='Check In'){
      return themeColor1;
    }
   else {
     return textcolorblack;
    }
  }

}
