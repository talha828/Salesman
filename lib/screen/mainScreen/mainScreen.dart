
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/addressModel.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart'as http;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:salesmen_app_new/screen/AddCustomer/add_customer_screen.dart';
import 'package:salesmen_app_new/screen/BankAccountScreen/bank_account_screen.dart';
import 'package:salesmen_app_new/screen/History_Screen/history_screen.dart';
import 'package:salesmen_app_new/screen/agingReport/aging_card.dart';

import 'package:salesmen_app_new/screen/assignShopScreen/AssignShopScreen.dart';
import 'package:salesmen_app_new/screen/customer_screen/customer_screen.dart';
import 'package:salesmen_app_new/screen/ledgerScreen/ledgerScreen.dart';
import 'package:salesmen_app_new/screen/loginScreen/verify_phoneno_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _serviceEnabled = false;
  loc.Location location = new loc.Location();
  calculateDistance(double lat1,double long1,double lat2,double long2) {
    var distance = geo.Geolocator.distanceBetween(lat2,
        long2, lat1, long1);
    return distance / 1000;
  }
  void getAllCustomerData() async {
    try {
      var data =await location.getLocation();
      List<AddressModel>addressList=[];
      userLatLng=Coordinates(data.latitude,data.longitude);
      String mapApiKey="AIzaSyDhBNajNSwNA-38zP7HLAChc-E0TCq7jFI";
      String _host = 'https://maps.google.com/maps/api/geocode/json';
      final url = '$_host?key=$mapApiKey&language=en&latlng=${userLatLng.latitude},${userLatLng.longitude}';
      print(url);
      if(userLatLng.latitude != null && userLatLng.longitude != null){
        var response1 = await http.get(Uri.parse(url));
        if(response1.statusCode == 200) {
          Map data = jsonDecode(response1.body);
          String _formattedAddress = data["results"][0]["formatted_address"];
          var address = data["results"][0]["address_components"];
          for(var i in address){
            addressList.add(AddressModel.fromJson(i));
          }
          actualAddress=addressList[3].shortName;
          Provider.of<CustomerList>(context,listen: false).updateAddress(actualAddress);
          print("response ==== $_formattedAddress");
           _formattedAddress;
        }
      var response = await OnlineDatabase.getAllCustomer();
      print("Response code is " + response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        //print("Response is" + data.toString());
        int i=0;
        for (var item in data["results"]) {
          double dist=calculateDistance(double.parse(item["LATITUDE"].toString()=="null"?1.toString():item["LATITUDE"].toString()), double.parse(item["LONGITUDE"].toString()=="null"?1.toString():item["LONGITUDE"].toString()),userLatLng.latitude,userLatLng.longitude);
          customer.add(CustomerModel.fromModel(item,distance: dist));
          print(i);
          i++;
        }
        customer.sort((a,b)=>a.distance.compareTo(b.distance));
        Provider.of<CustomerList>(context,listen: false).add(customer);
        Provider.of<CustomerList>(context,listen: false).getDues(customer);
        Provider.of<CustomerList>(context,listen: false).getAssignShop(customer);
        print("done");
        setState(() {

        });
        //print("length is"+limitedcustomer.length.toString());
      } else if (response.statusCode == 400) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        Fluttertoast.showToast(
            msg: "${data['results'].toString()}",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }}
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
  Coordinates userLatLng;
  getAddressFromLatLng() async {
    var data =await location.getLocation();
    userLatLng=Coordinates(data.latitude,data.longitude);
    var lat=data.latitude;
    var lng=data.longitude;
    //userLatLng=Coordinates(lat, lng);setState(() {});
    List<AddressModel>addressList=[];
    String mapApiKey="AIzaSyDhBNajNSwNA-38zP7HLAChc-E0TCq7jFI";
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$mapApiKey&language=en&latlng=$lat,$lng';
    print(url);
    if(lat != null && lng != null){
      var response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String _formattedAddress = data["results"][0]["formatted_address"];
        var address = data["results"][0]["address_components"];
        for(var i in address){
          addressList.add(AddressModel.fromJson(i));
        }
        actualAddress=addressList[3].shortName;
        Provider.of<CustomerList>(context).updateAddress(actualAddress);
        print("response ==== $_formattedAddress");
        return _formattedAddress;
      } else return null;
    } else return null;
  }
  var actualAddress = "Searching....";

   List<CustomerModel> customer=[];


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
    //getAddressFromLatLng();
    getAllCustomerData();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context, listen: true);
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Center(child: Text("DashBoard",style: TextStyle(color: Colors.white),)),
          actions: [
            SizedBox(width: 15,),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
            //   child: Center(
            //     child: VariableText(
            //       text: actualAddress,
            //       fontsize: 15,
            //       fontcolor: Colors.white,
            //       fontFamily: fontRegular,
            //       weight: FontWeight.w300,
            //     ),
            //   ),
            // ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset("assets/tabviewicon/all.png",color: Colors.white,width: 24,height: 24,),
                    SizedBox(width: 10,),
                    Text("All Shop",style: TextStyle(color: Colors.white,fontSize: 16),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset("assets/tabviewicon/user.png",color: Colors.white,width: 24,height: 24,),
                    SizedBox(width: 10,),
                    Text("Assign Shop",style: TextStyle(color: Colors.white,fontSize: 16),)
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     children: [
              //       Image.asset("assets/icons/delivery.png",color: Colors.white,width: 24,height: 24,),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     children: [
              //       Image.asset("assets/icons/alliedmcb.png",color: Colors.white,width: 24,height: 24,),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Image.asset("assets/tabviewicon/dues.png"),
              // ),
            ],
          ),
        ),
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
                              Image.asset(
                                'assets/icons/profilepic.png',
                                scale: 3,
                              ),
                              Spacer(),
                              Image.asset('assets/images/splashlogo.png',
                                  scale: 8.5)
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          VariableText(
                            text: "talha ",
                            fontsize: 16,
                            fontcolor: textcolorblack,
                            fontFamily: fontMedium,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(
                            height: height * 0.0055,
                          ),
                          VariableText(
                            text: "talhaiqbal246@gmail.com",
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
                                "1000" + ' / ' +
                                "2000",
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
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,MaterialPageRoute(builder: (context)=>AddCustomerScreen()));
                  },
                ),
                DrawerList(
                  text: 'Reports',
                  imageSource: "assets/icons/ledger.png",
                  selected: false,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,MaterialPageRoute(builder: (context)=>LedgerScreen()));
                  },
                ),
                DrawerList(
                    text: 'Customer Ordes',
                    imageSource: "assets/icons/totalitem.png",
                    selected: false,
                    onTap: () {
                      // Navigator.of(context).pop();
                      // Navigator.push(context,
                      //     NoAnimationRoute(widget: ShowDeliveryScreen()));
                    }),
                DrawerList(
                    text: 'AGING',
                    imageSource: "assets/icons/aging.png",
                    selected: false,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,MaterialPageRoute(builder: (context)=>AgingScreen()));
                    }),
                DrawerList(
                    text: 'Bank Account',
                    imageSource: "assets/icons/bankaccount.png",
                    selected: false,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,MaterialPageRoute(builder: (context)=>BankAccountScreen(

                      )));
                    }),
                DrawerList(
                  text: 'History',
                  imageSource: "assets/icons/history.png",
                  selected: false,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,MaterialPageRoute(builder: (context)=>HistoryScreen(

                    )));
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
                        context,MaterialPageRoute(builder: (context)=>VerifyPhoneNoScreen(

                    )));
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
            CustomerScreen( temp: customer,address: actualAddress,),
            AssignShopScreen(),
          ],
        ),
      ),
    );
  }
}


