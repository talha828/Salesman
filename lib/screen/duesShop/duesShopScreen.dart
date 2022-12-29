import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/model.dart';
import 'package:http/http.dart'as http;
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/locationServices/location_callback_handler.dart';
import 'package:salesmen_app_new/model/addressModel.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/newCustomerModel.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/allShopScreen/allShopScreen.dart';
import 'package:salesmen_app_new/screen/searchCustomer/srearchCustomerScreen.dart';
import 'package:salesmen_app_new/screen/viewAll/viewAllScreen.dart';
import 'package:salesmen_app_new/widget/customer_card.dart';
import 'package:shimmer/shimmer.dart';
class DuesShopScreen extends StatefulWidget {
UserModel user;
DuesShopScreen({this.user});



  @override
  State<DuesShopScreen> createState() => _DuesShopScreenState();
}

class _DuesShopScreenState extends State<DuesShopScreen> {
  Coordinates userLatLng;
  List<CustomerInfo> customer=[];
  List<CustomerModel> customers=[];
  bool isLoading=false;
  List<String> menuButton = ['DIRECTIONS', 'CHECK-IN'];
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
  loc.Location location = new loc.Location();
  String actualAddress="Searching....";
  void getAllCustomerData() async {
    List<CustomerInfo> customer=[];
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
            setState(() {
              isLoading=false;
            });
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
  getLocation()async{
    var location=await loc.Location().getLocation();
    userLatLng=Coordinates(location.latitude,location.longitude);
    Provider.of<CustomerList>(context,listen: false).updateList(userLatLng);
  }
  changeList(List<CustomerModel> value,String buttonText){
    if(buttonText=="dues"){
      setState(() {
        customers.clear();
        customers.addAll(value);
      });
    }
  }
  var dues;
  void setLoading(bool value){
    setState(() {
      isLoading=value;
    });
  }
  int index = 0;
  Future<void> startLocationService() async {

    await BackgroundLocator.initialize();
    Map<String, dynamic> data = {
      'countInit': 1,
      'userNumber': phoneNumber,
      'userName': widget.user.userName,
    };
    print(phoneNumber);
    print(widget.user.userName);
    return await BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        autoStop: false,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 120,
            distanceFilter: 0,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIcon: '',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                LocationCallbackHandler.notificationCallback)));
  }
  @override
  void initState() {
    startLocationService();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var dd=Provider.of<CustomerList>(context);
    var ddd=Provider.of<CustomerList>(context).dues;
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    var response=Provider.of<CustomerList>(context).response;
    //ddd.length>0?getLocation():false;
    return Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SearchScreen(customerModel: dd.dues,)));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width:width * 0.6 ,
                                    child: RectangluartextFeild(
                                      bordercolor: Color(0xffEBEAEA),
                                      hinttext: "Search by shop name",
                                      containerColor: Color(0xFFFFFF),
                                      enableborder: true,
                                      enable: false,
                                      keytype: TextInputType.text,
                                      textlength: 25,
                                      //onChanged: searchOperation,
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        // ),
                        IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: (){
                              setLoading(true);
                              getAllCustomerData();
                            }, icon: Icon(Icons.refresh,color: themeColor1)),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        // ),
                        IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: (){
                              getLocation();
                            }, icon: Image.asset("assets/images/update.png",color: themeColor1,width: 25,height: 25,))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Near by you (${dd.dues.length})",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15) ,),
                          InkWell(
                              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllScreen(customer: ddd,))),

                              child: Text("View All",style:TextStyle(fontSize: 15,color: themeColor1) ,))
                        ],),
                    ),
                    dd.loading ?Container(
                      height: 480,
                      child: Shimmer.fromColors(
                        period: Duration(seconds: 1),
                        baseColor: Colors.grey.withOpacity(0.4),
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return Column(
                              children: [
                                CustomShopContainerLoading(
                                  height: height,
                                  width: width,
                                ),
                                SizedBox(
                                  height: height * 0.025,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    )
                           :  Container(
                        child: SingleChildScrollView(
                          child: Container(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              reverse: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dd.dues.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    CustomerCard(
                                      image:"null" ,
                                      height: height,
                                      width: width,
                                      f:f,
                                      menuButton: ['DIRECTIONS', 'CHECK-IN'],
                                      code: ddd[index].cUSTCODE,
                                      category: ddd[index].pARTYCATEGORY,
                                      shopName: ddd[index].cUSTOMER ,
                                      address:  ddd[index].aDDRESS,
                                      name: ddd[index].cONTACTPERSON ,
                                      phoneNo: ddd[index].pHONE1 ,
                                      lastVisit: ddd[index].lASTDAYS,
                                      dues: "0",
                                      lastTrans:"--" ,
                                      outstanding:  ddd[index].bALANCE,
                                      shopAssigned: ddd[index].sHOPASSIGNED ,
                                      lat:  ddd[index].lATITUDE,
                                      long:  ddd[index].lONGITUDE,
                                      //customerData: CustomerInfo,
                                      showLoading:(value){
                                        setState(() {
                                          isLoading=value;
                                        });
                                      } ,
                                    ),
                                    // CustomShopContainer(
                                    //   customerList: dd.dues,
                                    //   height: height,
                                    //   width: width,
                                    //   customerData:dd.dues[index],
                                    //   //isLoading2: isLoading2,
                                    //   //enableLocation: _serviceEnabled,
                                    //   lat: 1.0,
                                    //   long:1.0,
                                    //   showLoading: (value) {
                                    //     setState(() {
                                    //       isLoading = value;
                                    //     });
                                    //   },
                                    // ),
                                    // SizedBox(
                                    //   height: height * 0.025,
                                    // ),
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                    ),

                  ],
                ),
              ),
            ),
            dd.dues.length<1 &&dd.loading != true ?
            Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:[
                    Text("No shops are Found",textAlign: TextAlign.center,),
                  ]
              ),
            ):Container(),
            isLoading?Positioned.fill(child: ProcessLoading()):Container()
          ],)
    );
  }
}
