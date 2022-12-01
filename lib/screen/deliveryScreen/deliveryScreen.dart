import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/box_model.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/delivery_model.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/deliveryScreen/successfulDeliveryScreen.dart';
import 'package:salesmen_app_new/screen/paymentScreen/pin_payment_screen.dart';
import 'package:shimmer/shimmer.dart';

class DeliveryScreen extends StatefulWidget {
  CustomerModel shopDetails;
  DeliveryScreen({this.shopDetails});
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  var f = NumberFormat("###,###.0#", "en_US");

  List<bool> selectedIndex = [];
  Map<String, dynamic> deliveryDetails = {
    "delivery": [
      {
        'orderid': " SKR_1001",
        'subtotal': 20000,
        'delieveryFee': 50,
        'products': [
          {
            "itemname": "Motorcycle Spark Plug",
            "itemPrice": "Rs. 110.00",
            "itemquantity": 2,
            "itemTotal": "Rs.550.00"
          },
          {
            "itemname": "Motorcycle Spark Plug",
            "itemPrice": "Rs. 110.00",
            "itemquantity": 2,
            "itemTotal": "Rs.550.00"
          },
          {
            "itemname": "Motorcycle Spark Plug",
            "itemPrice": "Rs. 110.00",
            "itemquantity": 2,
            "itemTotal": "Rs.550.00"
          },
          {
            "itemname": "Motorcycle Spark Plug",
            "itemPrice": "Rs. 110.00",
            "itemquantity": 2,
            "itemTotal": "Rs.550.00"
          },
          {
            "itemname": "Motorcycle Spark Plug",
            "itemPrice": "Rs. 110.00",
            "itemquantity": 2,
            "itemTotal": "Rs.550.00"
          },
          {
            "itemname": "Motorcycle Spark Plug",
            "itemPrice": "Rs. 110.00",
            "itemquantity": 2,
            "itemTotal": "Rs.550.00"
          },
        ]
      },
      {
        'orderid': "# SKR_1002",
        'subtotal': 50750,
        'delieveryFee': 50,
        'products': [
          {
            "itemname": "Motorcycle Spark Plug",
            "itemPrice": "Rs. 110.00",
            "itemquantity": 2,
            "itemTotal": "Rs.550.00"
          },
        ]
      },
      {
        'orderid': " SKR_1003",
        'subtotal': 10750,
        'delieveryFee': 50,
        'products': [
          {
            "itemname": "Motorcycle Spark Plug",
            "itemPrice": "Rs. 110.00",
            "itemquantity": 2,
            "itemTotal": "Rs.550.00"
          },
        ]
      },
    ]
  };
  Map<String, dynamic> orderDetails = {
    "order": [
      {
        "itemname": "Motorcycle Spark Plug",
        "itemPrice": "Rs. 110.00",
        "itemquantity": 2,
        "itemTotal": "Rs.550.00"
      },
      {
        "itemname": "Motorcycle Engine Oil",
        "itemPrice": "Rs. 520.00",
        "itemquantity": 15,
        "itemTotal": "Rs.1,530.00"
      },
      {
        "itemname": "Motorcycle Brake Shoe",
        "itemPrice": "Rs. 125.00",
        "itemquantity": 13,
        "itemTotal": "Rs.1,875.00"
      },
      {
        "itemname": "Motorcycle Spark Plug",
        "itemPrice": "Rs. 110.00",
        "itemquantity": 2,
        "itemTotal": "Rs.550.00"
      },
    ]
  };
  bool isLoading2 = false;
  bool checkOrderSummary = false;
  double sizedboxvalue = 0.02;
  bool checkbox = true;
  int count = 0;
  int delieveryFee = 0;
  int subtotal = 0;
  bool isLoading = false;
  List delivery = [];
  List<DeliveryModel> fulldeliveryDetails = [];
  List boxDelivery = [];
  List<int> initialCount = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMainDeliveryDetails();
    //for (var item in deliveryDetails['delivery']) {
      selectedIndex.add(false);
      selectedIndex.add(false);
      selectedIndex.add(false);
   // }
  }

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  getMainDeliveryDetails() async {
    try {
      setLoading(true);
      var response = await OnlineDatabase.getDeliveryDetails(
          customercode: widget.shopDetails.customerCode,
          dataType: 'PSO',
          showFullDetails: false);
      print("Response is" + response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        // print("Response is" + data.toString());
        var datalist = data['results'];
        print("data is " + datalist.length.toString());
        delivery.clear();
        if (datalist != null) {
          for (var item in data["results"]) {
            delivery.add(DeliveryModel.getMainDetails(item));
          }
          print("data is " + delivery.length.toString());
          //setLoading(false);
          getBoxDeliveryDetails();
        }
      } else if (response.statusCode == 400) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        setLoading(false);
        Fluttertoast.showToast(
            msg: "${data['results'].toString()}",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e, stack) {
      print('exception is' + e.toString() + stack.toString());
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Error: "+e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  getBoxDeliveryDetails() async {
    try {
      //setLoading(true);
      var response = await OnlineDatabase.getBoxDeliveries(
        customercode: widget.shopDetails.customerCode,
        dataType: 'ORDERTRANSFER',
      );
      print("Response is: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // print("Response is: " + data.toString());
        var datalist = data['results'];
        boxDelivery.clear();
        if (datalist != null) {
          print(datalist.toString());
          for (var item in data["results"]) {
            if (item['DELIVERED'] == 'N')
              boxDelivery.add(BoxModel.fromJson(item));
          }
          print("data is: " + boxDelivery.length.toString());
          setLoading(false);
        }
      } else if (response.statusCode == 400) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        setLoading(false);
        Fluttertoast.showToast(
            msg: "${data['results'].toString()}",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e, stack) {
      print('exception getBoxDeliveryDetails: ' +
          e.toString() +
          stack.toString());
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Error: "+e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  getFullDeliveryDetails({String orderId}) async {
    try {
      setLoading(true);
      var response = await OnlineDatabase.getDeliveryDetails(
          customercode: widget.shopDetails.customerCode,
          dataType: 'PSOITEMS',
          showFullDetails: true,
          orderId: orderId);
      print("Response is" + response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        var datalist = data['results'];
        if (datalist != null) {
          fulldeliveryDetails.clear();
          initialCount.clear();
          for (var item in datalist) {
            fulldeliveryDetails.add(DeliveryModel.fromJson(item));
            initialCount.add(item['QTY'].toInt());
          }
          showDialog(
              fulldeliveryDetails: fulldeliveryDetails, orderId: orderId);
          //confirmBox(fulldeliveryDetails: fulldeliveryDetails,orderId: orderId);
          print("length is" + fulldeliveryDetails.length.toString());
          setLoading(false);
        }
      } else if (response.statusCode == 400) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        setLoading(false);
        Fluttertoast.showToast(
            msg: "${data['results'].toString()}",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e, stack) {
      print('exception is' + e.toString() + stack.toString());
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Error: "+e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    var customer=Provider.of<CustomerList>(context).singleCustomer;
    return Scaffold(
      appBar:MyAppBar(
        title: 'Check-In',
        ontap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          InkWell(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SucessFullyDelieveredOrderScreen())),
            child: customShopDetailsContainer(
                shopname: widget.shopDetails.customerShopName,
                address: widget.shopDetails.customerAddress,
                height: height,
                width: width,
                imageurl: widget.shopDetails.customerImage),
          ),
          SizedBox(
            height: height * sizedboxvalue,
          ),
          isLoading
              ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenpadding),
                        child: Container(
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: selectedIndex[index] == true
                                    ? Color(0xffF6821F).withOpacity(0.6)
                                    : Color(0xffffffff).withOpacity(0.6)),
                            color: selectedIndex[index] == true
                                ? Color(0xffFFCB9F).withOpacity(0.5)
                                : themeColor2,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenpadding,
                                horizontal: screenpadding / 2),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: height * sizedboxvalue / 2,
                                ),
                                Expanded(
                                  flex: 13,
                                  child: Container(
                                    height: height * 0.07,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        VariableText(
                                          text: '',
                                          fontsize: 14,
                                          fontcolor: textcolorblack,
                                          weight: FontWeight.w700,
                                          fontFamily: fontRegular,
                                        ),
                                        VariableText(
                                          text: '',
                                          fontsize: 12,
                                          fontcolor: textcolorgrey,
                                          weight: FontWeight.w400,
                                          fontFamily: fontRegular,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: height * sizedboxvalue,
                                ),
                                Container(
                                  child: Expanded(
                                    flex: 7,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: height * 0.04,
                                        decoration: BoxDecoration(
                                            color: themeColor1,
                                            borderRadius:
                                            BorderRadius.circular(5)),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            VariableText(
                                              text: '',
                                              fontsize: 13,
                                              fontcolor: themeColor2,
                                              weight: FontWeight.w700,
                                              fontFamily: fontRegular,
                                            ),
                                            SizedBox(
                                              width: height * 0.01,
                                            ),
                                            Image.asset(
                                              'assets/icons/arrowright.png',
                                              color: Colors.red,
                                              scale: 2.5,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * sizedboxvalue,
                      ),
                    ],
                  );
                }),
          )
              : orderDetailsBlock(height, width,customer),
        ]),
      ),
