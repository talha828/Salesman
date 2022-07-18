import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/cart/cart_screen.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/new_customer_model.dart';
import 'package:salesmen_app_new/model/product_model.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/model/wallet_capacity.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/OrderScreen/sucessfully_generated_order_screen.dart';


class CheckOutScreen extends StatefulWidget {



  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  bool skrColor = true;
  bool otherColor = true;
  bool isLoading = false;
  String orderID ;
  int navigate = 0;
  List<CartModel> cartList = [];
  List<double> total = [];
  List brandName = [];
  Future<void> getCustomerTransactionData(String code) async {
    setLoading(true);
    try {
      double walletCapacity = 0;
      double usedBalance = 0;
      double availableBalance = 0.0;
      var response = await OnlineDatabase.getTranactionDetails(
          customerCode: code);
      //print("Response is: "+response.statusCode.toString()+widget.shopDetails.customerCode );
      print("getTransactionDetails: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // print("data is"+data.toString());
        var datalist = data['results'];
        walletCapacity =
            double.parse(datalist[0]['CREDIT_LIMIT'].toString()) ?? 0.0;
        usedBalance = double.parse(datalist[0]['BALANCE'].toString()) ?? 0.0;
        availableBalance = walletCapacity - usedBalance;
        Provider.of<WalletCapacity>(context, listen: false)
            .setWalletCapacity(walletCapacity, usedBalance, availableBalance);
        setLoading(false);
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
        setLoading(false);

      }
    } catch (e, stack) {
      print('exception is' + e.toString());
      Fluttertoast.showToast(
          msg: "Something went wrong try again later",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
      setLoading(false);

    }
  }

  void getTotal(CartModel tempCart, String skr) {
    double temp = 0;
    int index = 0;
    for (var item in tempCart.cartItemName) {
      if (skr == item.productName.brand.toString().substring(0, 3)) {
        temp = temp +
            double.parse((tempCart.cartItemName[index].itemCount *
                calculatePrice(
                    quantity: tempCart.cartItemName[index].itemCount,
                    productDetils:
                    tempCart.cartItemName[index].productName))
                .toString());
      }
      index++;
    }
    total.add(temp);
  }

  int paymentType = 0;
  CartModel sperateCart(CartModel cart, String skr) {
    CartModel tempCart = CartModel();

    for (var item in cart.cartItemName) {
      if (skr == item.productName.brand.toString().substring(0, 3)) {
        tempCart.cartItemName.add(item);
      }
    }
    cartList.add(tempCart);
    return tempCart;
  }

  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<CartModel>(context, listen: true);
    var userDetails = Provider.of<UserModel>(context, listen: true);
    CustomerModel customer=Provider.of<CustomerList>(context).singleCustomer;
    WalletCapacity wallet=Provider.of<WalletCapacity>(context);
    // var emp_id =
    //     Provider.of<UserModel>(context, listen: true).userEmpolyeeNumber;
    // var availableBalance =
    //     Provider.of<WalletCapacity>(context, listen: true).availableBalance;
    for (var i in cartData.cartItemName) {
      brandName.add(i.productName.brand);
      print(i.productName.brand);
    }
    cartList.clear();
    total.clear();
    for (var j in brandName.toSet()) {
      CartModel cart = sperateCart(cartData, j.toString().substring(0, 3));
      getTotal(cart, j.toString().substring(0, 3));
    }
    double subtotal = 0;
    for (var i in total) {
      subtotal = subtotal + i;
    }
    print(brandName.toSet().length);
    int nn = brandName.toSet().length;
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    dynamic check = cartData.cartItemName.where((element) =>
        element.productName.brand.toString().substring(0, 3).contains("SKR"));
    bool item = false;
    if (check.length >= 1) {
      item = true;
    } else {
      item = false;
    }
    total.clear();
    if (item) {
      var first = cartList
          .where((element) =>
      element.cartItemName[0].productName.brand
          .toString()
          .substring(0, 3) ==
          "SKR")
          .first;
      double temp = 0;
      int index = 0;
      for (var item in first.cartItemName) {
        temp = temp +
            double.parse((item.itemCount *
                calculatePrice(
                    quantity: item.itemCount,
                    productDetils: item.productName))
                .toString());
      }
      total.add(temp);
      var second = cartList
          .where((element) =>
      element.cartItemName[0].productName.brand
          .toString()
          .substring(0, 3) !=
          "SKR")
          .toList();
      for (var j in second) {
        double temp = 0;
        for (var item in j.cartItemName) {
          temp = temp +
              double.parse((item.itemCount *
                  calculatePrice(
                      quantity: item.itemCount,
                      productDetils: item.productName))
                  .toString());
        }
        total.add(temp);
      }
      cartList.clear();
      cartList.add(first);
      cartList.addAll(second);
    } else {
      var second = cartList
          .where((element) =>
      element.cartItemName[0].productName.brand
          .toString()
          .substring(0, 3) !=
          "SKR")
          .toList();
      cartList.clear();
      total.clear();
      for (var j in second) {
        double temp = 0;
        for (var item in j.cartItemName) {
          temp = temp +
              double.parse((item.itemCount *
                  calculatePrice(
                      quantity: item.itemCount,
                      productDetils: item.productName))
                  .toString());
        }
        total.add(temp);
      }
      cartList.addAll(second);
    }
    var f = NumberFormat("###,###.0#", "en_US");

    return Stack(
      children: [
        Scaffold(
          appBar: MyAppBar(
            title: 'Checkout',
            color: themeColor2,
            color2: textcolorblack,
            ontap: ()=>Navigator.pop(context),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              VariableText(
                                text: customer.customerShopName.length>15?customer.customerShopName.substring(0,15)+"...":customer.customerShopName,
                                fontsize: 13,
                                fontcolor: textcolorblack,
                                weight: FontWeight.w600,
                                line_spacing: 1.2,
                                textAlign: TextAlign.center,
                                fontFamily: fontRegular,
                              ),
                              SizedBox(
                                width: height * 0.008,
                              ),
                              VariableText(
                                text: customer.customerCode.toString()
                                    .toString(),
                                fontsize: 13,
                                fontcolor: textcolorblack,
                                weight: FontWeight.w400,
                                textAlign: TextAlign.start,
                                line_spacing: 1.2,
                                max_lines: 2,
                                fontFamily: fontRegular,
                              ),
                            ]),
                      ),
                      Container(
                        child: Row(children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                paymentType = 2;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: (paymentType == 0)
                                      ? Colors.transparent
                                      : (paymentType == 2)
                                      ? themeColor1
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: themeColor1,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Text(
                                  "Cash",
                                  style: TextStyle(
                                      color: (paymentType == 0)
                                          ? themeColor1
                                          : (paymentType == 2)
                                          ? Colors.white
                                          : themeColor1,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                paymentType = 1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: (paymentType == 0)
                                      ? Colors.transparent
                                      : (paymentType == 1)
                                      ? themeColor1
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: themeColor1,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Text(
                                  "Credit",
                                  style: TextStyle(
                                      color: (paymentType == 0)
                                          ? themeColor1
                                          : (paymentType == 1)
                                          ? Colors.white
                                          : themeColor1,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenpadding),
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: themeColor2,
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(31, 31, 31, 0.25),
                              offset: Offset(0, 0),
                              blurRadius: 1.5)
                        ]),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                if (index > -1) {
                                  return CheckOutCards(
                                    cartModel: cartList[index],
                                    total: total[index],
                                    onTap: () async {
                                      if (paymentType != 0) {
                                        Location _location=new Location();
                                        var data =await _location.getLocation();
                                        setLoading(true);
                                        var response = await OnlineDatabase
                                            .newpostSalesOrder(
                                            brand: cartList[index]
                                                .cartItemName[0]
                                                .productName
                                                .brand,
                                            sub_total: total[index]
                                                .toString(),
                                            emp_id: userDetails.id,
                                            paymentMethod: paymentType
                                                .toString(),
                                            cartData: cartList[index],
                                            lat:data.latitude.toString(),
                                            long: data.longitude.toString(),
                                            customerCode: customer.customerCode)
                                            .catchError(
                                              (e) => AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.INFO,
                                            useRootNavigator: false,
                                            animType: AnimType.BOTTOMSLIDE,
                                            title: "Something went wrong",
                                            desc:
                                            "Please check your available balances",
                                            btnCancelText: "Cart Page",
                                            dismissOnTouchOutside: false,
                                            btnOkOnPress: () {},
                                          )..show().then(
                                                  (value) => setLoading(false)),
                                        );
                                        if (response.statusCode == 200) {
                                          cartData.cartItemName.removeWhere(
                                                  (element) =>
                                              element.productName.brand ==
                                                  cartList[index]
                                                      .cartItemName[0]
                                                      .productName
                                                      .brand);
                                          brandName.removeWhere((element) =>
                                          element ==
                                              cartList[index]
                                                  .cartItemName[0]
                                                  .productName
                                                  .brand);
                                          paymentType = 0;
                                          cartList.remove(cartList[index]);
                                          var responseSms =
                                          await OnlineDatabase.sendText(
                                              customer.customerContactNumber,
                                              "آپ نے ہمارے نمائندے ${userDetails.firstName} کو ${total[index].toStringAsFixed(2)} کا آرڈر دیا ہے۔\nشکریہ۔");

                                          // var data = jsonDecode(utf8.decode(response.bodyBytes));
                                          orderID = response.data["message"]
                                              .toString()
                                              .substring(13)
                                              .trim();
                                          print(orderID);
                                             await getCustomerTransactionData(customer.customerCode);
                                          Fluttertoast.showToast(
                                              msg:
                                              "order placed successfully ${wallet.availableBalance.toStringAsFixed(2)}",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          if (cartList.length < 1) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SucessFullyGeneratedOrderScreen(
                                                          orderID: orderID,
                                                        )));
                                          }
                                          setLoading(false);
                                        } else {
                                          print("Response is" +
                                              response.statusCode.toString());
                                          Fluttertoast.showToast(
                                              msg:
                                              "Cannot palace order above ${wallet.availableBalance.toStringAsFixed(2)}",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                            "Please select Payment Method",
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.black87,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    },
                                    width: width,
                                    height: height,
                                  );
                                }
                                return Container();
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: brandName.toSet().length),
                          Container(
                            height: 1,
                            color: Color(0xffE0E0E0),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            children: [
                              VariableText(
                                text: 'Available Balances',
                                fontsize: 14,
                                fontcolor: textcolorgrey,
                                weight: FontWeight.w400,
                                fontFamily: fontRegular,
                              ),
                              Spacer(),
                              VariableText(
                                text: 'Rs. ' +
                                    f.format(double.parse(
                                        wallet.availableBalance.toStringAsFixed(
                                            2))), //${subtotal.toString()}',
                                fontsize: 14, fontcolor: textcolorgrey,
                                weight: FontWeight.w400,
                                fontFamily: fontRegular,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            height: 1,
                            color: Color(0xffE0E0E0),
                          ),
                          SizedBox(
                            height: height * 0.02,
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
                                    f.format(double.parse(
                                        subtotal.toStringAsFixed(
                                            2))), //${subtotal.toString()}',
                                fontsize: 14, fontcolor: textcolorgrey,
                                weight: FontWeight.w400,
                                fontFamily: fontRegular,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        isLoading ? Positioned.fill(child: ProcessLoading()) : Container()
      ],
    );
  }

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

  // void postsalesOrder(CartModel cartData, UserModel userDetails,
  //     String paymentMethod, bool go) async {
  //   try {
  //     setLoading(true);
  //     var response = await OnlineDataBase.postSalesOrder(
  //       emp_id: e,
  //         paymentMethod: paymentMethod,
  //         cartData: cartData,
  //         lat: widget.lat.toString(),
  //         long: widget.long.toString(),
  //         customerCode: widget.shopDetails.customerCode);
  //     print("Response is" + response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       var responseSms = await OnlineDataBase.sendText(
  //           widget.shopDetails.customerContactNumber,
  //           "آپ نے ہمارے نمائندے ${userDetails.userName} کو ${cartData.subTotal.toStringAsFixed(2)} کا آرڈر دیا ہے۔\nشکریہ۔");
  //
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       print(data.toString());
  //       String orderID = data['results'][0]['RESULT'].split(' ')[2];
  //       setLoading(false);
  //       if (go) {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (_) => SucessFullyGeneratedOrderScreen(
  //                       orderID: orderID,
  //                       shopDetails: widget.shopDetails,
  //                       lat: widget.lat,
  //                       long: widget.long,
  //                     )));
  //       }
  //     } else if (response.statusCode == 401) {
  //       setLoading(false);
  //       Fluttertoast.showToast(
  //           msg: "User not found",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       setLoading(false);
  //     } else {
  //       setLoading(false);
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       Fluttertoast.showToast(
  //           // msg: "${data.toString()}",
  //           msg: "Internet issue",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       setLoading(false);
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

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
}

class PaymentMethod extends StatelessWidget {
  PaymentMethod({this.text, this.onTap, this.boolCheck});
  final onTap;
  final boolCheck;
  final text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: boolCheck ? themeColor1 : Colors.transparent,
            border: Border.all(
              color: themeColor1,
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text(
            text,
            style: TextStyle(
                color: boolCheck ? Colors.white : themeColor1, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
