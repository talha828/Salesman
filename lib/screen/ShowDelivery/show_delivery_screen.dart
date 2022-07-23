import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/delivery_details_model.dart';
import 'package:salesmen_app_new/model/delivery_model.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';


class ShowDeliveryScreen extends StatefulWidget {
  @override
  State<ShowDeliveryScreen> createState() => _ShowDeliveryScreenState();
}

class _ShowDeliveryScreenState extends State<ShowDeliveryScreen> {
  bool isLoading = false;
  bool isLoading2 = false;
  List<DeliveryDetails> delivery = [];
  List<DeliveryModel> fulldeliveryDetails = [];
  List<int> initialCount = [];
  double sizedboxvalue = 0.02;
  String startDate, endDate;
  DateTime now = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101),
        helpText: "Select From Date",
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: themeColor1, // header background color
                //onPrimary: Colors.black, // header text color
                //onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: themeColor1, // button text color
                ),
              ),
            ),
            child: child,
          );
        });
    if (picked != null)
      setState(() {
        startDate = picked.toString().split(" ")[0];
      });
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101),
        helpText: "Select To Date",
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: themeColor1, // header background color
                //onPrimary: Colors.black, // header text color
                //onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: themeColor1, // button text color
                ),
              ),
            ),
            child: child,
          );
        });
    if (picked != null)
      setState(() {
        endDate = picked.toString().split(" ")[0];
      });
  }

  getOrders() async {
    setLoading2(true);
    String start = DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        DateTime.now().day.toString();
    String end = DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        ((DateTime.now().day).toInt() - 10).toString();
    var userData = Provider.of<UserModel>(context, listen: false);
    print(start);
    print(end);
    print(userData.userEmpolyeeNumber);
    var response = await OnlineDatabase.getOrderDetails(
        start, end, userData.userEmpolyeeNumber);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      int i = 0;
      for (var order in data['results']) {
        delivery.add(DeliveryDetails.fromJson(order));
        print(delivery[i].cUSTOMER.toString());
        print(i);
        i++;
      }
      print(delivery.length);
      setLoading2(false);
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Internet issue',
        desc: 'Please check your internet',
        btnOkOnPress: () {},
      )..show();
      setLoading2(false);
    }
  }

  onSelect() async {
    setLoading2(true);
    setState(() {
      delivery.clear();
    });
    final userData = Provider.of<UserModel>(context, listen: false);
    var response = await OnlineDatabase.getOrderDetails(
        startDate, endDate, userData.userEmpolyeeNumber);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      int i = 0;
      for (var order in data['results']) {
        delivery.add(DeliveryDetails.fromJson(order));
        print(delivery[i].cUSTOMER.toString());
        print(i);
        i++;
      }
      setLoading2(false);
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Internet issue',
        desc: 'Please check your internet',
        btnOkOnPress: () {},
      )..show();
      setLoading2(false);
    }
  }

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(
        title: 'Delivery Details',
        ontap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                      print(startDate);
                    },
                    child: Container(
                      width: width * 0.37,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xE5E5E5),
                      ),
                      height: height * 0.065,
                      child: InputDecorator(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xff7A7A7A),
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            contentPadding: EdgeInsets.only(
                                top: 0, bottom: 0, left: 5, right: 10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/icons/calender.png',
                                  scale: 3.4,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: VariableText(
                                  text: startDate != null
                                      ? startDate
                                      : 'From Date',
                                  fontsize: 13,
                                  fontcolor: Color(0xff4D4D4D),
                                  weight: FontWeight.w500,
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    height: height * sizedboxvalue,
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate2(context);
                      print(endDate);
                    },
                    child: Container(
                      width: width * 0.37,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xE5E5E5),
                      ),
                      height: height * 0.065,
                      child: InputDecorator(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xff7A7A7A),
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            contentPadding: EdgeInsets.only(
                                top: 0, bottom: 0, left: 5, right: 10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/icons/calender.png',
                                  scale: 3.4,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: VariableText(
                                  text: endDate != null ? endDate : 'To Date',
                                  fontsize: 13,
                                  fontcolor: Color(0xff4D4D4D),
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () => onSelect(),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: themeColor1),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Text(
                        "Go",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: isLoading2
                      ? Container(
                    height: width,
                        child: Center(
                            child: CircularProgressIndicator(
                            color: themeColor1,
                          )),
                      )
                      : delivery.length == 0
                          ? Container(
                      height: width,
                      child: Center(child: Text("No shop Found")))
                          : ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    getFullDeliveryDetails(
                                        orderId:
                                            delivery[index].oRDERNO.toString(),
                                        code: delivery[index]
                                            .cUSTCODE
                                            .toString());
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: themeColor1,
                                    radius: 35,
                                    child: Text("0/0",
                                     // "${delivery[index].oRDERDATE.toString().substring(8, 10)}/${delivery[index].oRDERDATE.toString().substring(5, 7)}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title:
                                      Text(delivery[index].cUSTOMER.toString()),
                                  subtitle: Text(
                                      delivery[index].cONTMOBILE.toString()),
                                  trailing: Column(
                                    children: [
                                      Text(
                                        delivery[index].cUSTCODE.toString(),
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                      Text(
                                        delivery[index].sUBTOTAL.toString(),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: delivery.length),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getFullDeliveryDetails({String orderId, String code}) async {
    try {
      setLoading(true);
      var response = await OnlineDatabase.getDeliveryDetails(
          customercode: code,
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
            initialCount.add(item['QTY']);
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
          msg: "Something went wrong try again letter",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  setLoading2(bool loading) {
    setState(() {
      isLoading2 = loading;
    });
  }
}
