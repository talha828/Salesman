import 'dart:convert';
import 'dart:math'as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/product_model.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/model/wallet_capacity.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/checkinScreen/checkin_screen.dart';
import 'package:shimmer/shimmer.dart';
var f = NumberFormat("###,###.0#", "en_US");
class VariableText extends StatelessWidget {
  final String text;
  final Color fontcolor;
  final TextAlign textAlign;
  final FontWeight weight;
  final bool underlined, linethrough;
  final String fontFamily;
  final double fontsize, line_spacing, letter_spacing;
  final int max_lines;
  final TextOverflow overflow;
  const VariableText({
    this.text = "A",
    this.fontcolor = Colors.black,
    this.fontsize = 15,
    this.textAlign = TextAlign.center,
    this.weight = FontWeight.normal,
    this.underlined = false,
    this.line_spacing = 1,
    this.letter_spacing = 0,
    this.max_lines = 1,
    this.fontFamily = fontRegular,
    this.overflow = TextOverflow.ellipsis,
    this.linethrough = false,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: max_lines,
      overflow: max_lines != null ? TextOverflow.ellipsis : overflow,
      textAlign: textAlign,
      style: TextStyle(
        color: fontcolor,
        fontWeight: weight,
        height: line_spacing,
        letterSpacing: letter_spacing,
        fontSize: fontsize,
        fontFamily: fontFamily,
        decorationThickness: 4.0,
        decoration: underlined
            ? TextDecoration.underline
            : (linethrough ? TextDecoration.lineThrough : TextDecoration.none),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;
  final bool enable;
  final double width;
  const LoginButton(
      {this.text = "temp",  this.onTap, this.enable = true,  this.width});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;

    double radius = 4;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: themeColor1,
          borderRadius: BorderRadius.circular(radius),
        ),
        height: 50,
        width: width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  VariableText(
                    text: text,
                    textAlign: TextAlign.center,
                    fontsize: 15,
                    fontcolor: themeColor2,
                    fontFamily: fontMedium,
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/icons/arrow_forward.png',
                    scale: 2.5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class CustomShopContainer extends StatefulWidget {
  double height, width, lat, long;
  CustomerModel customerData;
  //bool isLoading2;
  //LocationData locationData;
  Function showLoading;
  List<CustomerModel> customerList;
  CustomShopContainer(
      { this.height,
         this.width,
        this.customerData,
        this.customerList,
        //this.isLoading2,
         this.lat,
         this.long,
        //this.locationData,
         this.showLoading});

  @override
  _CustomShopContainerState createState() => _CustomShopContainerState();
}

class _CustomShopContainerState extends State<CustomShopContainer> {
  /*Location location = new Location();
  bool _serviceEnabled = false;
  LocationData _locationData;*/

   double templat, templong;
   void PostEmployeeVisit(
       {String customerCode,
         String employeeCode,
         String purpose,
         String lat,
         String long,
         CustomerModel customerData}) async {
     try {
       /*   setState(() {
      widget.isLoading2=true;
    });*/
       var response = await OnlineDatabase.postEmployee(emp_id: employeeCode, customerCode: customerCode, purpose: purpose, long: long, lat: lat);
       print("Response is" + response.statusCode.toString());
       if (response.statusCode == 200) {
        // print("data is" + response.data["message"].toString());
         //Provider.of<CartModel>(context, listen: false).createCart();
         // Location location = new Location();
         // var _location = await location.getLocation();
         Fluttertoast.showToast(
             msg: 'Check In Successfully',
             toastLength: Toast.LENGTH_SHORT,
             backgroundColor: Colors.black87,
             textColor: Colors.white,
             fontSize: 16.0);
         Provider.of<CustomerList>(context,listen: false).myCustomer(widget.customerData);
         Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (_) => CheckInScreen(
                     customerList: widget.customerList,
                     //locationdata: _locationData,
                     shopDetails: customerData,)));
       } else {
         print("data is" + response.statusCode.toString());

         Fluttertoast.showToast(
             msg: 'Some thing went wrong',
             toastLength: Toast.LENGTH_SHORT,
             backgroundColor: Colors.black87,
             textColor: Colors.white,
             fontSize: 16.0);
       }
     } catch (e, stack) {
       print('exception is' + e.toString());

       Fluttertoast.showToast(
           msg: "Error: " + e.toString(),
           toastLength: Toast.LENGTH_SHORT,
           backgroundColor: Colors.black87,
           textColor: Colors.white,
           fontSize: 16.0);
     }
   }
  /*void checkAndGetLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print("this");
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Location Denied once');
      }
    }
    _locationData = await location.getLocation();
    print("data is" + _serviceEnabled.toString());
    print("data is" + _locationData.toString());
    setState(() {
      templat = _locationData.latitude.toDouble();
      templong = _locationData.longitude.toDouble();
      print("data is" + templong.toString());
    });
  }*/

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      templat = widget.lat;
      templong = widget.long;
    });
    //print("init callling" + templat.toString());
    //print("init callling" + widget.lat.toString());
  }



  List<String> menuButton = ['DIRECTIONS', 'CHECK-IN'];
  int selectedIndex = 0;

  _onSelected(int i) {
    setState(() {
      selectedIndex = i;
    });
  }

  // getWalletStatus() async {
  //   var response2 = await OnlineDataBase.getWalletStatus();
  //   if (response2.statusCode == 200) {
  //     var data2 = jsonDecode(utf8.decode(response2.bodyBytes));
  //     print("get wallet data is" + data2.toString());
  //     Provider.of<UserModel>(context, listen: false).getWalletStatus(data2);
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: themeColor2,
          boxShadow: [BoxShadow(color: Color(0xff000000).withOpacity(0.75))]),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: widget.height * 0.0055,
                      ),
                      Container(
                        //color: Colors.red,
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              VariableText(
                                text: '${widget.customerData.customerCode}',
                                fontsize: 11,
                                fontcolor: textcolorgrey,
                                line_spacing: 1.4,
                                textAlign: TextAlign.start,
                                max_lines: 2,
                                weight: FontWeight.w500,
                                fontFamily: fontRegular,
                              ),
                              VerticalDivider(
                                color: Color(0xff000000).withOpacity(0.25),
                                thickness: 1,
                              ),
                              VariableText(
                                text: widget.customerData.customerCategory,
                                fontsize: 11,
                                fontcolor: textcolorgrey,
                                line_spacing: 1.4,
                                textAlign: TextAlign.start,
                                max_lines: 2,
                                weight: FontWeight.w500,
                                fontFamily: fontRegular,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Container(
                          height: 1,
                          width: widget.width,
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.01,
                      ),
                      VariableText(
                        text: widget.customerData.customerShopName,
                        fontsize: widget.height / widget.width * 7,
                        fontcolor: themeColor1,
                        weight: FontWeight.w700,
                        fontFamily: fontRegular,
                        textAlign: TextAlign.start,
                        max_lines: 2,
                      ),
                      SizedBox(
                        height: widget.height * 0.0075,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Container(
                          height: 1,
                          width: widget.width,
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.0075,
                      ),
                      SizedBox(
                        height: widget.height * 0.0075,
                      ),
                      InkWell(
                        onTap: () {
                          // if (widget.customerData.customerinfo.isNotEmpty) {
                          //   renderDeletePopup(context, widget.height,
                          //       widget.width, widget.customerData);
                          // } else {
                          //   Fluttertoast.showToast(
                          //       msg: "No Information found..",
                          //       toastLength: Toast.LENGTH_LONG);
                          // }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icons/home.png',
                              scale: 3.5,
                              color: Color(0xff2B2B2B),
                            ),
                            SizedBox(
                              width: widget.height * 0.01,
                            ),
                            Expanded(
                              child: VariableText(
                                text: widget.customerData.customerAddress,
                                // text:shopdetails[index].address.toString(),
                                fontsize: 11,
                                fontcolor: textcolorgrey,
                                line_spacing: 1.4,
                                textAlign: TextAlign.start,
                                max_lines: 2,
                                weight: FontWeight.w500,
                                fontFamily: fontRegular,
                              ),
                            ),
                            SizedBox(
                              width: widget.height * 0.01,
                            ),
                            Image.asset(
                              'assets/icons/more.png',
                              scale: 3,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Container(
                          height: 1,
                          width: widget.width,
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/person.png',
                            scale: 2.5,
                            color: Color(0xff2B2B2B),
                          ),
                          SizedBox(
                            width: widget.height * 0.01,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: VariableText(
                              //text: 'Muhammad Ali',
                              text: widget
                                  .customerData.customerContactPersonName
                                  .toString(),
                              // text: shopdetails[index].ownerName,
                              fontsize: 11,
                              fontcolor: textcolorgrey,
                              max_lines: 1,
                              weight: FontWeight.w500,
                              textAlign: TextAlign.start,
                              fontFamily: fontRegular,
                            ),
                          ),
                          Spacer(),
                          Spacer(),
                          Image.asset(
                            'assets/icons/contact.png',
                            scale: 2.5,
                            color: Color(0xff2B2B2B),
                          ),
                          SizedBox(
                            width: widget.height * 0.01,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: VariableText(
                              text: widget.customerData.customerContactNumber
                                  .toString(),
                              // text:shopdetails[index].ownerContact,
                              fontsize: 11,
                              fontcolor: textcolorgrey,

                              max_lines: 3,
                              weight: FontWeight.w500,
                              fontFamily: fontRegular,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Container(
                          height: 1,
                          width: widget.width,
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: 'Last Visit: ',
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: Color(0xff333333),
                                      max_lines: 1,
                                      weight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                      fontFamily: fontRegular,
                                    ),
                                    Spacer(),
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: widget.customerData.lastVisitDay.toString()=="null"?"- -":widget.customerData.lastVisitDay.toString()
                                          .toString(),
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: textcolorgrey,
                                      max_lines: 1,
                                      weight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: widget.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: 'Last Trans: ',
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: Color(0xff333333),
                                      max_lines: 1,
                                      weight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                      fontFamily: fontRegular,
                                    ),
                                    Spacer(),
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: widget.customerData.lastTransDay.toString()=="null"?"- -":widget.customerData.lastTransDay.toString()
                                          .toString(),
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: textcolorgrey,
                                      max_lines: 1,
                                      weight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Spacer(),
                          Expanded(
                            flex: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: 'Dues: ',
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: Color(0xff333333),
                                      max_lines: 1,
                                      weight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                      fontFamily: fontRegular,
                                    ),
                                    Spacer(),
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: widget.customerData.dues.toString()=="null"?"- -":f.format(double.parse(widget.customerData.dues.toString())),
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: textcolorgrey,
                                      max_lines: 1,
                                      weight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: widget.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: 'Outstanding: ',
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: Color(0xff333333),
                                      max_lines: 1,
                                      weight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                      fontFamily: fontRegular,
                                    ),
                                    Spacer(),
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: widget.customerData.outStanding.toString()=="null"?"- -":f.format(double.parse(widget.customerData.outStanding.toString())),
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: textcolorgrey,
                                      max_lines: 1,
                                      weight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Container(
                          height: 1,
                          width: widget.width,
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Row(
                          children: List.generate(menuButton.length, (index) {
                            return InkWell(
                                onTap: () async {
                                  widget.showLoading(true);
                                  _onSelected(index);
                                  if (index == 1) {
                                    if (templat == null) {
                                      Fluttertoast.showToast(
                                          msg: 'Please Enable Your Location',
                                          toastLength: Toast.LENGTH_SHORT,
                                          backgroundColor: Colors.black87,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      widget.showLoading(false);
                                      //checkAndGetLocation();
                                    } else {
                                      if(widget.customerData.shopAssigned.toString()=="Yes"){
                                        Location location = new Location();
                                        var _location = await location.getLocation();
                                       await PostEmployeeVisit(
                                            employeeCode: userData.id,
                                            customerCode: widget.customerData.customerCode,
                                            purpose: 'Check In',
                                            lat: _location.latitude.toString(),
                                            long: _location.longitude.toString(),
                                            customerData: widget.customerData);
                                      }
                                      widget.showLoading(false);

                                      // if(widget.customerData.shopAssigned == 'Yes'){
                                      //   if (double.parse(userData.usercashReceive) >=
                                      //       double.parse(userData.usercashLimit)
                                      //   // || double.parse(userData.usercashReceive) < 0
                                      //   ) {
                                      //     limitReachedPopup(
                                      //         context: context,
                                      //         height: widget.height,
                                      //         width: widget.width);

                                          ///for testing
                                          /*widget.showLoading(true);
                                    await PostEmployeeVisit(
                                        customerCode:
                                            widget.customerData.customerCode,
                                        purpose: 'Check In',
                                        lat: templat.toString(),
                                        long: templong.toString(),
                                        customerData: widget.customerData);
                                    widget.showLoading(false);*/
                                        // } else {

                                        //   //TODO:// set check-in api
                                        //   // widget.showLoading(true);
                                        //   // await PostEmployeeVisit(
                                        //   //     customerCode:
                                        //   //     widget.customerData.customerCode,
                                        //   //     purpose: 'Check In',
                                        //   //     lat: templat.toString(),
                                        //   //     long: templong.toString(),
                                        //   //     customerData: widget.customerData);
                                        //   // widget.showLoading(false);
                                        // }
                                      // }
                                    }
                                  } else if (index == 0) {
                                    ///Launch Map
                                    if (widget.customerData.customerLatitude ==
                                        null) {
                                      Fluttertoast.showToast(
                                          msg: "Shop location not found",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 3,
                                          backgroundColor: Colors.black87,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      if (await MapLauncher.isMapAvailable(
                                          MapType.google)) {
                                        await MapLauncher.showMarker(
                                          mapType: MapType.google,
                                          coords: Coords(
                                              widget.customerData.customerLatitude,
                                              widget
                                                  .customerData.customerLongitude),
                                          title:
                                          widget.customerData.customerShopName,
                                          description:
                                          widget.customerData.customerAddress,
                                        );
                                      }
                                      widget.showLoading(false);
                                    }
                                  }
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: widget.height * 0.05,
                                      width: widget.width * 0.38,
                                      decoration: BoxDecoration(
                                          color: index == 0
                                              ? themeColor1
                                              : themeColor2,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                              color: index == 0 ?
                                              themeColor1
                                                  : widget.customerData.shopAssigned == 'Yes' ? themeColor1 : Colors.grey[400]
                                          )),
                                      child: Center(
                                        child: VariableText(
                                          text: menuButton[index],
                                          fontsize: 11,
                                          fontcolor: index == 0
                                              ? themeColor2
                                              : widget.customerData.shopAssigned == 'Yes' ? themeColor1 : Colors.grey[400],
                                          weight: FontWeight.w700,
                                          fontFamily: fontRegular,
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          }))
                    ],
                  ),
                ),
              ),
            ),
            /*  Container(
              height: widget.height * 0.14,
              width: widget.width * 0.28,
              */ /*          decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.customerData.customerImage.toString()=="No Image"?"https://i.stack.imgur.com/y9DpT.jpg":widget.customerData.customerImage.split('{"')[1].split('"}')[0]),
                   // image: AssetImage('assets/images/shop1.jpg'),
                    fit: BoxFit.fill,

                ),
                // color: Colors.red,
                borderRadius: BorderRadius.circular(5),

              ),*/ /*
              child: Image.network(widget.customerData.customerImage.toString()=="No Image"?"https://i.stack.imgur.com/y9DpT.jpg":widget.customerData.customerImage.split('{"')[1].split('"}')[0],
                 fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
                */ /*
                 Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                child: Container(
                  height: widget.height * 0.14,
                  width: widget.width * 0.28,
                 color: Colors.red,
                ),)*/ /*
              }),
            ),*/
          ],
        ),
      ),
    );

    ///old ui
    /*  return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: themeColor2,
          boxShadow: [BoxShadow(color: Color(0xff000000).withOpacity(0.25))]),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
         Expanded(child:   Container(
           //height: height*0.15,
           // width: widget.width * 0.85,
           //color: Colors.red,
           child: Padding(
             padding: EdgeInsets.only(left: 8.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(
                   height: widget.height * 0.0055,
                 ),
                 VariableText(
                   text: widget.customerData.customerShopName,
                   fontsize: widget.height / widget.width * 7,
                   fontcolor: themeColor1,
                   weight: FontWeight.w700,
                   fontFamily: fontRegular,
                   textAlign: TextAlign.start,
                   max_lines: 2,
                 ),
                 SizedBox(
                   height: widget.height * 0.0075,
                 ),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Image.asset(
                       'assets/icons/home.png',
                       scale: 3.5,
                       color: Color(0xff2B2B2B),
                     ),
                     SizedBox(
                       width: widget.height * 0.01,
                     ),
                     Expanded(
                       child: VariableText(
                         text: widget.customerData.customerAddress,
                         // text:shopdetails[index].address.toString(),
                         fontsize: 11,
                         fontcolor: textcolorgrey,
                         line_spacing: 1.4,
                         textAlign: TextAlign.start,
                         max_lines: 2,
                         weight: FontWeight.w500,
                         fontFamily: fontRegular,
                       ),
                     ),
                   ],
                 ),
                 SizedBox(
                   height: widget.height * 0.008,
                 ),
                 Padding(
                   padding: EdgeInsets.only(right: 0.0),
                   child: Container(
                     height: 1,
                     width: widget.width,
                     color: Color(0xffE0E0E0),
                   ),
                 ),
                 SizedBox(
                   height: widget.height * 0.008,
                 ),
                 Row(
                   children: [
                     Expanded(
                       flex: 12,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Image.asset(
                                 'assets/icons/person.png',
                                 scale: 2.5,
                                 color: Color(0xff2B2B2B),
                               ),
                               SizedBox(
                                 width: widget.height * 0.01,
                               ),
                               Expanded(
                                 //width:width*0.10,
                                 child: Padding(
                                   padding: EdgeInsets.only(top: 4.0),
                                   child: VariableText(
                                     //text: 'Muhammad Ali',
                                     text: widget.customerData
                                         .customerContactPersonName
                                         .toString(),
                                     // text: shopdetails[index].ownerName,
                                     fontsize: 11,
                                     fontcolor: textcolorgrey,
                                     max_lines: 1,
                                     weight: FontWeight.w500,
                                     textAlign: TextAlign.start,
                                     fontFamily: fontRegular,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(
                             height: widget.height * 0.01,
                           ),
                           Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Image.asset(
                                 'assets/icons/contact.png',
                                 scale: 2.5,
                                 color: Color(0xff2B2B2B),
                               ),
                               SizedBox(
                                 width: widget.height * 0.01,
                               ),
                               Padding(
                                 padding: EdgeInsets.only(top: 2.0),
                                 child: VariableText(
                                   text: widget
                                       .customerData.customerContactNumber
                                       .toString(),
                                   // text:shopdetails[index].ownerContact,
                                   fontsize: 11,
                                   fontcolor: textcolorgrey,

                                   max_lines: 3,
                                   weight: FontWeight.w500,
                                   fontFamily: fontRegular,
                                 ),
                               ),
                             ],
                           ),
                         ],
                       ),
                     ),
                     // Spacer(),
                     Expanded(
                       flex: 7,
                       child: Padding(
                         padding: const EdgeInsets.only(top: 12.0, right: 8),
                         child: InkWell(
                           onTap: () async {
                             //PostEmployeeVisit(customerCode:widget.customerData.customerCode,purpose: 'Check In',lat: widget.lat.toString(),long: widget.long.toString(),customerData:widget.customerData );
                             if (templat == null) {
                               print("lat log in" +
                                   templong.toString() +
                                   templat.toString());
                               Fluttertoast.showToast(
                                   msg: 'Please Enable Your Location',
                                   toastLength: Toast.LENGTH_SHORT,
                                   backgroundColor: Colors.black87,
                                   textColor: Colors.white,
                                   fontSize: 16.0);
                               checkAndGetLocation();
                             } else {
                               if(int.parse(userData.usercashReceive)>=int.parse(userData.usercashLimit)  ||int.parse(userData.usercashReceive)<0 ){
                                 limitReachedPopup(context:context,height:widget.height,width:widget.width);
*/ /*
                                 ///for testing
                                 widget.showLoading(true);
                                 await PostEmployeeVisit(
                                     customerCode:
                                     widget.customerData.customerCode,
                                     purpose: 'Check In',
                                     lat: templat.toString(),
                                     long: templong.toString(),
                                     customerData: widget.customerData);
                                 widget.showLoading(false);*/ /*
                               }
                           else{
                                 widget.showLoading(true);
                                 await PostEmployeeVisit(
                                     customerCode:
                                     widget.customerData.customerCode,
                                     purpose: 'Check In',
                                     lat: templat.toString(),
                                     long: templong.toString(),
                                     customerData: widget.customerData);
                                 widget.showLoading(false);
                               }
                             }
                           },
                           child: Container(
                             height: widget.height * 0.035,
                             width: widget.width * 0.22,
                             decoration: BoxDecoration(
                                 color: themeColor1 */ /*:Color(0xff1F92F6)*/ /*,
                                 borderRadius: BorderRadius.circular(5)),
                             child: Center(
                               child: VariableText(
                                 text: 'Check In',
                                 fontsize: 11,
                                 fontcolor: themeColor2,
                                 weight: FontWeight.w700,
                                 fontFamily: fontRegular,
                               ),
                             ),
                           ),
                         ),
                       ),
                     )
                   ],
                 )
               ],
             ),
           ),
         ),),
          */ /*  Container(
              height: widget.height * 0.14,
              width: widget.width * 0.28,
              */ /**/ /*          decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.customerData.customerImage.toString()=="No Image"?"https://i.stack.imgur.com/y9DpT.jpg":widget.customerData.customerImage.split('{"')[1].split('"}')[0]),
                   // image: AssetImage('assets/images/shop1.jpg'),
                    fit: BoxFit.fill,

                ),
                // color: Colors.red,
                borderRadius: BorderRadius.circular(5),

              ),*/ /**/ /*
              child: Image.network(widget.customerData.customerImage.toString()=="No Image"?"https://i.stack.imgur.com/y9DpT.jpg":widget.customerData.customerImage.split('{"')[1].split('"}')[0],
                 fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
                */ /**/ /*
                 Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                child: Container(
                  height: widget.height * 0.14,
                  width: widget.width * 0.28,
                 color: Colors.red,
                ),)*/ /**/ /*
              }),
            ),*/ /*
          ],
        ),
      ),
    );*/
  }

  // limitReachedPopup({BuildContext context, double height, double width}) {
  //   AwesomeDialog(
  //       context: context,
  //       //dismissOnTouchOutside: false,
  //       animType: AnimType.SCALE,
  //       dialogType: DialogType.WARNING,
  //       btnOkColor: themeColor1,
  //       showCloseIcon: true,
  //       btnOkText: "OK",
  //       closeIcon: Icon(Icons.close),
  //       btnOkOnPress: () {
  //         print("ok tap");
  //         // Navigator.pop(context);
  //       },
  //       body: StatefulBuilder(builder: (context, setState) {
  //         return Container(
  //           width: width,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Column(
  //             children: [
  //               VariableText(
  //                 text: "Your Limit is Reached",
  //                 fontsize: 14,
  //                 fontcolor: textcolorblack,
  //                 weight: FontWeight.w500,
  //                 fontFamily: fontMedium,
  //               ),
  //               // SizedBox(height: height*0.02,),
  //             ],
  //           ),
  //         );
  //       }))
  //     ..show();
  // }
  //
  // void PostEmployeeVisit(
  //     {String customerCode,
  //       String purpose,
  //       String lat,
  //       String long,
  //       CustomerModel customerData}) async {
  //   try {
  //     /*   setState(() {
  //     widget.isLoading2=true;
  //   });*/
  //     var response = await OnlineDataBase.postEmployeeVisit(
  //         customerCode: customerCode, purpose: purpose, long: long, lat: lat);
  //     print("Response is" + response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       print("data is" + data.toString());
  //       Fluttertoast.showToast(
  //           msg: 'Check In Successfully',
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       //Provider.of<CartModel>(context, listen: false).createCart();
  //       Provider.of<RetrunCartModel>(context, listen: false).retruncreateCart();
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (_) => CheckInScreen(
  //                   customerList: widget.customerList,
  //                   //locationdata: _locationData,
  //                   shopDetails: customerData,
  //                   long: templong,
  //                   lat: templat))).then((value) {
  //         initPage();
  //       });
  //     } else {
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
class DrawerList extends StatelessWidget {
  final String text;
  void Function()  onTap;
  final String imageSource;
  final bool selected;

   DrawerList({
     this.imageSource,
     this.text,
     this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenpadding),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              height: height * 0.07,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: selected ? Color(0xffFFEEE0) : Color(0xffFCFCFC)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              //alignment: Alignment.center,
                              child: Image.asset(
                                imageSource,
                                scale: 2.6,
                                color: selected ? themeColor1 : textcolorgrey,
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 5,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                              const EdgeInsets.only(top: 10.0, left: 4),
                              child: VariableText(
                                text: text,
                                textAlign: TextAlign.start,
                                fontsize: 15,
                                weight: FontWeight.w400,
                                fontFamily: fontRegular,
                                fontcolor:
                                selected ? themeColor1 : Color(0xFF555555),
                              ),
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
          //SizedBox(height: height*0.0055,)
        ],
      ),
    );
  }
}
class CustomCheckInContainer extends StatelessWidget {

