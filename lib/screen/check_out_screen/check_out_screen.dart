import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/new_customer_model.dart';
import 'package:salesmen_app_new/newModel/cartModel.dart';
import 'package:salesmen_app_new/newModel/productModel.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/checkinScreen/checkin_screen.dart';
import 'package:salesmen_app_new/screen/mainScreen/mainScreen.dart';


class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  bool isLoading = false;
  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  postSalesOrder(List<NewCartModel> list, String customerCode) async {
    if (list.isNotEmpty) {
      setLoading(true);
      var location = await Location().getLocation();
      var response = await OnlineDatabase.postNewSalesOrder(
              cart: list,
              lat: location.latitude.toString(),
              long: location.longitude.toString(),
              customerCode: customerCode)
          .catchError((e) {
        setLoading(false);
      });
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      print("response statusCode: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        Provider.of<AddToCartModel>(context, listen: false).cartClear();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Order Post Successfully',
          desc: 'Your Order post Successfully return to main screen',
          btnOkOnPress: () {
            Get.to(CheckInScreen());
          },
        ).show();
        setLoading(false);
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Something Went wrong',
          desc: data['results'].toString(),
          btnOkOnPress: () {
            setLoading(false);
          },
        ).show();
      }
    } else {
      Fluttertoast.showToast(msg: "Your cart is empty");
    }
  }

  bool flag = false;
  getProduct(
    List<NewCartModel> cart,
  ) async {}

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<AddToCartModel>(context);
    var userData = Provider.of<CustomerList>(context).singleCustomer;
    var width = MediaQuery.of(context).size.width;

    double total = 0.00;
    for (var i in cart.cart) {
      total = total + i.amount;
    }
    return WillPopScope(
      onWillPop: ()=>Get.to(CheckInScreen()),
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(
                  "Checkout",
                  style: TextStyle(color: Colors.white),
                ),
                leading: IconButton(
                  onPressed: () {
                    Get.to(CheckInScreen());
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                height: width * 0.2,
                padding: EdgeInsets.symmetric(
                    vertical: width * 0.04, horizontal: width * 0.04),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          cart.cart.isNotEmpty ? themeColor1 : Colors.grey)),
                  onPressed: () async{
                    if (cart.cart.isNotEmpty) {
                      for (var i in cart.cart) {
                        setLoading(true);
                        var response =
                            await OnlineDatabase.getSingleProduct(productCode: i.productCode,isPromotional: 1).then((value){
                              var data = jsonDecode(utf8.decode(value.bodyBytes));
                              if (value.statusCode == 200) {
                                Product  product = Product.fromJson(data);
                                if(product.results.first.oFFERITEM == "Y"){
                                  for(var j in product.results[0].pRICE){
                                    if(j.tR.toString() == i.tr){
                                      if(i.rate<j.sELLINGPRICE ||i.rate>j.sELLINGPRICE){
                                        flag=true;
                                        i.isChange=true;
                                        i.rate=j.sELLINGPRICE;
                                        i.amount=j.sELLINGPRICE * i.qty;
                                      }
                                      if(j.bALANCE < i.qty){
                                        flag=true;
                                        i.isChange=true;
                                        i.qty=j.bALANCE;
                                        if(j.sTATUS == "N"){
                                          i.qty=0;
                                          i.amount=0;
                                          i.isChange=true;
                                          flag=true;
                                        }
                                      }
                                      Future.delayed(Duration(microseconds: 5),(){
                                        if(j.sTATUS == "N"){
                                          flag=true;
                                          i.isChange=true;
                                          i.qty=0;
                                          i.amount=0;
                                        }
                                      });

                                    }
                                  }
                                }else{
                                  flag=true;
                                  i.isChange=true;
                                }
                              }
                              setState(() {});
                            });

                      }
                        if(flag){
                          setLoading(false);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Waring Alert',
                            desc: "Ap ke order me rate or quantity ki tabdili ki gai ha. check kar ke order bhejie.",
                            btnOkOnPress: (){},
                          ).show();
                        }else{
                          setLoading(false);
                          //print("galat baat");
                          postSalesOrder(cart.cart, userData.customerCode.toString());
                        }
                    } else {
                      Fluttertoast.showToast(msg: "Your cart is empty");
                    }
                    setState(() {});
                    // postSalesOrder(cart.cart, userData.customerCode);
                  },
                  child: Text("Checkout   (${total.toStringAsFixed(2)})"),
                ),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(
                    vertical: width * 0.04, horizontal: width * 0.04),
                child: cart.cart.isEmpty
                    ? Center(
                        child: Text("Your cart is Empty"),
                      )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                          Text("<---- Swap left to Delete",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey),),
                          Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: UniqueKey(),
                                    onDismissed: (dismiss) {
                                      setState(() {
                                        cart.cart.removeAt(index);
                                        flag=false;
                                      });
                                    },
                                    child: ListTile(
                                      selectedTileColor:
                                          Colors.blueAccent.withOpacity(0.2),
                                      selected: cart.cart[index].isChange,
                                      leading: CircleAvatar(
                                        backgroundColor: themeColor1,
                                        child: Text(
                                          cart.cart[index].qty.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      title: Text(
                                        cart.cart[index].name,
                                        maxLines: 1,
                                      ),
                                      subtitle: Text(
                                          "${cart.cart[index].productCode}  (${cart.cart[index].rate.toString()})"),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            cart.cart[index].amount
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                color: themeColor1, fontSize: 18),
                                          ),
                                          Text(
                                            "Total value",
                                            style: TextStyle(
                                                color: Colors.grey, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                                itemCount: cart.cart.length),
                          )
                        ],
                      ),
              ),
            ),
            isLoading
                ? Positioned.fill(
                    child: ProcessLoading(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
