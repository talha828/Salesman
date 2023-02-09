import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/checkinScreen/checkin_screen.dart';

class CustomerCard extends StatefulWidget {
  CustomerCard({
    this.height,
    this.width,
    this.f,
    this.menuButton,
    this.code,
    this.category,
    this.shopName,
    this.address,
    this.name,
    this.phoneNo,
    this.lastVisit,
    this.dues,
    this.lastTrans,
    this.outstanding,
    this.shopAssigned,
    this.lat,
    this.long,
    this.showLoading,
    this.image,
    //this.customerData,
  });

  final String image;
  final double height;
  final double width;
  final NumberFormat f;
  final List<String> menuButton;
  final String code;
  final String category;
  final String shopName;
  final String address;
  final String name;
  final String phoneNo;
  final String lastVisit;
  final String dues;
  final String lastTrans;
  final String outstanding;
  final String shopAssigned;
  final String lat;
  final String long;
  // final customerData;
  Function showLoading;

  @override
  _CustomerCardState createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  int selectedIndex = 0;

  _onSelected(int i) {
    setState(() {
      selectedIndex = i;
    });
  }

  Future<void> PostEmployeeVisit({
    String customerCode,
    String employeeCode,
    String purpose,
    String lat,
    String long,
  }) async {
    try {
      /*   setState(() {
      widget.isLoading2=true;
    });*/
      var response = await OnlineDatabase.getSingleCustomer(customerCode);
      print("Response is" + response.statusCode.toString());
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      // print("Response is" + data.toString());
      var customerData = CustomerModel.fromModel(data['results'][0]);
      Provider.of<CustomerList>(context, listen: false)
          .myCustomer(customerData);

      print(customerData.editable);

      var response1 = await OnlineDatabase.postEmployee(
              customerCode: customerCode,
              purpose: purpose,
              long: long,
              lat: lat)
          .then((value) async {
        if (value.statusCode == 200) {
          var response = await OnlineDatabase.newPostEmployee(
              emp_id: employeeCode,
              customerCode: customerCode,
              purpose: purpose,
              long: long,
              lat: lat);
          print("Response is" + response.statusCode.toString());
          if (response.statusCode == 200) {
            print("data is" + response.data["data"]["distance"].toString());
            //  Provider.of<CartModel>(context, listen: false).createCart();
            Fluttertoast.showToast(
                msg: 'Check In Successfully',
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: 16.0);
            Provider.of<CustomerList>(context, listen: false)
                .myCustomer(customerData);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CheckInScreen(
                          distance: double.parse(
                              response.data["data"]["distance"].toString()),
                          //locationdata: _locationData,
                          shopDetails: customerData,
                        )));
          } else {
            print("data is" + response.statusCode.toString());
            widget.showLoading(false);
            Fluttertoast.showToast(
                msg: 'Some thing went wrong',
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          print("data is" + value.statusCode.toString());
          widget.showLoading(false);
          Fluttertoast.showToast(
              msg: 'Some thing went wrong',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        return true;
      }).catchError((e) => Fluttertoast.showToast(
              msg: 'Some thing went wrong',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 16.0));
    } catch (e, stack) {
      print('exception is' + e.toString());

      Fluttertoast.showToast(
          msg: "Error: " + e.response.data["message"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    text: widget.code.toString(),
                    fontsize: 11,
                    fontcolor: Colors.grey,
                    line_spacing: 1.4,
                    textAlign: TextAlign.start,
                    max_lines: 2,
                    weight: FontWeight.w500,
                  ),
                  VerticalDivider(
                    color: Color(0xff000000).withOpacity(0.25),
                    thickness: 1,
                  ),
                  VariableText(
                    text: widget.category.toString(),
                    fontsize: 11,
                    fontcolor: Colors.grey,
                    line_spacing: 1.4,
                    textAlign: TextAlign.start,
                    max_lines: 2,
                    weight: FontWeight.w500,
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
            text: widget.shopName.toString(),
            fontsize: widget.height / widget.width * 7,
            fontcolor: themeColor1,
            weight: FontWeight.w700,
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
            // onTap: () {
            //   if (widget.customerData.customerinfo.isNotEmpty) {
            //     renderDeletePopup(context, widget.height,
            //         widget.width, widget.customerData);
            //   } else {
            //     Fluttertoast.showToast(
            //         msg: "No Information found..",
            //         toastLength: Toast.LENGTH_LONG);
            //   }
            // },
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
                    text: widget.address.toString(),
                    // text:shopdetails[index].address.toString(),
                    fontsize: 11,
                    fontcolor: textcolorgrey,
                    line_spacing: 1.4,
                    textAlign: TextAlign.start,
                    max_lines: 2,
                    weight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: widget.height * 0.01,
                ),
                Image.asset(
                  'assets/icons/more.png',
                  scale: 3,
                  color: themeColor1,
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
                  text: widget.name,
                  // text: widget
                  //     .customerData.customerContactPersonName
                  //     .toString(),
                  // text: shopdetails[index].ownerName,
                  fontsize: 11,
                  fontcolor: textcolorgrey,
                  max_lines: 1,
                  weight: FontWeight.w500,
                  textAlign: TextAlign.start,
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
                  text: widget.phoneNo.toString(),
                  // text: widget.customerData.customerContactNumber
                  //     .toString(),
                  // text:shopdetails[index].ownerContact,
                  fontsize: 11,
                  fontcolor: textcolorgrey,

                  max_lines: 3,
                  weight: FontWeight.w500,
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
                        ),
                        Spacer(),
                        VariableText(
                          //text: 'Muhammad Ali',
                          text: widget.lastVisit.toString(),
                          // widget.customerData.lastVisitDay
                          //     .toString(),
                          // text: shopdetails[index].ownerName,
                          fontsize: 11,
                          fontcolor: textcolorgrey,
                          max_lines: 1,
                          weight: FontWeight.w500,
                          textAlign: TextAlign.start,
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
                        ),
                        Spacer(),
                        VariableText(
                          //text: 'Muhammad Ali',
                          text: widget.lastTrans.toString(),
                          // widget.customerData.lastTransDay
                          //     .toString(),
                          // text: shopdetails[index].ownerName,
                          fontsize: 11,
                          fontcolor: textcolorgrey,
                          max_lines: 1,
                          weight: FontWeight.w500,
                          textAlign: TextAlign.start,
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
                        ),
                        Spacer(),
                        VariableText(
                          //text: 'Muhammad Ali',
                          text: widget.dues.toString() == '0'
                              ? '--'
                              : widget.f
                                  .format(double.parse(widget.dues.toString())),
                          // text: shopdetails[index].ownerName,
                          fontsize: 11,
                          fontcolor: textcolorgrey,
                          max_lines: 1,
                          weight: FontWeight.w500,
                          textAlign: TextAlign.start,
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
                        ),
                        Spacer(),
                        VariableText(
                          //text: 'Muhammad Ali',
                          text: widget.outstanding.toString() == '0'
                              ? '0'
                              : widget.f.format(
                                  double.parse(widget.outstanding.toString())),
                          // text: shopdetails[index].ownerName,
                          fontsize: 11,
                          fontcolor: textcolorgrey,
                          max_lines: 1,
                          weight: FontWeight.w500,
                          textAlign: TextAlign.start,
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
          SingleChildScrollView(
            child: Container(
                height: 35,
                width: widget.width - 20,
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: widget.width * 0.09,
                      );
                    },
                    itemCount: widget.menuButton.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          widget.showLoading(true);
                          _onSelected(index);
                          if (index == 1) {
                            if (widget.lat == null) {
                              Fluttertoast.showToast(
                                  msg: 'Please Enable Your Location',
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.black87,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              widget.showLoading(false);
                              //checkAndGetLocation();
                            } else {
                              if (widget.shopAssigned == 'Yes') {
                                if (double.parse(userData.usercashReceive) >=
                                        double.parse(userData.usercashLimit)
                                    // || double.parse(userData.usercashReceive) < 0
                                    ) {
                                  limitReachedPopup(
                                      context: context,
                                      height: widget.height,
                                      width: widget.width);
                                  widget.showLoading(false);
                                } else {
                                  TODO: // set check-in api
                                  widget.showLoading(true);
                                  var location = new Location();
                                  var _location = await location.getLocation();
                                  PostEmployeeVisit(
                                    employeeCode: userData.userEmpolyeeNumber,
                                    customerCode: widget.code,
                                    purpose: 'Check In',
                                    lat: _location.latitude.toString(),
                                    long: _location.longitude.toString(),
                                  ).catchError((e) {
                                    print(e.toString());
                                    widget.showLoading(false);
                                  });
                                }
                                //widget.showLoading(false);
                              } else {
                                widget.showLoading(false);
                                Fluttertoast.showToast(
                                    msg: "Shop not assigned",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                          } else if (index == 0) {
                            ///Launch Map
                            if (widget.lat == null) {
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
                                  coords: Coords(double.parse(widget.lat),
                                      double.parse(widget.long)),
                                  title: widget.name,
                                  description: widget.address,
                                );
                              }
                              widget.showLoading(false);
                            }
                          }
                        },
                        child: Container(
                          child: Container(
                            height: widget.height * 0.05,
                            width: widget.width * 0.38,
                            decoration: BoxDecoration(
                                color: index == 0 ? themeColor1 : themeColor2,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: index == 0 ?
                                    themeColor1
                                        : widget.shopAssigned == 'Yes' ? themeColor1 : Colors.grey[400]
                                )),
                            child: Center(
                              child: VariableText(
                                text: widget.menuButton[index],
                                fontsize: 11,
                                fontcolor:
                                index == 0
                                    ? themeColor2
                                    : widget.shopAssigned == 'Yes' ? themeColor1 : Colors.grey[400],
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                      // return InkWell(
                      //     onTap: () async {
                      //
                      //
                      //     },
                      //     child: );
                    })),
          )
        ],
      ),
    );
  }

  limitReachedPopup({BuildContext context, double height, double width}) {
    AwesomeDialog(
        context: context,
        //dismissOnTouchOutside: false,
        animType: AnimType.SCALE,
        dialogType: DialogType.WARNING,
        btnOkColor: themeColor1,
        showCloseIcon: true,
        btnOkText: "OK",
        closeIcon: Icon(Icons.close),
        btnOkOnPress: () {
          print("ok tap");
          // Navigator.pop(context);
        },
        body: StatefulBuilder(builder: (context, setState) {
          return Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                VariableText(
                  text: "Your Limit is Reached",
                  fontsize: 14,
                  fontcolor: textcolorblack,
                  weight: FontWeight.w500,
                  fontFamily: fontMedium,
                ),
                // SizedBox(height: height*0.02,),
              ],
            ),
          );
        }))
      ..show();
  }
}