  Color containerColor;
  String text, image;
  final void Function() onTap;
  CustomCheckInContainer(
      { this.containerColor,  this.text,  this.image,  this.onTap});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height * 0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: containerColor.withOpacity(0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              scale: 3.5,
            ),
            VariableText(
              text: text,
              fontsize: 15,
              fontcolor: textcolorblack,
              weight: FontWeight.w500,
              fontFamily: fontMedium,
            ),
          ],
        ),
      ),
    );
  }
}
Widget customShopDetailsContainer(
    { double height,
       double width,
       String address,
       String shopname,
       String imageurl}) {
  return Container(
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
                //color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset("assets/icons/person.png",color: textcolorlightgrey2,)
                // LayoutBuilder(
                //   builder: (_, constraints) => Image.network(
                //       imageurl.toString() == "No Image" || imageurl == null
                //           ? "https://i.stack.imgur.com/y9DpT.jpg"
                //           : imageurl.split('{"')[1].split('"}')[0],
                //       fit: BoxFit.fill, loadingBuilder: (BuildContext context,
                //       Widget child, ImageChunkEvent loadingProgress) {
                //     if (loadingProgress == null) return child;
                //     return Center(
                //       child: CircularProgressIndicator(
                //         value: loadingProgress.expectedTotalBytes != null
                //             ? loadingProgress.cumulativeBytesLoaded /
                //             loadingProgress.expectedTotalBytes
                //             : null,
                //       ),
                //     );
                //   }),
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
                      text: shopname,
                      fontsize: 15,
                      fontcolor: textcolorblack,
                      weight: FontWeight.w700,
                      fontFamily: fontRegular,
                    ),
                    SizedBox(
                      height: height * 0.005,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: VariableText(
                              text: address,//TODO (((((((((((((((((((((((((((((((((
                              //text: widget.shopDetails.customerAddress,
                              fontsize: 11, fontcolor: textcolorgrey,
                              line_spacing: 1.1,
                              textAlign: TextAlign.start,
                              max_lines: 5,
                              weight: FontWeight.w500,
                              fontFamily: fontRegular,
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
        ],
      ),
    ),
  );
  
}
class ProcessLoadingWhite extends StatefulWidget {
  @override
  State createState() {
    return _ProcessLoadingWhiteState();
  }
}

