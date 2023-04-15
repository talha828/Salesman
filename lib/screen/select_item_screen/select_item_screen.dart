import 'package:badges/badges.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/generated/assets.dart';
import 'package:salesmen_app_new/newModel/cartModel.dart';
import 'package:salesmen_app_new/newModel/productModel.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/check_out_screen/check_out_screen.dart';
import 'package:shimmer/shimmer.dart';

class SelectItemScreen extends StatefulWidget {
  final Results results;
  SelectItemScreen({Key key, this.results}) : super(key: key);

  @override
  State<SelectItemScreen> createState() => _SelectItemScreenState();
}

class _SelectItemScreenState extends State<SelectItemScreen> {
  bool flag = false;
  bool isLoading = false;

  int count = 0;
  TextEditingController controller = TextEditingController();
  setLoading(bool value) {
    setState(() {
      flag = value;
    });
  }

  @override
  void initState() {
    // getOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var cart = Provider.of<AddToCartModel>(context);
    var ratio = height / width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add to cart",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Badge(
                position: BadgePosition.topEnd(top: 0, end: 3),
                badgeColor: Colors.white,
                showBadge: cart.cart.isNotEmpty,
                animationDuration: Duration(milliseconds: 200),
                animationType: BadgeAnimationType.fade,
                badgeContent: Text(
                  cart.cart.length.toString(),
                  style: TextStyle(color: themeColor1, fontSize: 10),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: themeColor2,
                  ),
                  onPressed: () {
                    Get.to(CheckOutScreen());
                    // item.myProducts.value.clear();
                    // item.cartList.clear();
                    // item.difference.value=false;
                    // for(var i in cartdata.cartItemName) {
                    //   print(i.productName.productCode);
                    //   item.myProducts.value.add(i);
                    // }
                    // item.indexList.clear();
                    // Navigator.push(context,
                    //     NoAnimationRoute(widget: CartScreen()));
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: width * 0.2,
          padding: EdgeInsets.symmetric(
              vertical: width * 0.04, horizontal: width * 0.04),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    cart.cart.isNotEmpty ? themeColor1 : Colors.grey)),
            onPressed: () {
              Get.to(CheckOutScreen());
            },
            child: Text("Checkout"),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: InteractiveViewer(
              child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: width * 0.04,
                    ),
                    child: widget.results == null
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
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(0, 1),
                                            )
                                          ],
                                          // color: themeColor1,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                            BorderRadius
                                                                .circular(5),
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
                                                              BorderRadius
                                                                  .circular(5)),
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
                                                        CrossAxisAlignment
                                                            .start,
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
                              ProfileTitle(
                                width: width,
                                product: widget.results,
                                additem: true,
                                setLoading: (bool value) {
                                  setState(() {
                                    isLoading = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height: width * 0.04,
                              ),
                              ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: widget.results.pRICE
                                    .map((e) => Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: width * 0.02,
                                              vertical: width * 0.02),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.5))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              SizedBox(
                                                height: width * 0.02,
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                child: Text("TR ${e.tR}"),
                                              ),
                                              ListTile(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "QTY",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        ),
                                                        SizedBox(
                                                          height: width * 0.02,
                                                        ),
                                                        Text(
                                                            e.bALANCE
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 13)),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "RATE",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        ),
                                                        SizedBox(
                                                          height: width * 0.02,
                                                        ),
                                                        Text(
                                                            e.sELLINGPRICE
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: TextStyle(
                                                                fontSize: 13)),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "MRP",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        ),
                                                        SizedBox(
                                                          height: width * 0.02,
                                                        ),
                                                        Text(
                                                            e.mRP.toString() ==
                                                                    "NULL"
                                                                ? "--"
                                                                : e.mRP
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 13)),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Expire",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13),
                                                        ),
                                                        SizedBox(
                                                          height: width * 0.02,
                                                        ),
                                                        Text(
                                                            e.eXPIRE.toString() ==
                                                                    "NULL"
                                                                ? "--"
                                                                : e.eXPIRE
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 13)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                // trailing:Container(
                                                //   width: width * 0.04,
                                                //   child: CartStepper(
                                                //     numberSize: 20,
                                                //     count: count,
                                                //     didChangeCount: (value){
                                                //     setState(() {
                                                //       count=value;
                                                //     });
                                                //     },
                                                //   ),
                                                // )
                                              ),
                                              SizedBox(
                                                height: width * 0.04,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  if (cart.cart != null &&
                                                      cart.cart
                                                          .where((product) =>
                                                              product.tr ==
                                                              e.tR.toString())
                                                          .isNotEmpty)
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "Total Value:",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(
                                                          height: width * 0.02,
                                                        ),
                                                        Text(
                                                          cart.cart
                                                              .firstWhere(
                                                                  (product) =>
                                                                      product.tr
                                                                          .toString() ==
                                                                      e.tR
                                                                          .toString(),
                                                                  orElse: () =>
                                                                      null)
                                                              ?.amount
                                                              .toStringAsFixed(
                                                                  2),
                                                          style: TextStyle(
                                                              color:
                                                                  themeColor1,
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                  // e.count>0?Container(
                                                  //   child: Row(
                                                  //     crossAxisAlignment: CrossAxisAlignment.center,
                                                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  //     children: [
                                                  //       InkWell(
                                                  //         onTap:(){
                                                  //
                                                  //         },
                                                  //         child: Container(
                                                  //           height: (height/width)*16,
                                                  //           width: (height/width)*16 ,
                                                  //           decoration: BoxDecoration(
                                                  //             color: Colors.grey.withOpacity(0.5),
                                                  //             borderRadius: BorderRadius.circular(5),
                                                  //           ),
                                                  //           child: Align(
                                                  //               alignment: Alignment.center,
                                                  //               child:Icon(Icons.remove,color: Color(0xff828282),size: 18,)
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //
                                                  //       Container(
                                                  //         height: (height/width)*15,
                                                  //         width: (height/width)*15,
                                                  //         //color: Colors.red,
                                                  //         child: TextField(
                                                  //           textAlignVertical: TextAlignVertical.center,
                                                  //           controller:controller,
                                                  //           textAlign: TextAlign.center,
                                                  //           keyboardType: TextInputType.number,
                                                  //           onChanged: (v){
                                                  //
                                                  //           },
                                                  //           decoration: InputDecoration(
                                                  //             hintText:count.toString(),
                                                  //             hintStyle: TextStyle(
                                                  //               fontSize:14,
                                                  //               fontWeight: FontWeight.w500,
                                                  //               color: Color(0xff333333),
                                                  //             ),
                                                  //             border: InputBorder.none,
                                                  //             focusedBorder: InputBorder.none,
                                                  //             enabledBorder: InputBorder.none,
                                                  //             errorBorder: InputBorder.none,
                                                  //             disabledBorder: InputBorder.none,
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //       InkWell(
                                                  //         onTap:(){
                                                  //
                                                  //         },
                                                  //         child:  Container(
                                                  //           height: (height/width)*16,
                                                  //           width: (height/width)*16 ,
                                                  //           decoration: BoxDecoration(
                                                  //               color: themeColor1,
                                                  //               borderRadius: BorderRadius.circular(5)
                                                  //           ),
                                                  //           child: Align(
                                                  //               alignment: Alignment.center,
                                                  //               child:Icon(Icons.add,color: themeColor2,size: 18,)
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ):InkWell(
                                                  //   onTap: (){
                                                  //
                                                  //   },
                                                  //   child: Container(
                                                  //     height: height*0.05,
                                                  //     width: width*0.3,
                                                  //     decoration: BoxDecoration(
                                                  //         color:  themeColor1,
                                                  //         borderRadius: BorderRadius.circular(5)
                                                  //     ),
                                                  //     child:Center(
                                                  //       child: VariableText(
                                                  //         text:  'Add To Cart',
                                                  //         fontcolor:themeColor2,
                                                  //         fontsize: 14, weight: FontWeight.w400,),
                                                  //     )
                                                  //     ,
                                                  //   ),
                                                  // ),

                                                  Container(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if (e.count == 0) {
                                                            } else {
                                                              e.count--;
                                                              e.text =
                                                                  TextEditingController(
                                                                      text: e
                                                                          .count
                                                                          .toString());
                                                            }
                                                            if (e.count <
                                                                e.bALANCE + 1) {
                                                              if (e.count ==
                                                                  1) {
                                                                if (cart.cart
                                                                    .isEmpty) {
                                                                  cart.createCart(
                                                                    productCode: widget
                                                                        .results
                                                                        .pRODCODE,
                                                                    name: widget
                                                                        .results
                                                                        .pRODUCT,
                                                                    qty: 1,
                                                                    rate: double.parse(e
                                                                        .sELLINGPRICE
                                                                        .toString()),
                                                                    amount: double.parse(e
                                                                        .sELLINGPRICE
                                                                        .toString()),
                                                                    tr: e.tR
                                                                        .toString(),
                                                                    isChange:
                                                                        false,
                                                                  );
                                                                } else {
                                                                  if (cart.cart
                                                                      .where((product) => product
                                                                          .tr
                                                                          .contains(e
                                                                              .tR
                                                                              .toString()))
                                                                      .isNotEmpty) {
                                                                    cart.cartUpdate(
                                                                        tr: e.tR
                                                                            .toString(),
                                                                        qty: e
                                                                            .count);
                                                                  } else {
                                                                    cart.createCart(
                                                                      productCode: widget
                                                                          .results
                                                                          .pRODCODE,
                                                                      qty: 1,
                                                                      name: widget
                                                                          .results
                                                                          .pRODUCT,
                                                                      rate: double.parse(e
                                                                          .sELLINGPRICE
                                                                          .toString()),
                                                                      amount: double.parse(e
                                                                          .sELLINGPRICE
                                                                          .toString()),
                                                                      tr: e.tR
                                                                          .toString(),
                                                                      isChange:
                                                                          false,
                                                                    );
                                                                  }
                                                                }
                                                              } else if (e
                                                                      .count >
                                                                  1) {
                                                                cart.cartUpdate(
                                                                    tr: e.tR
                                                                        .toString(),
                                                                    qty: e
                                                                        .count);
                                                              } else {
                                                                cart.cart.removeWhere(
                                                                    (element) =>
                                                                        element
                                                                            .tr ==
                                                                        e.tR.toString());
                                                              }
                                                              setState(() {
                                                                e.count =
                                                                    e.count;
                                                              });
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'You reach the product limit');
                                                            }
                                                          },
                                                          child: Container(
                                                            height: ratio * 16,
                                                            width: ratio * 16,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xffF1F1F1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  color: Color(
                                                                      0xff828282),
                                                                  size: 18,
                                                                )),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: ratio * 15,
                                                          width: ratio * 15,
                                                          //color: Colors.red,
                                                          child: TextField(
                                                            controller: e.text,
                                                            textAlignVertical:
                                                                TextAlignVertical
                                                                    .center,
                                                            textAlign: TextAlign
                                                                .center,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            onChanged: (v) {
                                                              if (int.parse(v) >
                                                                  e.bALANCE) {
                                                                e.count =
                                                                    e.bALANCE;
                                                                e.text = TextEditingController(
                                                                    text: e
                                                                        .bALANCE
                                                                        .toString());
                                                              } else {
                                                                e.count =
                                                                    int.parse(
                                                                        v);
                                                                // e.text=TextEditingController(text:v.toString());
                                                                //
                                                              }
                                                              if (e.count <
                                                                  e.bALANCE +
                                                                      1) {
                                                                if (e.count ==
                                                                    1) {
                                                                  if (cart.cart
                                                                      .isEmpty) {
                                                                    cart.createCart(
                                                                      productCode: widget
                                                                          .results
                                                                          .pRODCODE,
                                                                      name: widget
                                                                          .results
                                                                          .pRODUCT,
                                                                      qty: 1,
                                                                      rate: double.parse(e
                                                                          .sELLINGPRICE
                                                                          .toString()),
                                                                      amount: double.parse(e
                                                                          .sELLINGPRICE
                                                                          .toString()),
                                                                      tr: e.tR
                                                                          .toString(),
                                                                      isChange:
                                                                          false,
                                                                    );
                                                                  } else {
                                                                    if (cart
                                                                        .cart
                                                                        .where((product) => product
                                                                            .tr
                                                                            .contains(e.tR.toString()))
                                                                        .isNotEmpty) {
                                                                      cart.cartUpdate(
                                                                          tr: e
                                                                              .tR
                                                                              .toString(),
                                                                          qty: e
                                                                              .count);
                                                                    } else {
                                                                      cart.createCart(
                                                                        productCode: widget
                                                                            .results
                                                                            .pRODCODE,
                                                                        qty: 1,
                                                                        name: widget
                                                                            .results
                                                                            .pRODUCT,
                                                                        rate: double.parse(e
                                                                            .sELLINGPRICE
                                                                            .toString()),
                                                                        amount: double.parse(e
                                                                            .sELLINGPRICE
                                                                            .toString()),
                                                                        tr: e.tR
                                                                            .toString(),
                                                                        isChange:
                                                                            false,
                                                                      );
                                                                    }
                                                                  }
                                                                } else if (e
                                                                        .count >
                                                                    1) {
                                                                  cart.cartUpdate(
                                                                      tr: e.tR
                                                                          .toString(),
                                                                      qty: e
                                                                          .count);
                                                                } else {
                                                                  cart.cart.removeWhere(
                                                                      (element) =>
                                                                          element
                                                                              .tr ==
                                                                          e.tR.toString());
                                                                }
                                                                setState(() {
                                                                  e.count =
                                                                      e.count;
                                                                });
                                                              } else {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            'You reach the product limit');
                                                              }
                                                              // if(widget.productDetails.availableQuantity>int.parse(v.toString())){
                                                              //   setState(() {
                                                              //     count = int.parse(v);
                                                              //     print(count);
                                                              //   });
                                                              //   widget.onquantityUpdate(count);
                                                              // }else{
                                                              //   itemCount=TextEditingController(text: widget.productDetails.availableQuantity.toString());
                                                              //   setState(() {
                                                              //     print(count);
                                                              //     count = widget.productDetails.availableQuantity;
                                                              //   });
                                                              //   widget.onquantityUpdate(count);
                                                              // }
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              hintText: count
                                                                  .toString(),
                                                              hintStyle:
                                                                  TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xff333333),
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              errorBorder:
                                                                  InputBorder
                                                                      .none,
                                                              disabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (e.count ==
                                                                e.bALANCE) {
                                                            } else {
                                                              e.count++;
                                                              e.text =
                                                                  TextEditingController(
                                                                      text: e
                                                                          .count
                                                                          .toString());
                                                            }
                                                            if (e.count <
                                                                e.bALANCE + 1) {
                                                              if (e.count ==
                                                                  1) {
                                                                if (cart.cart
                                                                    .isEmpty) {
                                                                  cart.createCart(
                                                                    productCode: widget
                                                                        .results
                                                                        .pRODCODE,
                                                                    name: widget
                                                                        .results
                                                                        .pRODUCT,
                                                                    qty: 1,
                                                                    rate: double.parse(e
                                                                        .sELLINGPRICE
                                                                        .toString()),
                                                                    amount: double.parse(e
                                                                        .sELLINGPRICE
                                                                        .toString()),
                                                                    tr: e.tR
                                                                        .toString(),
                                                                    isChange:
                                                                        false,
                                                                  );
                                                                } else {
                                                                  if (cart.cart
                                                                      .where((product) => product
                                                                          .tr
                                                                          .contains(e
                                                                              .tR
                                                                              .toString()))
                                                                      .isNotEmpty) {
                                                                    cart.cartUpdate(
                                                                        tr: e.tR
                                                                            .toString(),
                                                                        qty: e
                                                                            .count);
                                                                  } else {
                                                                    cart.createCart(
                                                                      productCode: widget
                                                                          .results
                                                                          .pRODCODE,
                                                                      qty: 1,
                                                                      name: widget
                                                                          .results
                                                                          .pRODUCT,
                                                                      rate: double.parse(e
                                                                          .sELLINGPRICE
                                                                          .toString()),
                                                                      amount: double.parse(e
                                                                          .sELLINGPRICE
                                                                          .toString()),
                                                                      tr: e.tR
                                                                          .toString(),
                                                                      isChange:
                                                                          false,
                                                                    );
                                                                  }
                                                                }
                                                              } else if (e
                                                                      .count >
                                                                  1) {
                                                                cart.cartUpdate(
                                                                    tr: e.tR
                                                                        .toString(),
                                                                    qty: e
                                                                        .count);
                                                              } else {
                                                                cart.cart.removeWhere(
                                                                    (element) =>
                                                                        element
                                                                            .tr ==
                                                                        e.tR.toString());
                                                              }
                                                              setState(() {
                                                                e.count =
                                                                    e.count;
                                                              });
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'You reach the product limit');
                                                            }
                                                            // if(count>0){
                                                            //   if(widget.productDetails.availableQuantity>count){
                                                            //     setState(() {
                                                            //       count++;
                                                            //       itemCount.text = count.toString();
                                                            //       //subtotal=(count*int.parse(widget.productData.price.split('.')[0]));
                                                            //     });
                                                            //     widget.onquantityUpdate(count);
                                                            //   }else{
                                                            //     Fluttertoast.showToast(msg: "you reach the stock limit");
                                                            //   }
                                                            // }
                                                          },
                                                          child: Container(
                                                            height: ratio * 16,
                                                            width: ratio * 16,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    themeColor1,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color:
                                                                      themeColor2,
                                                                  size: 18,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  // Container(
                                                  //   width: e.count == 0
                                                  //       ? width * 0.2
                                                  //       : width * 0.3,
                                                  //   child: CartStepper(
                                                  //     deActiveBackgroundColor:
                                                  //         themeColor1,
                                                  //     deActiveForegroundColor:
                                                  //         Colors.white,
                                                  //     activeBackgroundColor:
                                                  //         themeColor1,
                                                  //     activeForegroundColor:
                                                  //         Colors.white,
                                                  //     size: 30,
                                                  //     count: e.count,
                                                  //     didChangeCount: (value){
                                                  //       if (value < e.bALANCE + 1) {
                                                  //               if (value == 1) {
                                                  //                       if (cart.cart.isEmpty) {cart.createCart(
                                                  //                         productCode:
                                                  //                         widget.results.pRODCODE,
                                                  //                           name: widget.results.pRODUCT,
                                                  //                           qty: 1,
                                                  //                           rate: double.parse(e.sELLINGPRICE.toString()),
                                                  //                           amount: double.parse(e.sELLINGPRICE.toString()),
                                                  //                           tr: e.tR.toString(),
                                                  //                           isChange: false,
                                                  //                         );
                                                  //                       } else {
                                                  //                                   if (cart.cart.where((product) => product.tr.contains(e.tR.toString())).isNotEmpty) {
                                                  //                                     cart.cartUpdate(
                                                  //                                         tr: e.tR
                                                  //                                             .toString(),
                                                  //                                         qty: value);
                                                  //                                   } else {
                                                  //                                     cart.createCart(
                                                  //                                       productCode: widget.results.pRODCODE,
                                                  //                                       qty: 1,
                                                  //                                       name: widget.results.pRODUCT,
                                                  //                                       rate: double.parse(e.sELLINGPRICE.toString()),
                                                  //                                       amount: double.parse(e.sELLINGPRICE.toString()),
                                                  //                                       tr: e.tR.toString(),
                                                  //                                       isChange: false,
                                                  //                                     );
                                                  //                                   }
                                                  //                       }
                                                  //               } else if (value > 1) {
                                                  //                 cart.cartUpdate(
                                                  //                     tr: e.tR.toString(),
                                                  //                     qty: value);
                                                  //               } else {
                                                  //                 cart.cart.removeWhere((element) => element.tr == e.tR.toString());
                                                  //               }
                                                  //               setState(() {
                                                  //                 e.count = value;
                                                  //               });
                                                  //       } else {
                                                  //         Fluttertoast.showToast(
                                                  //             msg:'You reach the product limit');
                                                  //       }
                                                  //
                                                  //     },
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: width * 0.04,
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileTitle extends StatelessWidget {
  ProfileTitle(
      {Key key,
      @required this.width,
      @required this.product,
      @required this.additem,
      this.setLoading})
      : super(key: key);

  final double width;
  final Results product;
  final bool additem;
  var setLoading;
  final Shader linearGradient = LinearGradient(
    end: Alignment.topRight,
    begin: Alignment.bottomLeft,
    colors: <Color>[
      themeColor1,
      themeColor1,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              // additem
              //     ? InkWell(
              //         onTap: price.sTATUS == "N"
              //             ? null
              //             : () {
              //                 AwesomeDialog(
              //                   context: context,
              //                   dialogType: DialogType.INFO_REVERSED,
              //                   animType: AnimType.BOTTOMSLIDE,
              //                   title: 'Waring Alert',
              //                   desc:
              //                       'Ager Offer ek dafa close kar di to dubara opent nh kar sakty',
              //                   btnOkOnPress: () async {
              //                     setLoading(true);
              //                     var response =
              //                         await OnlineDataBase.postCloseOffer(
              //                                 tr: price.tR.toString())
              //                             .then((value) {
              //                           setLoading(true);
              //                       Get.to(TradingMainScreen());
              //                     }).catchError((e) {
              //                       setLoading(false);
              //                       Fluttertoast.showToast(
              //                           msg: "Error: ${e.toString()}");
              //                     });
              //                     //Get.back();
              //                   },
              //                 ).show();
              //               },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(5),
              //             color: Colors.white,
              //             gradient: LinearGradient(
              //                 end: Alignment.topRight,
              //                 begin: Alignment.bottomLeft,
              //                 colors: <Color>[
              //                   price.sTATUS == "N"
              //                       ? Colors.grey
              //                       : const Color(0xFFFF0900),
              //                   price.sTATUS == "N"
              //                       ? Colors.grey
              //                       : const Color(0xFFFF9F00),
              //                 ]),
              //           ),
              //           padding: EdgeInsets.symmetric(
              //               vertical: width * 0.02, horizontal: width * 0.045),
              //           child: Text(
              //             price.sTATUS == "N" ? "OFFER CLOSED" : "REMOVE OFFER",
              //             style: TextStyle(
              //                 color: Colors.white, fontWeight: FontWeight.bold),
              //           ),
              //         ),
              //       )
              //     : Container(),
            ],
          ),
          SizedBox(
            width: width * 0.03,
          ),
          Expanded(
            child: Container(
              // color: Colors.amber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          product.bRAND,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient),
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
                  if (product.mODEL != null)
                    Text(
                      product.mODEL,
                      maxLines: 1,
                      style: TextStyle(fontSize: 12),
                    ),
                  SizedBox(
                    height: width * 0.02,
                  ),
                  if (product.dESCRIPTION != null)
                    Text(
                      product.dESCRIPTION,
                      maxLines: 1,
                      style: TextStyle(fontSize: 12),
                    ),
                  SizedBox(
                    height: width * 0.04,
                  ),
                  // product.oFFERITEM == "Y"
                  //     ? Container(
                  //         height: width * 0.32,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(7),
                  //           color: Colors.white,
                  //         ),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.stretch,
                  //           children: [
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Column(
                  //                   children: [
                  //                     Text(
                  //                       "QTY",
                  //                       style: TextStyle(
                  //                         fontSize: 13,
                  //                           fontWeight: FontWeight.bold),
                  //                     ),
                  //                     SizedBox(
                  //                       height: width * 0.02,
                  //                     ),
                  //                     Text(
                  //                       price.qTY.toString(),
                  //                       style: TextStyle(fontSize: width * 0.03),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(
                  //                   width: width * 0.02,
                  //                 ),
                  //                 Column(
                  //                   children: [
                  //                     Text(
                  //                       "RATE",
                  //                       style: TextStyle(fontSize: 13,
                  //                           fontWeight: FontWeight.bold),
                  //                     ),
                  //                     SizedBox(
                  //                       height: width * 0.02,
                  //                     ),
                  //                     Text(
                  //                       price.rATE.toStringAsFixed(0),
                  //                       style: TextStyle(fontSize: width * 0.03),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(
                  //                   width: width * 0.02,
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: width * 0.02,
                  //             ),
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Column(
                  //                   children: [
                  //                     Text(
                  //                       "MRP",
                  //                       style: TextStyle(fontSize: 13,
                  //                           fontWeight: FontWeight.bold),
                  //                     ),
                  //                     SizedBox(
                  //                       height: width * 0.02,
                  //                     ),
                  //                     Text(
                  //                       price.mRP,
                  //                       style: TextStyle(fontSize: width * 0.03),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(
                  //                   width: width * 0.02,
                  //                 ),
                  //                 Column(
                  //                   children: [
                  //                     Text(
                  //                       "EXPIRE",
                  //                       style: TextStyle(fontSize: 13,
                  //                           fontWeight: FontWeight.bold),
                  //                     ),
                  //                     SizedBox(
                  //                       height: width * 0.02,
                  //                     ),
                  //                     Text(
                  //                       price.eNTRYDATE.substring(0, 10),
                  //                       style: TextStyle(fontSize: width * 0.03),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(
                  //                   width: width * 0.02,
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: width * 0.02,
                  //             ),
                  //             Expanded(
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Container(
                  //                     decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(5),
                  //                       color: Colors.white,
                  //                       gradient: LinearGradient(
                  //                           end: Alignment.topRight,
                  //                           begin: Alignment.bottomLeft,
                  //                           colors: <Color>[
                  //                             price.sTATUS == "N"
                  //                                 ? Colors.grey
                  //                                 : const Color(0xFF22E774),
                  //                             price.sTATUS == "N"
                  //                                 ? Colors.grey
                  //                                 : const Color(0xFF0C9933),
                  //                           ]),
                  //                     ),
                  //                     padding: EdgeInsets.symmetric(
                  //                         vertical: width * 0.02,
                  //                         horizontal: width * 0.04),
                  //                     child: Text(
                  //                       "Stock ${price.bALANCE}",
                  //                       style: TextStyle(
                  //                           color: Colors.white,
                  //                           fontWeight: FontWeight.bold),
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                     width: width * 0.02,
                  //                   ),
                  //                   Container(
                  //                     decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(5),
                  //                       color: Colors.white,
                  //                       gradient: LinearGradient(
                  //                           end: Alignment.topRight,
                  //                           begin: Alignment.bottomLeft,
                  //                           colors: <Color>[
                  //                             price.sTATUS == "N"
                  //                                 ? Colors.grey
                  //                                 : const Color(0xFF22E774),
                  //                             price.sTATUS == "N"
                  //                                 ? Colors.grey
                  //                                 : const Color(0xFF0C9933),
                  //                           ]),
                  //                     ),
                  //                     padding: EdgeInsets.symmetric(
                  //                         vertical: width * 0.02,
                  //                         horizontal: width * 0.04),
                  //                     child: Text(
                  //                       "Sold: ${price.pURBALANCE}",
                  //                       style: TextStyle(
                  //                           color: Colors.white,
                  //                           fontWeight: FontWeight.bold),
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                     width: width * 0.02,
                  //                   ),
                  //                 ],
                  //               ),
                  //             )
                  //             // Row(
                  //             //   children: [
                  //             //
                  //             //
                  //             //   ],
                  //             // )
                  //             // Expanded(
                  //             //   child: ListView.separated(
                  //             //       itemBuilder: (context, index) {
                  //             //         return Container(
                  //             //           child: Row(
                  //             //             mainAxisAlignment:
                  //             //             MainAxisAlignment.spaceEvenly,
                  //             //             children: [
                  //             //             ],
                  //             //           ),
                  //             //         );
                  //             //       },
                  //             //       separatorBuilder: (context, index) {
                  //             //         return SizedBox(
                  //             //           height: width * 0.01,
                  //             //         );
                  //             //       },
                  //             //       itemCount: product.pRICE.length),
                  //             // )
                  //           ],
                  //         ),
                  //       )
                  //     : Container(
                  //         alignment: Alignment.center,
                  //         height: width * 0.2,
                  //         child: Text(
                  //           "No Offer Found",
                  //           style: TextStyle(color: Colors.grey),
                  //         ),
                  //       ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