/*      bottomNavigationBar: BottomAppBar(
          child: Container(
          height: height*0.15,
          color: themeColor2,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: screenpadding),
            child: Column(

              children: [
                SizedBox(height: height*sizedboxvalue,),
                Row(
                  children: [
                    VariableText(
                      text:'Shipping:',
                      fontsize:11,fontcolor: textcolorgrey,
                      weight: FontWeight.w400,
                      fontFamily: fontRegular,
                    ),
                    Spacer(),
                    VariableText(
                      text:'Rs ${delieveryFee.toString()}',
                      fontsize:11,fontcolor: textcolorgrey,
                      weight: FontWeight.w400,
                      fontFamily: fontRegular,
                    ),

                  ],
                ),
                SizedBox(height: height*sizedboxvalue/3,),
                Row(
                  children: [
                    VariableText(
                      text:'Total: ',
                      fontsize:11,fontcolor: textcolorblack,
                      weight: FontWeight.w500,
                      fontFamily: fontMedium,
                    ),
                    Spacer(),
                    VariableText(
                      text:'Rs ${subtotal.toString()}',
                      fontsize:15,fontcolor: themeColor1,
                      weight: FontWeight.w700,
                      fontFamily: fontRegular,
                    ),

                  ],
                ),
                SizedBox(height: height*sizedboxvalue/2,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>SucessFullyDelieveredOrderScreen()));
                  },

                  child: Container(
                    height: height*0.06,
                    decoration: BoxDecoration(
                      color: themeColor1,
                      borderRadius: BorderRadius.circular(4),

                    ),

                    child:   Padding(
                      padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                      child: Center(
                        child: VariableText(
                          text: 'DELIEVER',
                          weight: FontWeight.w700,
                          fontsize: 15,
                          fontFamily: fontMedium,
                          fontcolor: themeColor2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),*/
    );
  }

  Widget orderDetailsBlock(double height, double width,CustomerModel customer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            children: [
              VariableText(
                text: 'Box:',
              )
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: boxDelivery.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenpadding),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: /*selectedIndex[index]==true ?Color(0xffF6821F).withOpacity(0.6):*/ Color(
                                0xffffffff)
                                .withOpacity(0.6)),
                        color: /*selectedIndex[index]==true ?Color(0xffFFCB9F).withOpacity(0.5):*/ themeColor2,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenpadding,
                            horizontal: screenpadding / 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: height * sizedboxvalue / 2,
                            ),
                            Expanded(
                              flex: 13,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VariableText(
                                      text:
                                      'Box id: ${boxDelivery[index].trNumber}',
                                      fontsize: 14,
                                      fontcolor: textcolorblack,
                                      weight: FontWeight.w700,
                                      fontFamily: fontRegular,
                                    ),
                                    VariableText(
                                      text:
                                      'Sub Total : ${boxDelivery[index].totalAmount}',
                                      fontsize: 12,
                                      fontcolor: textcolorgrey,
                                      weight: FontWeight.w400,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: height * sizedboxvalue,
                            ),
                            Container(
                              child: Expanded(
                                flex: 7,
                                child: InkWell(
                                  onTap: () {
                                    showBoxDialog(
                                        boxDetails: boxDelivery[index],customer: customer);
                                   // getFullDeliveryDetails(orderId: delivery[index].orderNumber);
                                  },
                                  child: Container(
                                    height: height * 0.04,
                                    decoration: BoxDecoration(
                                        color: themeColor1,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        VariableText(
                                          text: 'View',
                                          fontsize: 13,
                                          fontcolor: themeColor2,
                                          weight: FontWeight.w700,
                                          fontFamily: fontRegular,
                                        ),
                                        SizedBox(
                                          width: height * 0.01,
                                        ),
                                        Image.asset(
                                          'assets/icons/arrowright.png',
                                          scale: 2.5,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * sizedboxvalue,
                  ),
                ],
              );
            }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            children: [
              VariableText(
                text: 'PSO:',
              )
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: delivery.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenpadding),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: /*selectedIndex[index]==true ?Color(0xffF6821F).withOpacity(0.6):*/ Color(
                                0xffffffff)
                                .withOpacity(0.6)),
                        color: /*selectedIndex[index]==true ?Color(0xffFFCB9F).withOpacity(0.5):*/ themeColor2,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenpadding,
                            horizontal: screenpadding / 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*
                            check box
                            Expanded(
                              flex: 1,
                              child: Container(
                              child: InkWell(
                                  onTap: (){
                                    print("print "+index.toString());
                                      if(selectedIndex[index]==true){
                                        selectedIndex[index]=false;
                                       delieveryFee-=deliveryDetails['delivery'][index]['delieveryFee'];
                                        subtotal-=deliveryDetails['delivery'][index]['subtotal'];  }
                                      else {
                                        selectedIndex[index]=true;
                                        delieveryFee+=deliveryDetails['delivery'][index]['delieveryFee'];
                                        subtotal+=deliveryDetails['delivery'][index]['subtotal'];

                                      }
                                      setState(() {
                                      });

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: selectedIndex[index]==true ? themeColor1 : Colors.white,
                                        border: Border.all(
                                            color: selectedIndex[index]==true
                                                ? themeColor1
                                                : themeColor1),
                                        borderRadius: BorderRadius.circular(3)),
                                    child: Center(
                                        child:
                                        Icon(Icons.check, size: 11, color: Colors.white)),
                                  ),
                                ),
                               ),
                            ),*/
                            SizedBox(
                              width: height * sizedboxvalue / 2,
                            ),
                            Expanded(
                              flex: 13,
                              child: Container(
                                // height: height*0.07,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VariableText(
                                      text:
                                      'Order id: ${delivery[index].orderNumber}',
                                      fontsize: 14,
                                      fontcolor: textcolorblack,
                                      weight: FontWeight.w700,
                                      fontFamily: fontRegular,
                                    ),
                                    VariableText(
                                      text:
                                      'Sub Total : ${delivery[index].subTotal}',
                                      fontsize: 12,
                                      fontcolor: textcolorgrey,
                                      weight: FontWeight.w400,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: height * sizedboxvalue,
                            ),
                            Container(
                              child: Expanded(
                                flex: 7,
                                child: InkWell(
                                  onTap: () {
                                    getFullDeliveryDetails(
                                        orderId: delivery[index].orderNumber);
                                  },
                                  child: Container(
                                    height: height * 0.04,
                                    decoration: BoxDecoration(
                                        color: themeColor1,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        VariableText(
                                          text: 'View Order',
                                          fontsize: 13,
                                          fontcolor: themeColor2,
                                          weight: FontWeight.w700,
                                          fontFamily: fontRegular,
                                        ),
                                        SizedBox(
                                          width: height * 0.01,
                                        ),
                                        Image.asset(
                                          'assets/icons/arrowright.png',
                                          scale: 2.5,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * sizedboxvalue,
                  ),
                ],
              );
            }),
      ],
    );
  }



  void showBoxDialog({BoxModel boxDetails ,CustomerModel customer}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    AwesomeDialog(
        context: context,
        dismissOnTouchOutside: false,
        animType: AnimType.SCALE,
        dialogType: DialogType.NO_HEADER,
        body: StatefulBuilder(builder: (context, setState) {
          double subtotal = 0;
          for (int i = 0; i < boxDetails.orders.length; i++) {
            subtotal += double.parse(boxDetails.orders[i].amount.toString());
          }
          return Container(
            height: height * 0.55,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset('assets/icons/ledger.png',
                          color: Color(0xff1E1E1E), scale: 10.3),
                      SizedBox(
                        width: height * 0.01,
                      ),
                      VariableText(
                        text: 'Box Id: ${boxDetails.trNumber}',
                        fontsize: 14,
                        fontcolor: textcolorblack,
                        weight: FontWeight.w700,
                        fontFamily: fontRegular,
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              height: height * 0.03,
                              width: width * 0.05,
                              //color: Colors.red,
                              child: Image.asset('assets/icons/cross.png',
                                  scale: 3.5))),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Container(
                    height: 1,
                    color: Color(0xffDDDDDD),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: boxDetails.orders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /*Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap:(){
                                        //fulldeliveryDetails.removeAt(index);
                                        setState(() {
                                        });
                                      },
                                      child: Container(
                                        child: Image.asset('assets/icons/delete.png',scale: 3.5,),
                                      ),
                                    ),
                                  ),*/
                                  SizedBox(
                                    width: height * sizedboxvalue / 2,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Color(0xffF6821F)
                                                .withOpacity(0.6)),
                                        //color: Color(0xffF6821F).withOpacity(0.5),
                                      ),
                                      child: Row(
                                        children: [
                                          /*Expanded(
                                            flex: 2,
                                            child: InkWell(
                                              onTap: (){
                                                if( fulldeliveryDetails[index].quantity>1){
                                                  setState(() {
                                                    fulldeliveryDetails[index].quantity--;
                                                    fulldeliveryDetails[index].itemcountController.text=fulldeliveryDetails[index].quantity.toString();
                                                    fulldeliveryDetails[index].itemtotal= fulldeliveryDetails[index].quantity* fulldeliveryDetails[index].rate;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                ),
                                                height: height*0.04,
                                                //child: Image.asset('assets/icons/minus.png',scale: 2.5,),
                                              ),
                                            ),
                                          ),*/
                                          Expanded(
                                            child: Container(
                                              height: height * 0.04,
                                              color: themeColor2,
                                              child: Center(
                                                child: TextField(
                                                  enabled: false,
                                                  textAlign: TextAlign.center,
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                    hintText: boxDetails
                                                        .orders[index]
                                                        .transferQty,
                                                    hintStyle: TextStyle(
                                                      fontSize: 13,
                                                      color: themeColor1,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontFamily: fontMedium,
                                                    ),
                                                    contentPadding:
                                                    EdgeInsets.all(2),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide.none,
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: themeColor1,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: fontMedium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          /* Expanded(
                                            flex: 2,
                                            child: InkWell(
                                              onTap: (){
                                                if( fulldeliveryDetails[index].quantity < initialCount[index]){
                                                  setState(() {
                                                    fulldeliveryDetails[index].quantity++;
                                                    fulldeliveryDetails[index].itemcountController.text=fulldeliveryDetails[index].quantity.toString();
                                                    fulldeliveryDetails[index].itemtotal= fulldeliveryDetails[index].quantity* fulldeliveryDetails[index].rate;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                ),
                                                height: height*0.04,
                                                //child: Image.asset('assets/icons/plus.png',scale: 2.5,),
                                              ),
                                            ),
                                          ),*/
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: height * sizedboxvalue / 2,
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          VariableText(
                                            text: boxDetails
                                                .orders[index].product,
                                            fontsize: 12,
                                            fontcolor: textcolorblack,
                                            weight: FontWeight.w500,
                                            textAlign: TextAlign.start,
                                            fontFamily: fontMedium,
                                          ),
                                          SizedBox(
                                            height: height * 0.0025,
                                          ),
                                          VariableText(
                                            text: boxDetails.orders[index].rate,
                                            fontsize: 10,
                                            fontcolor: Color(0xff828282),
                                            weight: FontWeight.w400,
                                            fontFamily: fontRegular,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //SizedBox(width:height*sizedboxvalue/2,),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          VariableText(
                                            text: 'Total',
                                            fontsize: 10,
                                            fontcolor: Color(0xff828282),
                                            weight: FontWeight.w400,
                                            fontFamily: fontRegular,
                                          ),
                                          SizedBox(
                                            height: height * 0.0025,
                                          ),
                                          VariableText(
                                            text:
                                            boxDetails.orders[index].amount,
                                            fontsize: 12,
                                            fontcolor: themeColor1,
                                            weight: FontWeight.w700,
                                            fontFamily: fontRegular,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * sizedboxvalue * 1.5,
                              ),
                            ],
                          );
                        }),
                  ),
                  Container(
                    height: 1,
                    color: Color(0xffDDDDDD),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Row(
                    children: [
                      VariableText(
                        text: 'Sub Total',
                        fontsize: 14,
                        fontcolor: textcolorgrey,
                        weight: FontWeight.w400,
                        fontFamily: fontRegular,
                      ),
                      Spacer(),
                      VariableText(
                        //text:'Rs $subtotal',
                        text:
                        'Rs ${f.format(double.parse(boxDetails.totalAmount.toString()))}', ///////////
                        fontsize: 14, fontcolor: themeColor1,
                        weight: FontWeight.w400,
                        fontFamily: fontRegular,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.015),
                  InkWell(
                    onTap: () async {
                      if (!isLoading2) {
                        try {
                          setState(() {
                            isLoading2 = true;
                          });
                      var location=await Location().getLocation();
                          // List<String> tempContact = [];
                          // final userData =
                          // Provider.of<UserModel>(context, listen: false);
                          // if (widget.shopDetails.customerContactNumber !=
                          //     null) {
                          //   tempContact.add(widget
                          //       .shopDetails.customerContactNumber
                          //       .substring(
                          //       0,
                          //       widget.shopDetails.customerContactNumber
                          //           .length));
                          // }
                          // // if (widget.shopDetails.customerContactNumber2 !=
                          // //     null) {
                          // //   tempContact
                          // //       .add(widget.shopDetails.customerContactNumber2);
                          // // } else {
                          // //   //tempContact.add('+923340243440');
                          // // }
                          // var dio = new Dio();
                          // String url = "https://erp.suqexpress.com/api/getcode";
                          // Map<String, dynamic> map = {
                          //   "purpose": 1,
                          //   "number": tempContact.first,
                          //   "amount":boxDetails.totalAmount,
                          //   "customer_id":widget.shopDetails.customerCode,
                          //   "emp_name": userData.userName,
                          // };
                          // FormData formData = FormData.fromMap(map);
                          // //TODO sms post
                          // Response smsResponse =
                          // await dio.post(url, data: formData).catchError((e){
                          //   setLoading(false);
                          //   Fluttertoast.showToast(
                          //       msg: e.response.data["message"].toString(),
                          //       toastLength: Toast.LENGTH_SHORT);
                          // });
                          //if (smsResponse.statusCode == 200) {
                          //   setState(() {
                          //     isLoading2 = false;
                          //   });
                            //print(smsResponse.data.toString());
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (_) => PaymentPin(
                            //         userName:userData.userName ,
                            //         customer:widget.shopDetails ,
                            //         total:boxDetails.totalAmount,
                            //         pin: smsResponse.data["code"].toString(),
                            //         contactNumbers: tempContact,
                            //         onSuccess: () async {
                                      // setState(() {
                                      //   isLoading2 = true;
                                      // });

                                      var response = await OnlineDatabase
                                          .postBoxDeliverDetails(
                                              boxDetails: boxDetails,
                                              lat: location.latitude.toString(),
                                              long: location.longitude.toString(),
                                              customerCode: widget
                                                  .shopDetails.customerCode);

                                      // var response = await OnlineDatabase
                                      //     .newpostBoxDeliverDetails(
                                      //     boxDetails:boxDetails,
                                      //     emp_id:userData.userID ,
                                      //     emp_name: userData.userName,
                                      //     lat: location.latitude.toString(),
                                      //     code_id: smsResponse.data["id"],
                                      //     long: location.longitude.toString(),
                                      //     amount: boxDetails.totalAmount,
                                      //     customerCode: widget
                                      //         .shopDetails.customerCode).catchError((e){
                                      //   setState(() {
                                      //     isLoading2 = false;
                                      //   });
                                      //   setLoading(false);
                                      //   Navigator.pop(context);
                                      //   AwesomeDialog(
                                      //     context: context,
                                      //     dialogType: DialogType.ERROR,
                                      //     animType: AnimType.BOTTOMSLIDE,
                                      //     title: "Error",
                                      //     desc: "Error: " + e.response.data["message"],
                                      //     btnCancelText: "Ok",
                                      //     dismissOnTouchOutside: false,
                                      //     btnOkOnPress: () {},
                                      //   )..show();
                                      // });
                                      print("Post box Response is: " +
                                          response.statusCode.toString());
                                      if (response.statusCode == 200) {

                                        var data = jsonDecode(
                                            utf8.decode(response.bodyBytes));
                                        print("Post box Response is: " +
                                            data.toString());
                                        // String msgData = "Thankyou, you have receive goods of Rs ${boxDetails.totalAmount} from ${userData.userName} %26 Download app https://bit.ly/38uffP8";
                                        //     msgData+= " ID: ${tempContact[0]} Pass: 555";
                                        // //     "آپ ${boxDetails.totalAmount} روپے کا سامان لے چکے ہیں۔ شکریہ۔";
                                        //
                                        // var responseMsg = await OnlineDatabase
                                        //     .sendText(
                                        //         tempContact[0], msgData);
                                        // if (responseMsg.statusCode == 200) {
                                        //   print("Message sent!!!!!");
                                        // }

                                         Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    SucessFullyDelieveredOrderScreen(customer:customer,)));


                                      }else{
                                        Fluttertoast.showToast(
                                                msg: "Code not sent, Try again",
                                                toastLength: Toast.LENGTH_SHORT);
                                      }
                                      //setLoading(false);
                                    // },
                                //   ),
                                // ));
                          // } else {
                          //   setState(() {
                          //     isLoading2 = false;
                          //   });
                          //   Fluttertoast.showToast(
                          //       msg: "Code not sent, Try again",
                          //       toastLength: Toast.LENGTH_SHORT);
                          // }
                        } catch (e, stack) {
                          setState(() {
                            isLoading2 = false;
                          });
                          print('exception is: ' + e.response.toString());
                          Fluttertoast.showToast(
                              msg: e.response.data["message"].toString(),
                              toastLength: Toast.LENGTH_LONG,
                              backgroundColor: Colors.black87,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    },
                    child: Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        color: themeColor1,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: isLoading2
                            ? ProcessLoading()
                            : VariableText(
                          text: 'DELIVER',
                          weight: FontWeight.w700,
                          fontsize: 15,
                          fontFamily: fontMedium,
                          fontcolor: themeColor2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                ],
              ),
            ),
          );
        }))
      ..show();
  }

  void showDialog({List<DeliveryModel> fulldeliveryDetails, String orderId}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    AwesomeDialog(
        context: context,
        dismissOnTouchOutside: false,
        animType: AnimType.SCALE,
        dialogType: DialogType.NO_HEADER,
        body: StatefulBuilder(builder: (context, setState) {
          double subtotal = 0;
          for (int i = 0; i < fulldeliveryDetails.length; i++) {
            subtotal +=
                fulldeliveryDetails[i].quantity * fulldeliveryDetails[i].rate;
          }
          return Container(
            height: height * 0.55,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset('assets/icons/ledger.png',
                          color: Color(0xff1E1E1E), scale: 10.3),
                      SizedBox(
                        width: height * 0.01,
                      ),
                      VariableText(
                        text: 'Order Id: ${orderId}',
                        fontsize: 14,
                        fontcolor: textcolorblack,
                        weight: FontWeight.w700,
                        fontFamily: fontRegular,
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              height: height * 0.03,
                              width: width * 0.05,
                              child: Image.asset('assets/icons/cross.png',
                                  scale: 3.5))),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Container(
                    height: 1,
                    color: Color(0xffDDDDDD),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: fulldeliveryDetails.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /*Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap:(){
                                      fulldeliveryDetails.removeAt(index);
                                      setState(() {
                                      });
                                    },
                                    child: Container(
                                      child: Image.asset('assets/icons/delete.png',scale: 3.5,),
                                    ),
                                  ),
                                ),*/
                                  SizedBox(
                                    width: height * sizedboxvalue / 2,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Color(0xffF6821F)),
                                        //color: Color(0xffF6821F).withOpacity(0.5),
                                      ),
                                      child: Row(
                                        children: [
                                          /*Expanded(
                                          flex: 2,
                                          child: InkWell(
                                            onTap: (){
                                              if( fulldeliveryDetails[index].quantity>1){
                                                setState(() {
                                                  fulldeliveryDetails[index].quantity--;
                                                  fulldeliveryDetails[index].itemcountController.text=fulldeliveryDetails[index].quantity.toString();
                                                  fulldeliveryDetails[index].itemtotal= fulldeliveryDetails[index].quantity* fulldeliveryDetails[index].rate;
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                              ),
                                              height: height*0.04,
                                              child: Image.asset('assets/icons/minus.png',scale: 2.5,),
                                            ),
                                          ),
                                        ),*/
                                          Expanded(
                                            child: Container(
                                              height: height * 0.04,
                                              color: themeColor2,
                                              child: Center(
                                                child: TextField(
                                                  enabled: false,
                                                  textAlign: TextAlign.center,
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  controller:
                                                  fulldeliveryDetails[index]
                                                      .itemcountController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                    fulldeliveryDetails[
                                                    index]
                                                        .quantity
                                                        .toString(),
                                                    hintStyle: TextStyle(
                                                      fontSize: 13,
                                                      color: themeColor1,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontFamily: fontMedium,
                                                    ),
                                                    contentPadding:
                                                    EdgeInsets.all(2),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide.none,
                                                    ),
                                                  ),
                                                  /*onChanged: (value){
                                                  setState(() {
                                                    fulldeliveryDetails[index].quantity=int.parse(value);
                                                    fulldeliveryDetails[index].itemtotal= fulldeliveryDetails[index].quantity* fulldeliveryDetails[index].rate;
                                                  });
                                                },*/
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: themeColor1,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: fontMedium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          /*Expanded(
                                          flex: 2,
                                          child: InkWell(
                                            onTap: (){
                                              if( fulldeliveryDetails[index].quantity < initialCount[index]){
                                                setState(() {
                                                  fulldeliveryDetails[index].quantity++;
                                                  fulldeliveryDetails[index].itemcountController.text=fulldeliveryDetails[index].quantity.toString();
                                                  fulldeliveryDetails[index].itemtotal= fulldeliveryDetails[index].quantity* fulldeliveryDetails[index].rate;
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                              ),
                                              height: height*0.04,
                                              child: Image.asset('assets/icons/plus.png',scale: 2.5,),
                                            ),
                                          ),
                                        ),*/
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: height * sizedboxvalue / 2,
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          VariableText(
                                            text: fulldeliveryDetails[index]
                                                .productName,
                                            fontsize: 12,
                                            fontcolor: textcolorblack,
                                            weight: FontWeight.w500,
                                            textAlign: TextAlign.start,
                                            fontFamily: fontMedium,
                                          ),
                                          SizedBox(
                                            height: height * 0.0025,
                                          ),
                                          VariableText(
                                            text: fulldeliveryDetails[index]
                                                .rate
                                                .toString(),
                                            fontsize: 10,
                                            fontcolor: Color(0xff828282),
                                            weight: FontWeight.w400,
                                            fontFamily: fontRegular,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //SizedBox(width:height*sizedboxvalue/2,),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          VariableText(
                                            text: 'Total',
                                            fontsize: 10,
                                            fontcolor: Color(0xff828282),
                                            weight: FontWeight.w400,
                                            fontFamily: fontRegular,
                                          ),
                                          SizedBox(
                                            height: height * 0.0025,
                                          ),
                                          VariableText(
                                            text: fulldeliveryDetails[index]
                                                .itemtotal
                                                .toString(),
                                            fontsize: 12,
                                            fontcolor: themeColor1,
                                            weight: FontWeight.w700,
                                            fontFamily: fontRegular,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * sizedboxvalue * 1.5,
                              ),
                            ],
                          );
                        }),
                  ),
                  Container(
                    height: 1,
                    color: Color(0xffDDDDDD),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Row(
                    children: [
                      VariableText(
                        text: 'Sub Total',
                        fontsize: 14,
                        fontcolor: textcolorgrey,
                        weight: FontWeight.w400,
                        fontFamily: fontRegular,
                      ),
                      Spacer(),
                      VariableText(
                        //text:'Rs $subtotal',
                        text: 'Rs $subtotal',
                        fontsize: 14, fontcolor: themeColor1,
                        weight: FontWeight.w400,
                        fontFamily: fontRegular,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  /*Row(
                  children: [
                    VariableText(
                      text:'Delivery Fee',
                      fontsize:14,fontcolor: textcolorgrey,
                      weight: FontWeight.w400,
                      fontFamily: fontRegular,
                    ),
                    Spacer(),
                    VariableText(
                      text:'Rs 50',
                      fontsize:14,fontcolor: textcolorgrey,
                      weight: FontWeight.w400,
                      fontFamily: fontRegular,
                    ),
                  ],
                ),
                SizedBox(height: height*0.015,),*/
                  /*InkWell(
                  onTap: () async {
                    print(fulldeliveryDetails.first.quantity.toString());
                    try {
                      setState((){
                        isLoading2=true;
                      });
                      var response =await  OnlineDataBase.postDeliverDetails(deliverydata:fulldeliveryDetails,lat:widget.lat.toString(),long:widget.long.toString(),customerCode:widget.shopDetails.customerCode,orderNumber: orderId);
                      print("Response is" + response.statusCode.toString());
                      if (response.statusCode == 200) {
                        var data = jsonDecode(utf8.decode(response.bodyBytes));
                        print("Response is" + data.toString());
                        setState((){
                          isLoading2=false;
                        });
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>SucessFullyDelieveredOrderScreen(shopDetails: widget.shopDetails,lat: widget.lat,long: widget.long,)));
                      }
                      else if(response.statusCode == 500){
                        setState((){
                          Fluttertoast.showToast(
                              msg: "Product is out of stock",
                              toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: Colors.black87,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          isLoading2=false;
                        });
                      }
                      else {
                        setState((){
                          isLoading2=false;
                        });
                        // print("delivery screen --> ${response.body.toString()}");
                        Fluttertoast.showToast(
                            msg: "Internet Issue",
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.black87,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    } catch (e, stack) {
                      setState((){
                        isLoading2=false;
                      });
                      print('exception is'+e.toString());
                      Fluttertoast.showToast(
                          msg: "Something went wrong try again letter",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.black87,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: Container(
                    height: height*0.06,
                    decoration: BoxDecoration(
                      color: themeColor1,
                      borderRadius: BorderRadius.circular(4),

                    ),

                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                      child: Center(
                        child:
                        isLoading2?ProcessLoading():
                        VariableText(
                          text: 'DELIVER',
                          weight: FontWeight.w700,
                          fontsize: 15,
                          fontFamily: fontMedium,
                          fontcolor: themeColor2,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height*0.015,),*/
                ],
              ),
            ),
          );
        }))
      ..show();
  }

  postOrderDetails(
      {List<DeliveryModel> deliveryData, String orderNumber}) async {
    try {
      setState(() {
        isLoading2 = true;
      });
      var location=await Location().getLocation();
      var response = await OnlineDatabase.postDeliverDetails(
          deliverydata: deliveryData,
          lat: location.latitude.toString(),
          long: location.longitude.toString(),
          customerCode: widget.shopDetails.customerCode,
          orderNumber: orderNumber);
      print("Response is" + response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print("Response is" + data.toString());
        Fluttertoast.showToast(
            msg: "Order Delivered Successfully",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SucessFullyDelieveredOrderScreen(
                )));
      } else if (response.statusCode == 500) {
        setState(() {
          Fluttertoast.showToast(
              msg: "Product is out of stock",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 16.0);
          isLoading2 = false;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Internet issue",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e, stack) {
      // setLoading2(false);
      print('exception is' + e.toString());
      Fluttertoast.showToast(
          msg:'Error' + e.response.toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