class _ProcessLoadingWhiteState extends State<ProcessLoadingWhite>
    with SingleTickerProviderStateMixin {
  AnimationController _cont;
  Animation<Color> _anim;

  @override
  void initState() {
    _cont = AnimationController(
        duration: Duration(
          seconds: 1,
        ),
        vsync: this);
    _cont.addListener(() {
      setState(() {
        //print("val: "+_cont.value.toString());
      });
    });
    ColorTween col = ColorTween(begin: Color(0xffFBC69A), end: themeColor1);
    _anim = col.animate(_cont);
    _cont.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(0, 0, 0, 0),
        child: Center(
          child: Container(
              width: 50 * _cont.value,
              height: 50 * _cont.value,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  _anim.value,
                ),
              )),
        ));
  }
}
class CustomLegerContainer extends StatelessWidget {
  double height, width;
  String title, imagePath;
  bool selectedValue;
  void Function() onTap;
  CustomLegerContainer(
      { this.height,
         this.width,
         this.title,
         this.imagePath,
         this.selectedValue,
         this.onTap});

  @override
  Widget build(BuildContext context) {
    double sizedboxvalue = 0.02;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height * 0.13,
        decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(5),
            //border: Border.all(color: Color(0xffC0C0C0)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xffC0C0C0), offset: Offset(0, 0), blurRadius: 1)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              scale: 3.2,
              color: selectedValue == true ? textcolorgrey : textcolorlightgrey,
            ),
            SizedBox(
              height: height * sizedboxvalue / 2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: VariableText(
                text: title,
                fontsize: 13,
                fontcolor:
                selectedValue == true ? textcolorblack : textcolorlightgrey,
                weight: FontWeight.w500,
                fontFamily: fontRegular,
                max_lines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class DashedRect extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRect(
      {this.color = Colors.black, this.strokeWidth = 1.0, this.gap = 5.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(strokeWidth / 2),
        child: CustomPaint(
          painter:
          DashRectPainter(color: color, strokeWidth: strokeWidth, gap: gap),
        ),
      ),
    );
  }
}
class DashRectPainter extends CustomPainter {
  double strokeWidth;
  Color color;
  double gap;

