
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/style.dart';
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
      {this.text = "temp", required this.onTap, this.enable = true, required this.width});

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
  final customerData;
  //bool isLoading2;
  //LocationData locationData;
  Function showLoading;
  final customerList;
  CustomShopContainer(
      {required this.height,
        required this.width,
        this.customerData,
        this.customerList,
        //this.isLoading2,
        required this.lat,
        required this.long,
        //this.locationData,
        required this.showLoading});

  @override
  _CustomShopContainerState createState() => _CustomShopContainerState();
}

class _CustomShopContainerState extends State<CustomShopContainer> {
  /*Location location = new Location();
  bool _serviceEnabled = false;
  LocationData _locationData;*/
  late double templat, templong;

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
                                      text: widget.customerData.lastVisitDay
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
                                      text: widget.customerData.lastTransDay
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
                                      text: f.format(double.parse(widget.customerData.dues.toString())),
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
                                      text: f.format(double.parse(widget.customerData.outStanding.toString())),
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
                                  // _onSelected(index);
                                  // if (index == 1) {
                                  //   if (templat == null) {
                                  //     Fluttertoast.showToast(
                                  //         msg: 'Please Enable Your Location',
                                  //         toastLength: Toast.LENGTH_SHORT,
                                  //         backgroundColor: Colors.black87,
                                  //         textColor: Colors.white,
                                  //         fontSize: 16.0);
                                  //     //checkAndGetLocation();
                                  //   } else {
                                  //     if(widget.customerData.shopAssigned == 'Yes'){
                                  //       if (double.parse(userData.usercashReceive) >=
                                  //           double.parse(userData.usercashLimit)
                                  //       // || double.parse(userData.usercashReceive) < 0
                                  //       ) {
                                  //         limitReachedPopup(
                                  //             context: context,
                                  //             height: widget.height,
                                  //             width: widget.width);
                                  //
                                  //         ///for testing
                                  //         /*widget.showLoading(true);
                                  //   await PostEmployeeVisit(
                                  //       customerCode:
                                  //           widget.customerData.customerCode,
                                  //       purpose: 'Check In',
                                  //       lat: templat.toString(),
                                  //       long: templong.toString(),
                                  //       customerData: widget.customerData);
                                  //   widget.showLoading(false);*/
                                  //       } else {
                                  //         widget.showLoading(true);
                                  //         await PostEmployeeVisit(
                                  //             customerCode:
                                  //             widget.customerData.customerCode,
                                  //             purpose: 'Check In',
                                  //             lat: templat.toString(),
                                  //             long: templong.toString(),
                                  //             customerData: widget.customerData);
                                  //         widget.showLoading(false);
                                  //       }
                                  //     }
                                  //   }
                                  // } else if (index == 0) {
                                  //   ///Launch Map
                                  //   if (widget.customerData.customerLatitude ==
                                  //       null) {
                                  //     Fluttertoast.showToast(
                                  //         msg: "Shop location not found",
                                  //         toastLength: Toast.LENGTH_SHORT,
                                  //         gravity: ToastGravity.BOTTOM,
                                  //         timeInSecForIosWeb: 3,
                                  //         backgroundColor: Colors.black87,
                                  //         textColor: Colors.white,
                                  //         fontSize: 16.0);
                                  //   } else {
                                  //     if (await MapLauncher.isMapAvailable(
                                  //         MapType.google)) {
                                  //       await MapLauncher.showMarker(
                                  //         mapType: MapType.google,
                                  //         coords: Coords(
                                  //             widget.customerData.customerLatitude,
                                  //             widget
                                  //                 .customerData.customerLongitude),
                                  //         title:
                                  //         widget.customerData.customerShopName,
                                  //         description:
                                  //         widget.customerData.customerAddress,
                                  //       );
                                  //     }
                                  //   }
                                  // }
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
                                              // color: index == 0 ?
                                              // themeColor1
                                              //     : widget.customerData.shopAssigned == 'Yes' ? themeColor1 : Colors.grey[400]
                                          )),
                                      child: Center(
                                        child: VariableText(
                                          text: menuButton[index],
                                          fontsize: 11,
                                          // fontcolor: index == 0
                                          //     ? themeColor2
                                          //     : widget.customerData.shopAssigned == 'Yes' ? themeColor1 : Colors.grey[400],
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
  void Function()?  onTap;
  final String imageSource;
  final bool selected;

   DrawerList({
    required this.imageSource,
    required this.text,
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