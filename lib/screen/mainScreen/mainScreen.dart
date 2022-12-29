import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/addressModel.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/newCustomerModel.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/AddCustomer/add_customer_screen.dart';
import 'package:salesmen_app_new/screen/BankAccountScreen/bank_account_screen.dart';
import 'package:salesmen_app_new/screen/History_Screen/history_screen.dart';
import 'package:salesmen_app_new/screen/ReportsScreen/report_screen.dart';
import 'package:salesmen_app_new/screen/ShowDelivery/show_delivery_screen.dart';
import 'package:salesmen_app_new/screen/agingScreen/aging_card.dart';
import 'package:salesmen_app_new/screen/allShopScreen/allShopScreen.dart';
import 'package:salesmen_app_new/screen/assignShopScreen/AssignShopScreen.dart';
import 'package:salesmen_app_new/screen/duesShop/duesShopScreen.dart';
import 'package:salesmen_app_new/screen/loginScreen/verify_phoneno_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _serviceEnabled = false;
  loc.Location location = new loc.Location();
  calculateDistance(double lat1, double long1, double lat2, double long2) {
    var distance = geo.Geolocator.distanceBetween(lat2, long2, lat1, long1);
    return distance / 1000;
  }

  void getAllCustomerData(bool data) async {
    if (true) {
      try {
        Provider.of<CustomerList>(context, listen: false).setLoading(true);
        var data = await location.getLocation();
        List<AddressModel> addressList = [];
        userLatLng = Coordinates(data.latitude, data.longitude);
        String mapApiKey = "AIzaSyDhBNajNSwNA-38zP7HLAChc-E0TCq7jFI";
        String _host = 'https://maps.google.com/maps/api/geocode/json';
        final url =
            '$_host?key=$mapApiKey&language=en&latlng=${userLatLng.latitude},${userLatLng.longitude}';
        print(url);
        if (userLatLng.latitude != null && userLatLng.longitude != null) {
          var response1 = await http.get(Uri.parse(url));
          if (response1.statusCode == 200) {
            Map data = jsonDecode(response1.body);
            String _formattedAddress = data["results"][0]["formatted_address"];
            var address = data["results"][0]["address_components"];
            for (var i in address) {
              addressList.add(AddressModel.fromJson(i));
            }
            actualAddress = addressList[3].shortName;
            Provider.of<CustomerList>(context, listen: false)
                .updateAddress(actualAddress);
            print("response ==== $_formattedAddress");
            _formattedAddress;
          }



          var response = await OnlineDatabase.getDuesShop();
          print("Response code is " + response.statusCode.toString());
          if (response.statusCode == 200) {
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            for (var item in data["results"]) {
              customer.add(CustomerInfo.fromJson(item));
              print(item['CUST_CODE']);
            }
            Provider.of<CustomerList>(context, listen: false).clearList();
            Provider.of<CustomerList>(context, listen: false).getDues(customer);




            var response1 = await OnlineDatabase.getAssignShop();
            print("Response code is " + response1.statusCode.toString());
            if (response1.statusCode == 200) {
              var data = jsonDecode(utf8.decode(response1.bodyBytes));
              for (var item in data["results"]) {
                customer.add(CustomerInfo.fromJson(item));
                print(item['CUST_CODE']);
              }
              Provider.of<CustomerList>(context, listen: false).getAssignShop(customer);
            }





            //print("Response is" + data.toString());

            //var dist=calculateDistance(double.parse(item["LATITUDE"].toString().toLowerCase()=="null"?1.toString():item["LATITUDE"].toString()), double.parse(item["LONGITUDE"].toString().toLowerCase()=="null"?1.toString():item["LONGITUDE"].toString()),userLatLng.latitude,userLatLng.longitude);
            //print(dist.toString());
            // print(item['CUSTOMER']);
            // print(item['LATITUDE']);
            // print(item['LONGITUDE']);

            // for(int i=0; i < customer.length-1; i++){
            //   for(int j=0; j < customer.length-i-1; j++){
            //     if(double.parse(customer[j].distances) > double.parse(customer[j+1].distances)){
            //       CustomerInfo temp = customer[j];
            //       customer[j] = customer[j+1];
            //       customer[j+1] = temp;
            //     }
            //   }
            // }

            // Provider.of<CustomerList>(context, listen: false)
            //     .storeResponse(data);
            // Provider.of<CustomerList>(context, listen: false)
            //     .getAllCustomer(customer);
            //print("done");
            setState(() {});
            //print("length is"+limitedcustomer.length.toString());
            Provider.of<CustomerList>(context, listen: false).setLoading(false);
          } else if (response.statusCode == 400) {
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            Fluttertoast.showToast(
                msg: "${data['results'].toString()}",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: 16.0);
            Provider.of<CustomerList>(context, listen: false).setLoading(false);
          }
        }
      } catch (e, stack) {
        print('exception is' + e.toString());
        Fluttertoast.showToast(
            msg: "Error: " + e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
        Provider.of<CustomerList>(context, listen: false).setLoading(false);
      }
    }
  }

  Coordinates userLatLng;

  var actualAddress = "Searching....";

  List<CustomerInfo> customer = [];
  getWalletStatus() async {
    var response2 = await OnlineDatabase.getWalletStatus().catchError((error) {
      Fluttertoast.showToast(
          msg: "Error: " + error.toString(), toastLength: Toast.LENGTH_LONG);
    });
    if (response2.statusCode == 200) {
      var data2 = jsonDecode(utf8.decode(response2.bodyBytes));
      print("get wallet data is: " + data2.toString());
      Provider.of<UserModel>(context, listen: false).getWalletStatus(data2);
    } else {
      Fluttertoast.showToast(
          msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
    }
  }

  // void onStart()async{
  //
  //
  //
  //   loc.Location location = new loc.Location();
  //   var _location = await location.getLocation();
  //     _serviceEnabled = true;
  //     actualAddress = "Searching....";
  //   userLatLng =Coordinates(_location.latitude, _location.longitude);
  //   print("userLatLng: " + userLatLng.toString());
  //   var addresses = await Geocoder.local.findAddressesFromCoordinates(userLatLng);
  //   actualAddress = addresses.first.subLocality.toString();
  //   print(actualAddress);
  //   setState(() {});
  // }

  @override
  void initState() {
    getWalletStatus();
    getAllCustomerData(true);
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: themeColor1),
                ),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text(
                  'Yes',
                  style: TextStyle(color: themeColor1),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var address = Provider.of<CustomerList>(context).address;
    final userData = Provider.of<UserModel>(context, listen: true);
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Center(
                child: Text(
              "DashBoard",
              style: TextStyle(color: Colors.white),
            )),
            actions: [
              SizedBox(
                width: 15,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Center(
                  child: VariableText(
                    text: address,
                    fontsize: 15,
                    fontcolor: Colors.white,
                    fontFamily: fontRegular,
                    weight: FontWeight.w300,
                  ),
                ),
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset("assets/images/dues.png",color: Colors.white,width: 20,height: 20,),
                    //SizedBox(width: 5,),
                    Text(
                      "Dues Shop",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: width * 0.04),
                      child: Text(
                        "Assign Shop",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: themeColor1,
              onPressed: ()=>Get.to(AllShopScreen()),
              label: Text("All Shop")),
          drawer: Drawer(
            child: Container(
              child: Column(
                children: <Widget>[
                  DrawerHeader(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  "https://erp.suqexpress.com${userData.userName}",
                                  cacheHeight: 70,
                                  cacheWidth: 70,
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return Image.asset(
                                      "assets/images/gear.png",
                                      width: 50,
                                      height: 50,
                                    );
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                            Spacer(),
                            Image.asset('assets/images/splashlogo.png',
                                scale: 8.5)
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        VariableText(
                          text: userData.userName +
                              " (" +
                              userData.userEmpolyeeNumber +
                              ")",
                          fontsize: 16,
                          fontcolor: textcolorblack,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: height * 0.0055,
                        ),
                        VariableText(
                          text: userData.phoneNumber.toString(),
                          fontsize: 12,
                          fontcolor: textcolorgrey,
                          fontFamily: fontRegular,
                          weight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: height * 0.0055,
                        ),
                        VariableText(
                          text: "Limit: " +
                              userData.usercashReceive.toString() +
                              ' / ' +
                              userData.usercashLimit.toString(),
                          fontsize: 12,
                          fontcolor: textcolorgrey,
                          fontFamily: fontRegular,
                          weight: FontWeight.w400,
                        ),
                      ],
                    ),
                  )),
                  DrawerList(
                    text: 'Home',
                    imageSource: "assets/icons/home.png",
                    selected: true,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  DrawerList(
                    text: 'Add Customer',
                    imageSource: "assets/icons/addcustomer.png",
                    selected: false,
                    onTap: () async {
                      var location = await loc.Location().getLocation();
                      var currentLocation =
                          Coordinates(location.latitude, location.longitude);
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCustomerScreen(
                                    locationdata: currentLocation,
                                  )));
                    },
                  ),
                  DrawerList(
                    text: 'Reports',
                    imageSource: "assets/icons/ledger.png",
                    selected: false,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportsScreen(
                                    userdata: userData,
                                  )));
                    },
                  ),
                  DrawerList(
                      text: 'Customer Ordes',
                      imageSource: "assets/icons/totalitem.png",
                      selected: false,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowDeliveryScreen()));
                      }),
                  DrawerList(
                      text: 'AGING',
                      imageSource: "assets/icons/aging.png",
                      selected: false,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AgingScreen()));
                      }),
                  DrawerList(
                      text: 'Bank Account',
                      imageSource: "assets/icons/bankaccount.png",
                      selected: false,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BankAccountScreen()));
                      }),
                  DrawerList(
                    text: 'History',
                    imageSource: "assets/icons/history.png",
                    selected: false,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HistoryScreen()));
                    },
                  ),
                  DrawerList(
                    text: 'Logout',
                    imageSource: "assets/icons/logout.png",
                    selected: false,
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('phoneno');
                      prefs.remove('password');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyPhoneNoScreen()));
                    },
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0),
                    color: Color(0xffFCFCFC),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: VariableText(
                        text: "@ SKR Sales Link 2021. Version 1.0.0",
                        fontsize: 14.5,
                        weight: FontWeight.w400,
                        fontcolor: textcolorgrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              DuesShopScreen(
                user: userData,
              ),
              AssignShopScreen(),
              //AllShopScreen(user:userData),
            ],
          ),
        ),
      ),
    );
  }
}
