import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/generated/assets.dart';
import 'package:salesmen_app_new/newModel/productModel.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/tradingAddItemDetailsScreen/tradingAddItemDetailsScreen.dart';
import 'package:shimmer/shimmer.dart';


class TradingProfileScreen extends StatefulWidget {
  final String customerCode;
  const TradingProfileScreen({this.customerCode, Key key}) : super(key: key);

  @override
  State<TradingProfileScreen> createState() => _TradingProfileScreenState();
}

class _TradingProfileScreenState extends State<TradingProfileScreen> {
  bool flag = false;
  Product product;
  Product productSearch;
  getOffers() async {
    setLoading(true);
    var response =
        await OnlineDatabase.getMyOffers(customerCode: widget.customerCode);
    print("Response is" + response.statusCode.toString());
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      product = Product.fromJson(data);
      productSearch = Product.fromJson(data);
      setLoading(false);
    } else {
      setLoading(false);
      Fluttertoast.showToast(
          msg: data["results"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  bool isLoading = false;

  setLoading(bool value) {
    setState(() {
      flag = value;
    });
  }

  ScrollController controller =  ScrollController();
  int _currentIndex=25;
  filterProducts(String query) {
    setState(() {
      productSearch.results = product.results
          .where((product) =>
      product.pRODUCT.toLowerCase().contains(query.toLowerCase()) ||
          product.pRODCODE.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
  @override
  void initState() {
    getOffers();
    controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  void _onScroll() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      setState(() {
        if((productSearch.results.length - _currentIndex) > 25 ){
          _currentIndex=_currentIndex+25;
        }else{
          _currentIndex=_currentIndex+(productSearch.results.length - _currentIndex);
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              "MY OFFERS",
              style: TextStyle(color: Colors.white),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    end: Alignment.topRight,
                    begin: Alignment.bottomLeft,
                    colors: <Color>[
                      const Color(0xFF22E774),
                      const Color(0xFF0C9933),
                    ]),
              ),
            ),
          ),
          body: InteractiveViewer(
            child: SingleChildScrollView(
                controller: controller,
                child: Container(
              padding: EdgeInsets.symmetric(
                vertical: width * 0.04,
              ),
              child: product == null
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Container(
                                width: width,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                    // color: themeColor1,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 8,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: height * 0.20,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              SizedBox(
                                                height: height * 0.02,
                                              ),
                                              Container(
                                                height: height * 0.05,
                                                width: width,
                                                decoration: BoxDecoration(
                                                    color: themeColor1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Center(
                                                    child: Container(
                                                  height: 10,
                                                  width: 20,
                                                  color: themeColor1,
                                                )),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                          flex: 14,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 200,
                                                  color: themeColor1,
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 200,
                                                  color: themeColor1,
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 200,
                                                  color: themeColor1,
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 200,
                                                  color: themeColor1,
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 200,
                                                  color: themeColor1,
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                SizedBox(
                                                  height: height * 0.0055,
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                )),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: width * 0.04,
                        );
                      },
                      itemCount: 4)
                  : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04,vertical: width * 0.04),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Search Here",
                            border: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                          ),
                          onChanged: (query) => filterProducts(query),
                        ),
                      ),

                      ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, j) {
                                  return ProfileTitle(
                                    width: width,
                                    product: productSearch.results[i],
                                    additem: true,
                                    price: productSearch.results[i].pRICE[j],
                                    setLoading: (bool value) {
                                      setState(() {
                                        isLoading = value;
                                      });
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: width * 0.04,
                                  );
                                },
                                itemCount: productSearch.results[i].pRICE.length);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: width * 0.04,
                            );
                          },
                          itemCount: productSearch.results.length > 25 ?_currentIndex:productSearch.results.length),
                    ],
                  ),
            )),
          ),
        ),
        isLoading
            ? Positioned.fill(
                child: GreenLoading(),
              )
            : Container(),
      ],
    ));
  }
}

class ProfileTitle extends StatelessWidget {
  ProfileTitle(
      {Key key,
      @required this.width,
      @required this.product,
      @required this.price,
      @required this.additem,
      this.setLoading})
      : super(key: key);