  DashRectPainter(
      {this.strokeWidth = 5.0, this.color = Colors.red, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path _topPath = getDashedPath(
      a: math.Point(0, 0),
      b: math.Point(x, 0),
      gap: gap,
    );

    Path _rightPath = getDashedPath(
      a: math.Point(x, 0),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _bottomPath = getDashedPath(
      a: math.Point(0, y),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _leftPath = getDashedPath(
      a: math.Point(0, 0),
      b: math.Point(0.001, y),
      gap: gap,
    );

    canvas.drawPath(_topPath, dashedPaint);
    canvas.drawPath(_rightPath, dashedPaint);
    canvas.drawPath(_bottomPath, dashedPaint);
    canvas.drawPath(_leftPath, dashedPaint);
  }

  Path getDashedPath({
     math.Point<double> a,
     math.Point<double> b,
    @required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(double.parse(currentPoint.x.toString()), double.parse(currentPoint.y.toString()))
          : path.moveTo(double.parse(currentPoint.x.toString()), double.parse(currentPoint.y.toString()));
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class RectangluartextFeild extends StatelessWidget {
  final String text;
  final bool enable, obscureText;
  final Function(String) onChanged;
  final TextEditingController cont;
  final String hinttext;

  //FieldIcon icon;
  final bool texthidden, readonly, expands;
  final double radius;
  final String fontFamily;

  final TextInputType keytype;

  // final FocusNode focusNode;

  final Color color, containerColor, bordercolor;
  final Color hintTextColor;
  final int length;
  final int textlength;
  final bool enableborder;

  //final Array inputFormatter;
  final void Function(String) onSubmit;

  final double fontsize;
  final String obscuringCharacter;

  const RectangluartextFeild({
    this.textlength = 20,
    this.text = "temp",
    this.enable = true,
    this.enableborder = true,
     this.onChanged,
    this.obscureText = false,
    this.keytype = TextInputType.text,
    this.color = themeColor2,
    this.hintTextColor = hinttextColor,
    this.hinttext = "temp",
    this.bordercolor = feildBorderColor,
    this.containerColor = feildContainerColor,
     this.cont,
     this.onSubmit,
    this.texthidden = false,
    this.readonly = false,
    this.expands = false,
    this.fontFamily = fontRegular,
    this.radius = 0,
    this.length = 5,
    this.obscuringCharacter = "*",
    this.fontsize = 14,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    double radius = 10;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: containerColor,
          // border: Border.all(color: enableborder?bordercolor:Colors.transparent)
        ),
        height: height * 0.065,
        child: TextFormField(
          enabled: enable,
          inputFormatters: [
            LengthLimitingTextInputFormatter(textlength),
          ],
          obscureText: obscureText,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontFamily: fontRegular,
              color: textcolorblack),
          onChanged: onChanged,
          controller: cont,
          onFieldSubmitted: onSubmit,
          keyboardType: keytype,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Number';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            suffixIcon: Image.asset(
              'assets/icons/search.png',
              scale: 3,
            ),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: enableborder ? bordercolor : Color(0xffEEEEEE))),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: enableborder ? bordercolor : Color(0xffEEEEEE))),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            hintText: hinttext,
            contentPadding: EdgeInsets.only(top: 15, bottom: 0, left: 14),
            hintStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: fontRegular,
                color: hintTextColor),
          ),
        ));
  }
}
class SingleProductTile extends StatefulWidget {
  final ProductModel productDetails;
  final String subCatName;
  final String featured;
  Function ontap;
  bool fromfeauteredPoduct;
  int favIndex;
  bool addedToCart;
  Function onquantityUpdate;
  Function onRemove;

