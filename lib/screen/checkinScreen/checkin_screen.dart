import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/box_model.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/delivery_model.dart';
import 'package:salesmen_app_new/model/new_customer_model.dart';
import 'package:salesmen_app_new/model/product_model.dart';
import 'package:salesmen_app_new/model/wallet_capacity.dart';
import 'package:salesmen_app_new/screen/EditShop/edit_shop.dart';
import 'package:salesmen_app_new/screen/MechanicScreen/mechanicScreen.dart';
import 'package:salesmen_app_new/screen/mainScreen/mainScreen.dart';
import 'package:salesmen_app_new/widget/loding_indicator.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/OrderScreen/categories_screen.dart';
import 'package:salesmen_app_new/screen/deliveryScreen/deliveryScreen.dart';
import 'package:salesmen_app_new/screen/ledgerScreen/ledgerScreen.dart';
import 'package:salesmen_app_new/screen/other/other.dart';
import 'package:salesmen_app_new/screen/paymentScreen/paymentScreen.dart';

class CheckInScreen extends StatefulWidget {
  CustomerModel shopDetails;double distance;
  CheckInScreen({this.shopDetails,this.distance});

  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCustomerTransactionData();
    getSliderImage();
    showDistance();
    getAllProductCategory();
    getAllSearchProduct();
    //getMainDeliveryDetails();
  }
  void getAllSearchProduct() async {
    try {
      List<ProductModel>searchProduct=[];
      setLoading(true);
      var response = await OnlineDatabase.getAllproductsubcategory(
          subTypeId: "", maintypeId: "");
      print("Response is" + response.statusCode.toString());
      //print("Response is" + response .toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        searchProduct = [];
        var datalist = data['results'];
        // print("data is "+datalist.toString());
        if (datalist.isNotEmpty) {
          for (var item in datalist) {
            searchProduct.add(ProductModel.fromJson(item));
          }

          Provider.of<CustomerList>(context,listen: false).clearProductSearchList();

          Provider.of<CustomerList>(context,listen: false).addSearchProduct(searchProduct);
          setLoading(false);
        } else {
          setLoading(false);
          Fluttertoast.showToast(
              msg: "Product not found",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 16.0);
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
      } else if (response.statusCode == 401) {
        setLoading(false);
        Fluttertoast.showToast(
            msg: "User not found",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e, stack) {
      print('exception is' + e.toString() + stack.toString());
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Something went wrong try again later",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  void getCustomerTransactionData() async {
    setLoading(true);
    try {
      double walletCapacity = 0;
      double usedBalance = 0;
      double availableBalance = 0.0;
      var response = await OnlineDatabase.getTranactionDetails(
          customerCode: widget.shopDetails.customerCode);
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
  getSliderImage()async{
    List<Widget> imageContainer=[];
    Uri url=Uri.parse("https://suqexpress.com/api/getsliderimages");
    var response= await http.get(url).then((response) {
      print(response.body);
      if(response.statusCode==200){
        var data=jsonDecode(utf8.decode(response.bodyBytes));
        var item=data['data'];
        for (var image in item){
          var temp=ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(image['url'],fit: BoxFit.fill,cacheHeight: 200,width: 500,filterQuality: FilterQuality.low,),
          );
          print(image["url"]);
          imageContainer.add(temp);
          Provider.of<CustomerList>(context,listen: false).clearSliderImage();
          Provider.of<CustomerList>(context,listen: false).sliderPicture(imageContainer);
        }
      }
    });
  }
  void getAllProductCategory() async {
    try {
      var response = await OnlineDatabase.getAllCategories();
      print("Response is" + response.statusCode.toString());
      //print("Response is" + response .toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        List<ProductModel>  product = [];
        var datalist = data['results'];
        // print("data is "+datalist.toString());
        if (datalist.isNotEmpty) {
          for (var item in datalist) {
            product.add(ProductModel.getProductMainCategory(item));
          }
          Provider.of<CustomerList>(context,listen: false).clearProductList();
          Provider.of<CustomerList>(context,listen: false).addProduct(product);
        } else {
          Fluttertoast.showToast(
              msg: "Product not found",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else if (response.statusCode == 400) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        Fluttertoast.showToast(
            msg: "${data['results'].toString()}",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "User not found",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e, stack) {
      print('exception is' + e.toString() + stack.toString());
      Fluttertoast.showToast(
          msg: "Something went wrong try again later",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  calculateDistance(double lat,double long)async{
    Location location = new Location();
    var _location = await location.getLocation();
    print(_location.latitude);
    print(_location.longitude);
    var distance = geo.Geolocator.distanceBetween(
        _location.latitude, _location.longitude,
        lat, long);
    return distance;
  }
  void showDistance()async{

    if(widget.distance > 100){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: widget.distance.toStringAsFixed(0)+" m",
        desc: "Dukan ki location update karo warna fuel expense nahi milega.",
        btnOkText: "Update",
        btnCancelText: "Ok",
        dismissOnTouchOutside: false,
        btnCancelOnPress: () {
        },
        btnOkOnPress: () async{
          var response = await OnlineDatabase.getSingleCustomer(widget.shopDetails.customerCode);
          print("Response is" + response.statusCode.toString());
          if (response.statusCode == 200) {
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            // print("Response is" + data.toString());
            var userDetail =  CustomerModel.fromModel(data['results'][0]);
            print(userDetail.editable);
            if(userDetail.editable == 'Y'){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditShopScreen(
                        shopData: widget.shopDetails,
                      )));
            }else{
              Fluttertoast.showToast(
                  msg: "Edit not allowed. Call to open edit shop",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 16.0);
              showDistance();
            }
          }
          else if (response.statusCode != 200) {
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            setLoading(false);
            Fluttertoast.showToast(
                msg: "Internet Issue",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
      )..show();
    }
  }

  // Delivery Api`s
  Future<bool>_willPopScope(){
    Provider.of<CartModel>(context,listen:false).clearCart();
    return Navigator.push(
        context, MaterialPageRoute(builder: (_) => MainScreen()));
  }


  @override
  Widget build(BuildContext context) {
    CustomerModel myCustomer=Provider.of<CustomerList>(context).singleCustomer;
    WalletCapacity wallet=Provider.of<WalletCapacity>(context);
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return WillPopScope(
      onWillPop:_willPopScope ,
      child: Stack(
        children: [
          Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              tooltip: "Mechanic",
              autofocus: true,
              backgroundColor: themeColor1,
              label:Row(
                children: [
                  Text("Mechanic",style: TextStyle(color: Colors.white),),
                  SizedBox(width: 15,),
                  Icon(Icons.arrow_forward,color: Colors.white,),
                ],
              ) ,
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>MechanicScreen())),),
            appBar: MyAppBar(
              title: 'Check-In',
              ontap: () =>_willPopScope(),
            ),
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
                              child: Image.asset("assets/icons/person.png",color: Colors.grey,),
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
                                    text: myCustomer.customerShopName.toString()
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
                                            text: myCustomer.customerCode,
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

                      ],
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
                                    text:wallet.capacity.toString()=="null"?"- -": "Rs. " +
                                        f.format(double.parse(wallet.capacity.toString().length<5?wallet.capacity.toString(): wallet.capacity.toStringAsFixed(2),)),

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
                                    text:wallet.usedBalance.toString()=="null"?"- -":
                                    "Rs " + f.format(double.parse(wallet.usedBalance.toString().length<5? wallet.usedBalance.toString(): wallet.usedBalance.toStringAsFixed(2),)),

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
                                    text:wallet.availableBalance.toString()=="null"?"- -":
                                    "Rs. " +
                                        f.format(double.parse(wallet.availableBalance.toString().length<5?wallet.availableBalance.toString(): wallet.availableBalance.toStringAsFixed(2))),
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
                                              builder: (context) => DeliveryScreen(shopDetails: myCustomer,)));
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
                                              builder: (_) => LedgerScreen(balance: wallet.availableBalance.toString(),shopDetails: myCustomer,)));
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
          isLoading ? Positioned.fill(child: ProcessLoading()) : Container(),
        ],
      ),
    );
  }

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
}