  final double width;
  final Results product;
  final PRICE price;
  final bool additem;
  var setLoading;
  final Shader linearGradient = LinearGradient(
    end: Alignment.topRight,
    begin: Alignment.bottomLeft,
    colors: <Color>[
      const Color(0xFF22E774),
      const Color(0xFF0C9933),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: width * 0.02, horizontal: width * 0.02),
      margin: EdgeInsets.symmetric(horizontal: width * 0.02),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.5))
          // boxShadow: [
          //   BoxShadow(
          //     offset: Offset(-2, 2),
          //     blurRadius: 7,
          //     color: Colors.grey.withOpacity(0.5),
          //   ),
          // ],
          ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // color:Colors.grey,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    product.iMAGEURL,
                    errorBuilder: (context, object, stackTrace) {
                      return Image.asset(Assets.iconsHistory);
                    },
                    width: width * 0.25,
                    fit: BoxFit.cover,
                    height: width * 0.32,
                  ),
                ),
              ),
              SizedBox(
                height: width * 0.06,
              ),
              additem
                  ? InkWell(
                      onTap: price.sTATUS == "N"
                          ? null
                          : () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.INFO_REVERSED,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Waring Alert',
                                desc:
                                    'Ager Offer ek dafa close kar di to dubara opent nh kar sakty',
                                btnOkOnPress: () async {
                                  setLoading(true);
                                  var response =
                                      await OnlineDatabase.postCloseOffer(
                                              tr: price.tR.toString())
                                          .catchError((e) {
                                    setLoading(false);
                                    Fluttertoast.showToast(
                                        msg: "Error: ${e.toString()}");
                                  });
                                  var data = jsonDecode(
                                      utf8.decode(response.bodyBytes));
                                  if (response.statusCode == 200) {
                                    setLoading(false);
                                    Get.back();
                                  } else {
                                    setLoading(false);
                                    AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.ERROR,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Something went wrong',
                                        desc: data['results'].toString(),
                                        btnOkOnPress: () async {}).show();
                                  }
                                  //Get.back();
                                },
                              ).show();
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          gradient: LinearGradient(
                              end: Alignment.topRight,
                              begin: Alignment.bottomLeft,
                              colors: <Color>[
                                price.sTATUS == "N"
                                    ? Colors.grey
                                    : const Color(0xFFFF0900),
                                price.sTATUS == "N"
                                    ? Colors.grey
                                    : const Color(0xFFFF9F00),
                              ]),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: width * 0.02, horizontal: width * 0.045),
                        child: Text(
                          price.sTATUS == "N" ? "OFFER CLOSED" : "STOP OFFER",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            width: width * 0.04,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.pRODCODE,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Flexible(
                      child: Text(
                       "TR: "+ price.tR.toString(),
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 12,

                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: width * 0.02,
                ),
                Text(
                  product.pRODUCT,
                  maxLines: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader = linearGradient,
                      fontSize: 14),
                ),
                SizedBox(
                  height: width * 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (product.mODEL != null)
                      Text(
                        product.mODEL,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    if (product.dESCRIPTION != null)
                      Text(
                        product.dESCRIPTION,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
                SizedBox(
                  height: width * 0.02,
                ),
                product.oFFERITEM == "Y"
                    ? Container(
                        height: width * 0.32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Table(
                              //border: TableBorder.symmetric(inside: BorderSide()),
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Qty",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Rate",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "MRP",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Expire",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          price.qTY.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          price.rATE.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          price.mRP.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          price.eXPIRE.toString(),
                                          style: TextStyle(
                                            fontSize: 9,
                                          ),
                                        )),
                                  ),
                                ]),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Column(
                            //       children: [
                            //         Text(
                            //           "QTY",
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.bold),
                            //         ),
                            //         SizedBox(
                            //           height: width * 0.02,
                            //         ),
                            //         Text(
                            //           price.qTY.toString(),
                            //           style: TextStyle(fontSize: width * 0.03),
                            //         ),
                            //       ],
                            //     ),
                            //     SizedBox(
                            //       width: width * 0.02,
                            //     ),
                            //     Column(
                            //       children: [
                            //         Text(
                            //           "RATE",
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.bold),
                            //         ),
                            //         SizedBox(
                            //           height: width * 0.02,
                            //         ),
                            //         Text(
                            //           price.rATE.toStringAsFixed(0),
                            //           style: TextStyle(fontSize: width * 0.03),
                            //         ),
                            //       ],
                            //     ),
                            //     SizedBox(
                            //       width: width * 0.02,
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: width * 0.02,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Column(
                            //       children: [
                            //         Text(
                            //           "MRP",
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.bold),
                            //         ),
                            //         SizedBox(
                            //           height: width * 0.02,
                            //         ),
                            //         Text(
                            //           price.mRP,
                            //           style: TextStyle(fontSize: width * 0.03),
                            //         ),
                            //       ],
                            //     ),
                            //     SizedBox(
                            //       width: width * 0.02,
                            //     ),
                            //     Column(
                            //       children: [
                            //         Text(
                            //           "EXPIRE",
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.bold),
                            //         ),
                            //         SizedBox(
                            //           height: width * 0.02,
                            //         ),
                            //         Text(
                            //           price.eXPIRE.toString(),
                            //           style: TextStyle(fontSize: width * 0.03),
                            //         ),
                            //       ],
                            //     ),
                            //     SizedBox(
                            //       width: width * 0.02,
                            //     ),
                            //   ],
                            // ),
                            SizedBox(
                              height: width * 0.02,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      gradient: LinearGradient(
                                          end: Alignment.topRight,
                                          begin: Alignment.bottomLeft,
                                          colors: <Color>[
                                            price.sTATUS == "N"
                                                ? Colors.grey
                                                : const Color(0xFF22E774),
                                            price.sTATUS == "N"
                                                ? Colors.grey
                                                : const Color(0xFF0C9933),
                                          ]),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: width * 0.02,
                                        horizontal: width * 0.03),
                                    child: Text(
                                      "SKT    ${price.bALANCE}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      gradient: LinearGradient(
                                          end: Alignment.topRight,
                                          begin: Alignment.bottomLeft,
                                          colors: <Color>[
                                            price.sTATUS == "N"
                                                ? Colors.grey
                                                : const Color(0xFF22E774),
                                            price.sTATUS == "N"
                                                ? Colors.grey
                                                : const Color(0xFF0C9933),
                                          ]),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: width * 0.02,
                                        horizontal: width * 0.04),
                                    child: Text(
                                      "P-BAL   ${price.pURBALANCE}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      gradient: LinearGradient(
                                          end: Alignment.topRight,
                                          begin: Alignment.bottomLeft,
                                          colors: <Color>[
                                            price.sTATUS == "N"
                                                ? Colors.grey
                                                : const Color(0xFF22E774),
                                            price.sTATUS == "N"
                                                ? Colors.grey
                                                : const Color(0xFF0C9933),
                                          ]),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: width * 0.02,
                                        horizontal: width * 0.03),
                                    child: Text(
                                      "ORD     ${price.oRDERS}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      gradient: LinearGradient(
                                          end: Alignment.topRight,
                                          begin: Alignment.bottomLeft,
                                          colors: <Color>[
                                            price.sTATUS == "N"
                                                ? Colors.grey
                                                : const Color(0xFF22E774),
                                            price.sTATUS == "N"
                                                ? Colors.grey
                                                : const Color(0xFF0C9933),
                                          ]),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: width * 0.02,
                                        horizontal: width * 0.03),
                                    child: Text(
                                      "P-QTY    ${price.pURQTY}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                ],
                              ),
                            )
                            // Row(
                            //   children: [
                            //
                            //
                            //   ],
                            // )
                            // Expanded(
                            //   child: ListView.separated(
                            //       itemBuilder: (context, index) {
                            //         return Container(
                            //           child: Row(
                            //             mainAxisAlignment:
                            //             MainAxisAlignment.spaceEvenly,
                            //             children: [
                            //             ],
                            //           ),
                            //         );
                            //       },
                            //       separatorBuilder: (context, index) {
                            //         return SizedBox(
                            //           height: width * 0.01,
                            //         );
                            //       },
                            //       itemCount: product.pRICE.length),
                            // )
                          ],
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        height: width * 0.2,
                        child: Text(
                          "No Offer Found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