  SingleProductTile(
      {this.productDetails,
        this.fromfeauteredPoduct = false,
        this.onquantityUpdate,
        this.addedToCart,
        this.ontap,
        this.subCatName,
        this.featured,
        this.onRemove,
        this.favIndex = -1});

  @override
  _SingleProductTileState createState() => _SingleProductTileState();
}

class _SingleProductTileState extends State<SingleProductTile> {
  bool isFav = false;
  TextEditingController itemCount = new TextEditingController(text: '1');
  int count = 1;

  toggleFav() {
    if (isFav == true) {
      setState(() {
        isFav = false;
      });
    } else {
      setState(() {
        isFav = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var tempCart = Provider.of<CartModel>(context, listen: false).cartItemName;
    for (var item in tempCart) {
      if (item.productName.productCode == widget.productDetails.productCode) {
        count = item.itemCount;
        itemCount.text = item.itemCount.toString();
        break;
      }
    }
  }
  var f = NumberFormat("###,###.0#", "en_US");
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    double ratio = height / width;
    return Container(
      //height:height * 0.31,
        width: width,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          )
        ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // color: themeColor1,
                        ),
                        child: widget.productDetails.imageUrl != null
                            ? InkWell(
                          onTap: (){
                            Image _img = Image.network(
                              widget.productDetails.imageUrl,
                              cacheHeight: 100,
                              cacheWidth: 100,
                            );
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                barrierColor: true ? Colors.black : Colors.white,
                                pageBuilder: (BuildContext context, _, __) {
                                  return FullScreenPage(
                                    child: widget.productDetails.imageUrl.toString(),
                                    dark: false,
                                  );
                                },
                              ),
                            );
                          },
                          child: Image.network(
                            widget.productDetails.imageUrl,
                            fit: BoxFit.scaleDown,
                            cacheWidth: 100,
                            cacheHeight: 140,
                            filterQuality: FilterQuality.low,
                            errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                              return Image.asset("assets/images/gear.png");
                            },
                            loadingBuilder: (BuildContext context,
                                Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                            : Image.asset("assets/images/placeHolder.png"),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      widget.addedToCart
                          ? Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                if (count > 1) {
                                  setState(() {
                                    count--;
                                    itemCount.text = count.toString();
                                  });
                                  widget.onquantityUpdate(count);
                                }else{
                                  widget.onRemove();
                                }
                              },
                              child: Container(
                                height: ratio * 16,
                                width: ratio * 16,
                                decoration: BoxDecoration(
                                  color: Color(0xffF1F1F1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.remove,
                                      color: Color(0xff828282),
                                      size: 18,
                                    )),
                              ),
                            ),
                            Container(
                              height: ratio * 19,
                              width: ratio * 13,
                              //color: Colors.red,
                              child: TextField(
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                controller: itemCount,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onChanged: (v) {
                                  setState(() {
                                    count = int.parse(v);
                                  });
                                  widget.onquantityUpdate(count);
                                },
                                decoration: InputDecoration(
                                  hintText: count.toString(),
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff333333),
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (count > 0) {
                                  setState(() {
                                    count++;
                                    itemCount.text = count.toString();
                                    //subtotal=(count*int.parse(widget.productData.price.split('.')[0]));
                                  });
                                  widget.onquantityUpdate(count);
                                }
                              },
                              child: Container(
                                height: ratio * 16,
                                width: ratio * 16,
                                decoration: BoxDecoration(
                                    color: themeColor1,
                                    borderRadius:
                                    BorderRadius.circular(5)),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.add,
                                      color: themeColor2,
                                      size: 18,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )
                          : InkWell(
                        onTap: () {
                          if (widget.productDetails.outOfStock == 'N') {
                            widget.ontap();
                          }
                        },
                        child: Container(
                          height: height * 0.05,
                          width: width,
                          decoration: BoxDecoration(
                              color:
                              widget.productDetails.outOfStock == 'Y'
                                  ? Colors.grey
                                  : themeColor1,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: VariableText(
                              text:
                              widget.productDetails.outOfStock == 'Y'
                                  ? 'Out of stock'
                                  : 'Add To Cart',
                              fontcolor: themeColor2,
                              fontsize: 14,
                              weight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 14,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VariableText(
                          text: 'Code : ${widget.productDetails.productCode}',
                          fontsize: 12,
                          fontFamily: fontRegular,
                          fontcolor: Color(0xff333333),
                          weight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: height * 0.0095,
                        ),
                        VariableText(
                          text: widget.productDetails.name,
                          fontsize: 13,
                          max_lines: 3,
                          textAlign: TextAlign.start,
                          line_spacing: 1.2,
                          fontFamily: fontRegular,
                          fontcolor: Color(0xff333333),
                          weight: FontWeight.w500,
                        ),
                        if (widget.productDetails.brand != null)
                          SizedBox(
                            height: height * 0.0055,
                          ),
                        if (widget.productDetails.brand != null)
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: widget.productDetails.brand,
                                style: TextStyle(
                                    color: themeColor1,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: fontRegular,
                                    fontSize: 11)),
                            //TextSpan(text: '(2021 Model) ',style: TextStyle(color:Color(0xff828282),fontFamily: fontRegular,fontSize: 9 )),
                          ])),
                        SizedBox(
                          height: height * 0.0055,
                        ),
                        if (widget.productDetails.model != null)
                          VariableText(
                              text: widget.productDetails.model,
                              fontsize: 10,
                              max_lines: 6,
                              weight: FontWeight.w400,
                              fontcolor: Color(0xff4F4F4F),
                              textAlign: TextAlign.start,
                              line_spacing: 1.3),
                        if (widget.productDetails.model != null)
                          SizedBox(
                            height: height * 0.0055,
                          ),
                        if (widget.productDetails.productDescription != null)
                          VariableText(
                              fontsize: 10,
                              max_lines: 6,
                              weight: FontWeight.w400,
                              fontcolor: Color(0xff4F4F4F),
                              textAlign: TextAlign.start,
                              line_spacing: 1.3,
                              text: widget.productDetails.productDescription),
                        if (widget.productDetails.productDescription != null)
                          SizedBox(
                            height: height * 0.01,
                          ),
                        VariableText(
                          text: 'Offers',
                          fontsize: 12,
                          fontFamily: fontRegular,
                          fontcolor: Color(0xff333333),
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: height * 0.0055,
                        ),
                        Row(
                          children: [
                            Container(
                              width: width * 0.25,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:widget.productDetails.productPrice.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        VariableText(
                                          text:
                                          'Qty ${widget.productDetails.productPrice[index].min}+ : Rs. ${ f.format(double.parse(widget.productDetails.productPrice[index].price.toString()))}',

                                          fontsize: 9,
                                          fontFamily: fontRegular,
                                          fontcolor: Color(0xff828282),
                                          weight: FontWeight.w400,
                                        ),
                                        SizedBox(
                                          height: height * 0.0055,
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            Container(
                              width: width * 0.20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  VariableText(
                                    text: 'Total Value',
                                    fontsize: 12,
                                    fontFamily: fontRegular,
                                    fontcolor: Color(0xff828282),
                                    weight: FontWeight.w500,
                                  ),
                                  SizedBox(
                                    height: height * 0.0055,
                                  ),
                                  VariableText(
                                    text:
                                    'Rs. ${f.format(double.parse((count * calculatePrice(quantity: count, productDetils: widget.productDetails)).toString()))}',

                                    fontsize: 14,
                                    max_lines: 3,
                                    fontFamily: fontRegular,
                                    fontcolor: themeColor1,
                                    weight: FontWeight.w500,
                                  ),
                                  SizedBox(
                                    height: height * 0.0055,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ));

    /*return GestureDetector(
      onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetailPage(productData:widget.productDetails,)));
      },
      child: Container(
        height:widget.fromfeauteredPoduct?height*0.23: height * 0.30,
        width:widget.fromfeauteredPoduct? width * 0.35:width*0.42,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1),

              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //SizedBox(height: height * 0.030,),

            Padding(
              padding:widget.fromfeauteredPoduct?   EdgeInsets.all(0):EdgeInsets.all(8),
              child: Container(
                height:widget.fromfeauteredPoduct?height*0.16: height * 0.18,
                width:widget.fromfeauteredPoduct? width * 0.35:width*0.42,


                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: new DecorationImage(
                      fit: BoxFit.cover,

                      image: AssetImage(widget.productDetails.image)
                  ),
                ),
                child: Stack(
                  children: [

                    widget.fromfeauteredPoduct? Container():Align(
                      alignment: Alignment.topRight,
                      child: Bounce(
                        duration: Duration(milliseconds: 100),
                        onPressed: (){
                          toggleFav();
                        },
                        child: Container(
                          height: 14 * ratio,
                          width: 14 * ratio,
                          margin: EdgeInsets.only(top: width * 0.02, right: width * 0.02),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(246, 130, 31, 0.6),
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Align(
                              alignment: Alignment.center,
                              child: isFav == true ? Icon(Icons.favorite, color: Colors.red, size: 9 * ratio,) : Icon(Icons.favorite_border_outlined, size: 9 * ratio,color: Colors.white,)
                          ),
                        ),
                      ),
                    ),
                    widget.fromfeauteredPoduct? Container():Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 16 * ratio,
                        width: 16 * ratio,
                        margin: EdgeInsets.only(right: width * 0.02, bottom: width * 0.02),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(246, 130, 31, 0.6),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child:

                          Image.asset(
                            'assets/icons/ic_itemCart2.png', //ic_productCart
                            scale: 3.2,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: height * 0.01,top:widget.fromfeauteredPoduct? height*0.01:0),
              child: VariableText(
                text: widget.productDetails.name,
                fontsize: 13,
                fontFamily: fontRegular,
                fontcolor: textcolorblack15,
                weight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: height * 0.01,top: height*0.0055),
              child: VariableText(text:'RS. '+ widget.productDetails.price.toString(),
                fontcolor:widget.fromfeauteredPoduct?themeColor1:Color(0xff828282),
                fontsize: 12, weight: FontWeight.w400,),
            ),
            widget.fromfeauteredPoduct?
            Container():
            Padding(
                padding: EdgeInsets.only(left: height * 0.01,top: height*0.01,right: height*0.01),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context,NoAnimationRoute(widget: CartScreen()));
                  },
                  child: Container(
                    height: height*0.04,
                    width: width,
                    decoration: BoxDecoration(
                      color: themeColor1,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child:Center(
                      child: VariableText(text:'Add To Cart',
                        fontcolor:themeColor2,
                        fontsize: 14, weight: FontWeight.w400,),
                    )
                    ,
                  ),
                ) )


          ],
        ),
      ),
    );*/
  }

  static double calculatePrice({int quantity, ProductModel productDetils}) {
    double dynamicprice = double.parse(productDetils.productPrice.last.price.toStringAsFixed(2));
    for (var item in productDetils.productPrice) {
      if (item.min <= quantity && item.max >= quantity) {
        dynamicprice = double.parse(item.price.toStringAsFixed(2));
      }
    }
    print(dynamicprice.toString());
    return double.parse(dynamicprice.toString());
  }
}

class FullScreenPage extends StatefulWidget {
  FullScreenPage({
     this.child,
     this.dark,
  });

   String child;
   bool dark;

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  @override
  void initState() {
    var brightness = widget.dark ? Brightness.light : Brightness.dark;
    var color = widget.dark ? Colors.black12 : Colors.white70;
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // Restore your settings here...
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.dark ? Colors.black : Colors.white,
        body: Stack(
          children: [
            Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 333),
                  curve: Curves.fastOutSlowIn,
                  top: 0,
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4,
                    child: Image.network(widget.child,
                      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                        return Image.asset("assets/images/gear.png");
                      },
                      loadingBuilder: (BuildContext context,
                          Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: MaterialButton(
                  padding: const EdgeInsets.all(10),
                  elevation: 0,
                  child: Icon(
                    Icons.arrow_back,
                    color: widget.dark ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  color: widget.dark ? Colors.black12 : Colors.white70,
                  highlightElevation: 0,
                  minWidth: double.minPositive,
                  height: double.minPositive,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class RectangluartextFeildWithPrefix extends StatelessWidget {
  final String text;
  final bool enable, obscureText, showprefix;
  final Function(String) onChanged;
  final TextEditingController cont;
  final String hinttext;

  //FieldIcon icon;
  final bool texthidden, readonly, expands;
  final double radius;
  final String fontFamily;

  final TextInputType keytype;

  // final FocusNode focusNode;

  final Color color, containerColor, bordercolor;
  final int length;
  final int textlength;
  final bool enableborder;

  //final Array inputFormatter;
  final Function(String) onSubmit;

  final double fontsize;
  final String obscuringCharacter;

  const RectangluartextFeildWithPrefix({
    this.textlength = 20,
    this.text = "temp",
    this.enable = true,
    this.enableborder = true,
    this.showprefix = false,
     this.onChanged,
    this.obscureText = false,
    this.keytype = TextInputType.text,
    this.color = themeColor2,
    this.hinttext = "temp",
    this.bordercolor = feildBorderColor,
    this.containerColor = feildContainerColor,
     this.cont,
     this.onSubmit,
    this.texthidden = false,
    this.readonly = false,
    this.expands = false,
    this.fontFamily = fontRegular,
    this.radius = 0,
    this.length = 5,
    this.obscuringCharacter = "*",
    this.fontsize = 14,
  });

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    double radius = 10;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: containerColor,
          // border: Border.all(color: enableborder?bordercolor:Colors.transparent)
        ),
        height: height * 0.065,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          enabled: enable,
          inputFormatters: [
            LengthLimitingTextInputFormatter(textlength),
          ],
          obscureText: obscureText,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontFamily: fontLight,
              color: textcolorblack),
          onChanged: onChanged,
          controller: cont,
          onFieldSubmitted: onSubmit,
          keyboardType: keytype,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Number';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: enableborder ? bordercolor : Color(0xffEEEEEE))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: enableborder ? bordercolor : Color(0xffEEEEEE))),
              focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              hintText: hinttext,
              contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 0),
              hintStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontRegular,
                  color: Color(
                    0xffB2B2B2,
                  )),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 6, top: 15),
                child: Text(
                  '  +92',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: fontRegular,
                      color: textcolorblack),
                ),
              )),
        ));
  }
}
class CodeField extends StatelessWidget{

