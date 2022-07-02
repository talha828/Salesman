import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/model/customer_model.dart';
import 'package:salesmen_app_new/widget/loding_indicator.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/OrderScreen/categories_screen.dart';
import 'package:salesmen_app_new/screen/deliveryScreen/deliveryScreen.dart';
import 'package:salesmen_app_new/screen/ledgerScreen/ledgerScreen.dart';
import 'package:salesmen_app_new/screen/other/other.dart';
import 'package:salesmen_app_new/screen/paymentScreen/paymentScreen.dart';

class CheckInScreen extends StatefulWidget {

  // CustomerModel shopDetails;
  // List<CustomerModel> customerList;
  // double lat, long;
  // var locationdata;
  // bool fromShop;
  // CheckInScreen(
  //     {required this.shopDetails,
  //       required this.customerList,
  //       required this.lat,
  //       required this.long,
  //       required this.fromShop,
  //       this.locationdata});

  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  bool isLoading = false;
  // double walletCapacity = 0;
  // double usedBalance = 0;
  // double availableBalance = 0.0;
  // late CustomerModel userDetails;
  // // List<ProductModel> product = [];
  // var f = NumberFormat("###,###.0#", "en_US");
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getUser();
  //   getCustomerTransactionData();
  //   showDistance();
  //   getAllProductData();
  // }
  // Coordinates userLatLng;
  //
  // calculateDistance(double lat,double long)async{
  //   Location location = new Location();
  //   var _location = await location.getLocation();
  //   print(_location.latitude);
  //   print(_location.longitude);
  //   print(widget.lat);
  //   print(widget.long);
  //   var distance = geo.Geolocator.distanceBetween(
  //       _location.latitude, _location.longitude,
  //       lat, long);
  //   return distance;
  // }
  // void showDistance()async{
  //   print(widget.shopDetails.);
  //   print(widget.shopDetails.customerLongitude);
  //   var dist=await calculateDistance(double.parse(widget.shopDetails.customerLatitude.toString()), double.parse(widget.shopDetails.customerLongitude.toString()));
  //   if(dist > 100){
  //     AwesomeDialog(
  //       context: context,
  //       dialogType: DialogType.INFO,
  //       animType: AnimType.BOTTOMSLIDE,
  //       title: dist.toStringAsFixed(0)+" m",
  //       desc: "Dukan ki location update karo warna fuel expense nahi milega.",
  //       btnOkText: "Update",
  //       btnCancelText: "Ok",
  //       dismissOnTouchOutside: false,
  //       btnCancelOnPress: () {
  //       },
  //       btnOkOnPress: () async{
  //         var response = await OnlineDataBase.getSingleCustomer(widget.shopDetails.customerCode);
  //         print("Response is" + response.statusCode.toString());
  //         if (response.statusCode == 200) {
  //           var data = jsonDecode(utf8.decode(response.bodyBytes));
  //           // print("Response is" + data.toString());
  //           var userDetail =  CustomerModel.fromModel(data['results'][0]);
  //           print(userDetail.editable);
  //           if(userDetail.editable == 'Y'){
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (_) => EditShopScreen(
  //                       lat: widget.lat,
  //                       long: widget.long,
  //                       shopData: widget.shopDetails,
  //                       locationdata: widget.locationdata,
  //                     )));
  //           }else{
  //             Fluttertoast.showToast(
  //                 msg: "Edit not allowed. Call to open edit shop",
  //                 toastLength: Toast.LENGTH_SHORT,
  //                 backgroundColor: Colors.black87,
  //                 textColor: Colors.white,
  //                 fontSize: 16.0);
  //             showDistance();
  //           }
  //         }
  //         else if (response.statusCode != 200) {
  //           var data = jsonDecode(utf8.decode(response.bodyBytes));
  //           setLoading(false);
  //           Fluttertoast.showToast(
  //               msg: "Internet Issue",
  //               toastLength: Toast.LENGTH_SHORT,
  //               backgroundColor: Colors.black87,
  //               textColor: Colors.white,
  //               fontSize: 16.0);
  //         }
  //       },
  //     )..show();
  //   }
  // }
  // void getAllProductData() async {
  //   try {
  //     setLoading(true);
  //     var response = await OnlineDataBase.getAllPrdouct();
  //     //print("getAllProduct: " + response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       product = [];
  //       // print("Response is" + data.toString());
  //       var datalist = data['results'];
  //       print("data is " + datalist.toString());
  //       if (datalist != null) {
  //         // if(datalist!=null) {
  //         for (var item in datalist) {
  //           //   if(item['PRICE'] != null){
  //           /*   ProductModel productt = ProductModel(
  //                 price: int.parse(item['SELLING_PRICE'].toStringAsFixed(0)),
  //                 name:item['PRODUCT'],
  //                 productCode:item['PROD_CODE']);*/
  //           product.add(ProductModel.fromJson(item));
  //           // product.add(item);
  //           //   }
  //           /*        if(item['SELLING_PRICE'] != null){
  //             ProductModel productt = ProductModel(
  //                 price: int.parse(item['SELLING_PRICE'].toStringAsFixed(0)),
  //                 name:item['PRODUCT'],
  //                 productCode:item['PROD_CODE']);
  //
  //             product.add(productt);
  //           }*/
  //           /*    else{
  //             continue;
  //           }*/
  //         }
  //         print("new data is " + product.length.toString());
  //         setLoading(false);
  //       }
  //     } else if (response.statusCode == 400) {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       setLoading(false);
  //       Fluttertoast.showToast(
  //           msg: "${data['results'].toString()}",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   } catch (e, stack) {
  //     print('exception is' + e.toString() + stack.toString());
  //     setLoading(false);
  //     Fluttertoast.showToast(
  //         msg: "Something went wrong try again letter",
  //         toastLength: Toast.LENGTH_SHORT,
  //         backgroundColor: Colors.black87,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }
  //
  // void getCustomerTransactionData() async {
  //   try {
  //     setLoading(true);
  //     var response = await OnlineDataBase.getTranactionDetails(
  //         customerCode: widget.shopDetails.customerCode);
  //     //print("Response is: "+response.statusCode.toString()+widget.shopDetails.customerCode );
  //     print("getTransactionDetails: " + response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       // print("data is"+data.toString());
  //       var datalist = data['results'];
  //       walletCapacity =
  //           double.parse(datalist[0]['CREDIT_LIMIT'].toString()) ?? 0.0;
  //       usedBalance = double.parse(datalist[0]['BALANCE'].toString()) ?? 0.0;
  //       availableBalance = walletCapacity - usedBalance;
  //       Provider.of<WalletCapacity>(context, listen: false)
  //           .setWalletCapacity(walletCapacity, usedBalance, availableBalance);
  //       setLoading(false);
  //     } else {
  //       setLoading(false);
  //       Fluttertoast.showToast(
  //           msg: "Something went wrong try again later",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   } catch (e, stack) {
  //     print('exception is' + e.toString());
  //     setLoading(false);
  //     Fluttertoast.showToast(
  //         msg: "Something went wrong try again later",
  //         toastLength: Toast.LENGTH_SHORT,
  //         backgroundColor: Colors.black87,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }
  //
  // getUser() async {
  //   var response =
  //   await OnlineDataBase.getSingleCustomer(widget.shopDetails.customerCode);
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(utf8.decode(response.bodyBytes));
  //     print(data.toString());
  //     userDetails = CustomerModel.fromModel(data['results'][0]);
  //   } else {
  //     print("User not found!!!!!");
  //     setLoading(false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // var cartData = Provider.of<CartModel>(context, listen: true).cartItemName;
    // var returncartData =
    //     Provider.of<RetrunCartModel>(context, listen: true).returncartItemName;
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text("Check In",style: TextStyle(color: Colors.white),),),
          body: SingleChildScrollView(
            child: Column(children: [
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Color(0xffE0E0E099).withOpacity(0.6),
                  )
                ], color: themeColor2),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: height * 0.08,
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset("assets/icons/person.png"),
                            // LayoutBuilder(
                            //   builder: (_, constraints) =>
                            //   //     Image.network(
                            //   //           "https://www.google.com/imgres?imgurl=https%3A%2F%2Fuxwing.com%2Fwp-content%2Fthemes%2Fuxwing%2Fdownload%2F12-peoples-avatars%2Fman-person.svg&imgrefurl=https%3A%2F%2Fuxwing.com%2Fman-person-icon%2F&tbnid=MrN-edLXXKXDuM&vet=12ahUKEwjtt_zikof4AhXP34UKHYgJA28QMygEegUIARDnAQ..i&docid=KGgvFIic4jls2M&w=787&h=800&q=person%20icon&ved=2ahUKEwjtt_zikof4AhXP34UKHYgJA28QMygEegUIARDnAQ"
                            //   //   //   widget.shopDetails.customerImage
                            //   //   //       .toString() ==
                            //   //   //       "No Image" ||
                            //   //   //       widget.shopDetails.customerImage ==
                            //   //   //           null
                            //   //   //       ? "https://i.stack.imgur.com/y9DpT.jpg"
                            //   //   //       : widget.shopDetails.customerImage
                            //   //   //       .split('{"')[1]
                            //   //   //       .split('"}')[0],
                            //   //   //   fit: BoxFit.fill, loadingBuilder:
                            //   //   //   (BuildContext context, Widget child,
                            //   //   //   ImageChunkEvent loadingProgress) {
                            //   //   // if (loadingProgress == null) return child;
                            //   //   // return Center(
                            //   //   //   child: CircularProgressIndicator(
                            //   //   //     value: loadingProgress
                            //   //   //         .expectedTotalBytes !=
                            //   //   //         null
                            //   //   //         ? loadingProgress
                            //   //   //         .cumulativeBytesLoaded /
                            //   //   //         loadingProgress.expectedTotalBytes
                            //   //   //         : null,
                            //   //   //   ),
                            //   //   // );}
                            //   // ),
                            // ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Container(
                          //width: width*0.70,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(height: height*0.0055,),
                                VariableText(
                                  text: "Hadi Autos"
                                      .toString(),
                                  //text: widget.shopDetails['name'],
                                  fontsize: 15, fontcolor: textcolorblack,
                                  weight: FontWeight.w700,
                                  fontFamily: fontRegular,
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 0.0),
                                        child: VariableText(
                                          text: "13235",
                                          // text: widget.shopDetails['address'],
                                          fontsize: 14,
                                          fontcolor: textcolorgrey,
                                          line_spacing: 1.1,
                                          textAlign: TextAlign.start,
                                          max_lines: 5,
                                          weight: FontWeight.w500,
                                          fontFamily: fontMedium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.008,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   flex: 3,
                      //   child: InkWell(
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (_) => EditShopScreen(
                      //                     lat: widget.lat,
                      //                     long: widget.long,
                      //                     shopData: widget.shopDetails,
                      //                     locationdata: widget.locationdata,
                      //                   )));
                      //     },
                      //     child: Container(
                      //       height: height * 0.045,
                      //       decoration: BoxDecoration(
                      //           color: themeColor1 /*:Color(0xff1F92F6)*/,
                      //           borderRadius: BorderRadius.circular(5)),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Center(
                      //           child: VariableText(
                      //             text: 'Edit Shop',
                      //             fontsize: 11,
                      //             fontcolor: themeColor2,
                      //             weight: FontWeight.w700,
                      //             fontFamily: fontRegular,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   height: height * 0.01,
              // ),
              // Container(
              //   height: height * 0.07,
              //   width: width,
              //   color: Color.fromARGB(80, 246, 130, 31),
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: screenpadding),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Expanded(
              //           child: Text.rich(TextSpan(
              //               text: 'Alert: ',
              //               style: TextStyle(
              //                 fontSize: 16, color: themeColor1,
              //                 fontWeight: FontWeight.w500,
              //                 fontFamily: fontMedium,
              //                 //: 2,
              //               ),
              //               children: <InlineSpan>[
              //                 TextSpan(
              //                   text:
              //                       'Clear your remaining amount to buy more favourite items. Thank you',
              //                   style: TextStyle(
              //                     fontSize: 14, color: themeColor1,
              //                     fontWeight: FontWeight.w500,
              //                     fontFamily: fontRegular,
              //                     //max_lines: 2,
              //                   ),
              //                 )
              //               ])),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenpadding),
                child: Container(
                  // height: height*0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: themeColor2,
                      boxShadow: [
                        BoxShadow(color: Color(0xff000000).withOpacity(0.25))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(
                            5,
                            246,
                            130,
                            31,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xffF6821F).withOpacity(0.25))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Row(
                              children: [
                                VariableText(
                                  text: 'Wallet Capacity: ',
                                  fontsize: 14,
                                  fontcolor: themeColor1,
                                  weight: FontWeight.w500,
                                  fontFamily: fontMedium,
                                ),
                                Spacer(),
                                VariableText(
                                  text: "Rs. " +
                                      f.format(double.parse("15000")),

                                  fontsize: 14,
                                  fontcolor: Color(0xff1F92F6),
                                  weight: FontWeight.w500,
                                  fontFamily: fontMedium,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                height: 1,
                                color: themeColor1,
                              ),
                            ),
                            Row(
                              children: [
                                VariableText(
                                  text: 'Used balance: ',
                                  fontsize: 14,
                                  fontcolor: textcolorblack,
                                  weight: FontWeight.w500,
                                  fontFamily: fontRegular,
                                ),
                                Spacer(),
                                VariableText(
                                  text:
                                  "Rs " + f.format(double.parse("15000")),

                                  fontsize: 14,
                                  fontcolor: textcolorblack,
                                  weight: FontWeight.w500,
                                  fontFamily: fontRegular,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.0075,
                            ),
                            Row(
                              children: [
                                VariableText(
                                  text: 'Available balance: ',
                                  fontsize: 14,
                                  fontcolor: textcolorblack,
                                  weight: FontWeight.w500,
                                  fontFamily: fontRegular,
                                ),
                                Spacer(),
                                VariableText(
                                  text: "Rs. " +
                                      f.format(double.parse("15000")),

                                  fontsize: 14,
                                  fontcolor: themeColor1,
                                  weight: FontWeight.w500,
                                  fontFamily: fontMedium,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenpadding),
                child: Container(
                  // height: height*0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: themeColor2,
                      boxShadow: [
                        BoxShadow(color: Color(0xff000000).withOpacity(0.25))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: CustomCheckInContainer(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => CategoriesScreen(
                                            )));
                                  },
                                  text: 'Orders',
                                  image: 'assets/icons/order.png',
                                  containerColor: Color(0xff219653),
                                )),
                            SizedBox(
                              width: height * 0.01,
                            ),
                            Expanded(
                                flex: 1,
                                child: CustomCheckInContainer(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DeliveryScreen()));
                                  },
                                  text: 'Delivery',
                                  image: 'assets/icons/delivery.png',
                                  containerColor: Color(0xff1F92F6),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: CustomCheckInContainer(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => PaymentScreen(
                                            )));
                                  },
                                  text: 'Payment',
                                  image: 'assets/icons/paymentcard.png',
                                  containerColor: Color(0xffF6821F),
                                )),
                            SizedBox(
                              width: height * 0.01,
                            ),
                            Expanded(
                                flex: 1,
                                child: CustomCheckInContainer(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => LedgerScreen()));
                                  },
                                  text: 'Ledger',
                                  image: 'assets/icons/ledger.png',
                                  containerColor: Color(0xff5D5FEF),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: CustomCheckInContainer(
                                  onTap: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.INFO,
                                      animType: AnimType.BOTTOMSLIDE,
                                      title: 'No access',
                                      btnOkOnPress: () {},
                                    )..show();
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) => ReturnScreen(
                                    //               returncartData:
                                    //                   returncartData,
                                    //               shopDetails:
                                    //                   widget.shopDetails,
                                    //               lat: widget.lat,
                                    //               long: widget.long,
                                    //               product: product,
                                    //             )));
                                  },
                                  text: 'Return',
                                  image: 'assets/icons/return.png',
                                  containerColor: Color(0xffF2C94C),
                                )),
                            SizedBox(
                              width: height * 0.01,
                            ),
                            Expanded(
                                flex: 1,
                                child: CustomCheckInContainer(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => OtherScreen()));
                                  },
                                  text: 'Others',
                                  image: 'assets/icons/other.png',
                                  containerColor: Color(0xffE91F22),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ]),
          ),
        ),
        isLoading ? Positioned.fill(child: LoadingIndicator(height: height,width: width,)) : Container(),
      ],
    );
  }

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  // void PostEmployeeVisit(
  //     {required String customerCode,
  //       required String purpose,
  //       required String lat,
  //       required String long,
  //       required CustomerModel customerData}) async {
  //   try {
  //     setLoading(true);
  //     var response = await OnlineDataBase.postEmployeeVisit(
  //         customerCode: customerCode, purpose: purpose, long: long, lat: lat);
  //     print("Response is" + response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       ;
  //       Provider.of<CartModel>(context, listen: false).clearCart();
  //       Provider.of<RetrunCartModel>(context, listen: false).retrunclearCart();
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       print("data is" + data.toString());
  //       Fluttertoast.showToast(
  //           msg: 'Check Out Successfully',
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       setLoading(false);
  //       //Navigator.pop(context);
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (_) => MainMenuScreen()));
  //     } else {
  //       setLoading(false);
  //       print("data is" + response.statusCode.toString());
  //
  //       Fluttertoast.showToast(
  //           msg: 'Some thing went wrong',
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   } catch (e, stack) {
  //     setLoading(false);
  //     print('exception is' + e.toString());
  //
  //     Fluttertoast.showToast(
  //         msg: "Something went wrong try again letter",
  //         toastLength: Toast.LENGTH_SHORT,
  //         backgroundColor: Colors.black87,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }
}
