import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/addressModel.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/new_customer_model.dart';
import 'package:salesmen_app_new/screen/allShopScreen/customer_screen.dart';
import 'package:salesmen_app_new/screen/searchCustomer/srearchCustomerScreen.dart';
import 'package:salesmen_app_new/widget/customer_card.dart';
import 'package:salesmen_app_new/widget/loding_indicator.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:shimmer/shimmer.dart';
class DuesShopScreen extends StatefulWidget {



  @override
  State<DuesShopScreen> createState() => _DuesShopScreenState();
}

class _DuesShopScreenState extends State<DuesShopScreen> {
  Coordinates userLatLng;
  List<CustomerModel> customer=[];
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
  Future<void> getAllCustomerData() async {
    try {
      Provider.of<CustomerList>(context,listen: false).clearList();
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
  // void getCustomerInfo()async{
  //   setLoading(true);
  //   loc.Location location = new loc.Location();
  //   var _location = await location.getLocation();
  //   userLatLng =Coordinates(_location.latitude, _location.longitude);
  //   http.Response response=await OnlineDatabase().getCustomer();
  //   if(response.statusCode==200){
  //     var list=jsonDecode(response.body);
  //     int i=0;
  //     print(list["data"]);
  //     for (var person in list['data']){
  //       double dist=calculateDistance(userLatLng.latitude,userLatLng.longitude,double.parse(person['lat'].toString()=="null"?1.toString():person['lat'].toString()), double.parse(person['long'].toString()=="null"?1.toString():person['long'].toString()));
  //       customer.add(NewCustomerModel.fromJson(person,dist));
  //       print(customer[i].userData.firstName);
  //       print(customer[i].custCode);
  //       i++;
  //     }
  //   }
  //   setLoading(false);
  // }
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
  @override
  void initState() {
    //initData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var dd=Provider.of<CustomerList>(context);
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 15),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       InkWell(
                    //         onTap: (){
                    //           setState(() {
                    //             index=0;
                    //           });
                    //         },
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //               color: (index==0)?themeColor1:Colors.white,
                    //               border: Border.all(color: themeColor1)
                    //           ),
                    //           padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    //           child: Text("Dues Shop",style: TextStyle(color:index==0?Colors.white:themeColor1),),
                    //         ),
                    //       ),
                    //       InkWell(
                    //         onTap: (){
                    //           setState(() {
                    //             index=1;
                    //           });
                    //         },
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             color: (index==1)?themeColor1:Colors.white,
                    //             border: Border.all(color:themeColor1),
                    //           ),
                    //           padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    //           child: Text("Near By",style: TextStyle(color:index==1?Colors.white:themeColor1),),
                    //         ),
                    //       ),
                    //       // InkWell(
                    //       //   onTap: (){
                    //       //     setState(() {
                    //       //       index=2;
                    //       //     });
                    //       //     getNearByCustomerData();
                    //       //     setState(() {
                    //       //     });
                    //       //   },
                    //       //   child: Container(
                    //       //     decoration: BoxDecoration(
                    //       //         color: (index==2)?themeColor1:Colors.white,
                    //       //         border: Border.all(color:themeColor1)
                    //       //     ),
                    //       //     padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    //       //     child: Text("Dues",style: TextStyle(color:index==2?Colors.white:themeColor1),),
                    //       //   ),
                    //       // ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // InkWell(
                        // onTap:(){
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (_) => SearchScreen(
                        //             customerModel: index==0?dd.dues:dd.assign,
                        //           )));
                        // },
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
                                    width:width * 0.75 ,
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
                                  // InkWell(
                                  //   onTap: (){
                                  //     setLoading(true);
                                  //     //onStop();
                                  //   },
                                  //   child: Image.asset(
                                  //     'assets/icons/referesh.png',
                                  //     scale: 1.5,
                                  //   ),
                                  // ),
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
                              getAllCustomerData();
                            }, icon: Icon(Icons.refresh,color: themeColor1))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Near by you (${customers.length})",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15) ,),
                          Text("View All",style:TextStyle(fontSize: 15,color: themeColor1) ,)
                        ],),
                    ),
                    dd.dues.length<1  ?Container()
                           :  Container(
                        child: SingleChildScrollView(
                          child: Container(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dd.dues.length>10?10:dd.dues.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    CustomShopContainer(
                                      customerList: dd.dues,
                                      height: height,
                                      width: width,
                                      customerData:dd.dues[index],
                                      //isLoading2: isLoading2,
                                      //enableLocation: _serviceEnabled,
                                      lat: 1.0,
                                      long:1.0,
                                      showLoading: (value) {
                                        setState(() {
                                          isLoading = value;
                                        });
                                      },
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
                    ),

                  ],
                ),
              ),
            ),
            dd.dues.length<1  ?
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