  final TextEditingController cont,next_cont;
  final String hinttext;
  // final Widget icon;
  final bool texthidden,readonly;
  final TextAlign textAlign;
  Function onComplete;

  CodeField({this.cont,this.hinttext,this.texthidden=false,this.readonly=false,
    //this.icon,
    this.onComplete,
    this.next_cont, this.textAlign=TextAlign.center,});

  @override
  Widget build(BuildContext context) {

    double radius=10;

    return TextField(
      onChanged: (x){
        print("onchange");
        if(cont.text.isNotEmpty){
          FocusScope.of(context).nextFocus();
        }else{
          FocusScope.of(context).previousFocus();
        }
        if(next_cont!=null) {
          next_cont.text = "";
        }
        onComplete(x);
      },
      controller: cont,
      maxLength: 1,
      obscureText: texthidden,
      readOnly: readonly,
      textAlign: textAlign,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 18,//fontFamily: fontNormal
      ),
      decoration: InputDecoration(counterText: "",
        contentPadding: EdgeInsets.only(top: 10,bottom: 10,left: 2),
        border: OutlineInputBorder(

            borderRadius: BorderRadius.circular(radius)
        ),
        enabledBorder:OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE0E0E0),
                width: 1),
            borderRadius: BorderRadius.circular(radius)
        ),
        fillColor: Colors.white,
        // fillColor: Colors.black,
        filled: true,
        hintText: hinttext,
      ),
    );
  }
}
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  String title;
  Color color, color2;
  Function ontap;

  MyAppBar(
      {this.title,
        this.ontap,
        this.color = themeColor2,
        this.color2 = textcolorblack});

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    double ratio = height / width;

    return AppBar(
      iconTheme: IconThemeData(color: textcolorblack),
      elevation: 0.5,
      backgroundColor: widget.color,

      leading: IconButton(
        icon: new Image.asset(
          'assets/icons/ic_commonBackIcon.png',
          scale: 2.2,
          color: widget.color2,
        ),
        onPressed: widget.ontap,
      ), //Image.asset('assets/icons/ic_commonBackIcon.png', scale: 2.1,), //
      titleSpacing: 0,
      leadingWidth: 50,
      title: VariableText(
        text: widget.title,
        fontsize: 16,
        fontcolor: widget.color2,
        weight: FontWeight.w600,
      ),
    );
  }
}

class CheckOutCards extends StatefulWidget {
  CheckOutCards({this.cartModel,this.total,this.onTap,this.width,this.height});
  CartModel cartModel;
  double total;
  var onTap;
  var width;
  var height;


  @override
  State<CheckOutCards> createState() => _CheckOutCardsState();
}

class _CheckOutCardsState extends State<CheckOutCards> {
  static double calculatePrice({int quantity, ProductModel productDetils}) {
    double dynamicprice =
    double.parse(productDetils.productPrice.last.price.toStringAsFixed(2));
    for (var item in productDetils.productPrice) {
      if (item.min <= quantity && item.max >= quantity) {
        dynamicprice = double.parse(item.price.toStringAsFixed(2));
      }
    }

    return double.parse(dynamicprice.toString());
  }
  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("###,###.0#", "en_US");
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(children:[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            VariableText(
              text:
              "${widget.cartModel.cartItemName[0].productName.brand}",
              fontsize: 14,
              fontcolor: textcolorblack,
              weight: FontWeight.w700,
              textAlign: TextAlign.start,
              fontFamily: fontRegular,
            )
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: widget.cartModel.cartItemName.length,
              itemBuilder: (BuildContext context, int index) {
                bool repeated = false;

                return Column(
                  children: [
                    Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Container(child: Row(children: [
                            VariableText(
                              text: widget.cartModel.cartItemName[index]
                                  .itemCount
                                  .toString() +
                                  "x",
                              fontsize: 13,
                              fontcolor: textcolorblack,
                              weight: FontWeight.w600,
                              line_spacing: 1.2,
                              textAlign: TextAlign.center,
                              fontFamily: fontRegular,
                            ),
                            SizedBox(
                              width: widget.height * 0.008,
                            ),
                            VariableText(
                              text: widget.cartModel.cartItemName[index]
                                  .productName.name,
                              fontsize: 11,
                              fontcolor: textcolorblack,
                              weight: FontWeight.w400,
                              textAlign: TextAlign.start,
                              line_spacing: 1.2,
                              max_lines: 2,
                              fontFamily: fontRegular,
                            ),
                          ],),),
                          Container(
                            child: VariableText(
                              text:
                              'Rs. ${f.format(double.parse((widget.cartModel.cartItemName[index].itemCount * calculatePrice(quantity: widget.cartModel.cartItemName[index].itemCount, productDetils: widget.cartModel.cartItemName[index].productName)).toString()))}',
                              fontsize: 13,
                              fontcolor: textcolorblack,
                              weight: FontWeight.w400,
                              line_spacing: 1.2,
                              textAlign: TextAlign.end,
                              fontFamily: fontRegular,
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: widget.height * 0.02,
                    ),
                  ],
                );
              }),
        ),
        Container(
          height: 1,
          color: Color(0xffE0E0E0),
        ),
        SizedBox(
          height: widget.height * 0.02,
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
              text: 'Rs. ' +
                  f.format(double.parse(widget.total
                      .toStringAsFixed(
                      2))), //${subtotal.toString()}',
              fontsize: 14, fontcolor: textcolorgrey,
              weight: FontWeight.w400,
              fontFamily: fontRegular,
            ),
          ],
        ),
        InkWell(
          onTap:widget.onTap,
          child: Container(
            color: themeColor2,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Container(
                height: widget.height * 0.06,
                decoration: BoxDecoration(
                  color: themeColor1,
                  borderRadius:
                  BorderRadius.circular(4),
                ),
                child: Center(
                  child: VariableText(
                    text: 'Checkout',
                    weight: FontWeight.w500,
                    fontsize: 16,
                    fontFamily: fontMedium,
                    fontcolor: themeColor2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),);
  }
}
class ProcessLoading extends StatefulWidget {
  @override
  State createState() {
    return _ProcessLoadingState();
  }
}

class _ProcessLoadingState extends State<ProcessLoading>
    with SingleTickerProviderStateMixin {
  AnimationController _cont;
  Animation<Color> _anim;

  @override
  void initState() {
    _cont = AnimationController(
        duration: Duration(
          seconds: 1,
        ),
        vsync: this);
    _cont.addListener(() {
      setState(() {
        //print("val: "+_cont.value.toString());
      });
    });
    ColorTween col = ColorTween(begin: themeColor1, end: themeColor1);
    _anim = col.animate(_cont);
    _cont.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        child: Center(
          child: Container(
              width: 50 * _cont.value,
              height: 50 * _cont.value,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  _anim.value,
                ),
              )),
        ));
  }
}