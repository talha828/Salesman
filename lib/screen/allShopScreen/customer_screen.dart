import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/addressModel.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/new_customer_model.dart';
import 'package:salesmen_app_new/screen/searchCustomer/srearchCustomerScreen.dart';
import 'package:salesmen_app_new/widget/customer_card.dart';
import 'package:salesmen_app_new/widget/loding_indicator.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:location/location.dart' as loc;
import 'package:shimmer/shimmer.dart';
import 'package:geolocator/geolocator.dart' as geo;


class AllShopScreen extends StatefulWidget {
  List<CustomerModel>temp;
  String address;
  AllShopScreen({this.temp,this.address});
  @override
  State<AllShopScreen> createState() => _AllShopScreenState();
}

class _AllShopScreenState extends State<AllShopScreen> {
   Coordinates userLatLng;
  //List<NewCustomerModel> customer=[];
  bool isLoading=false;
  List<AddressModel>addressList=[];
   loc.Location location = new loc.Location();
  String actualAddress="Searching....";
  List<String> menuButton = ['DIRECTIONS', 'CHECK-IN'];
   getAddressFromLatLng() async {

     var data =await location.getLocation();
     var lat=data.latitude;
     var lng=data.longitude;
     userLatLng=Coordinates(lat, lng);setState(() {});
     String mapApiKey="AIzaSyDhBNajNSwNA-38zP7HLAChc-E0TCq7jFI";
     String _host = 'https://maps.google.com/maps/api/geocode/json';
     final url = '$_host?key=$mapApiKey&language=en&latlng=$lat,$lng';
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
         setState(() {

         });
         print("response ==== $_formattedAddress");
         return _formattedAddress;
       } else return null;
     } else return null;
   }
   calculateDistance(double lat1,double long1,double lat2,double long2) {
     var distance = geo.Geolocator.distanceBetween(lat2,
         long2, lat1, long1);
     return distance / 1000;
   }
  // double calculateDistance(lat1, lon1, lat2, lon2){
  //   var p = 0.017453292519943295;
  //   var c = cos;
  //   var a = 0.5 - c((lat2 - lat1) * p)/2 +
  //       c(lat1 * p) * c(lat2 * p) *
  //           (1 - c((lon2 - lon1) * p))/2;
  //   return 12742 * asin(sqrt(a));
  // }
   List<CustomerModel> customer=[];
   List<CustomerModel> nearByCustomers=[];
   void getAllCustomerData() async {
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

           for (var item in data["results"]) {
             double dist=calculateDistance(double.parse(item["LATITUDE"].toString()=="NULL"?1.toString():item["LATITUDE"].toString()), double.parse(item["LONGITUDE"].toString()=="NULL"?1.toString():item["LONGITUDE"].toString()),userLatLng.latitude,userLatLng.longitude);
             customer.add(CustomerModel.fromModel(item,distance: dist));
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


  void setLoading(bool value){
    setState(() {
      isLoading=value;
    });
  }
  @override
  void initState() {
     //customer.addAll(widget.temp);
    //getAddressFromLatLng();
     //getAllCustomerData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     CustomerList dd=Provider.of<CustomerList>(context,listen: true);
     print(customer.length);
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SearchScreen(
                                  customerModel: dd.customerData,
                                )));
                      },
                      child: Container(
                        height: 38,
                        width: width *0.75,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: TextField(
                          enabled: false,
                          style: TextStyle(height: 1),
                          scrollPadding: EdgeInsets.symmetric(vertical: 0),
                          textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: Icon(Icons.search,color:  Colors.grey,),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: InputBorder.none,
                          hintText: "Search by shop name",
                        ),
                      ),),
                    ),
                    Spacer(),
                    IconButton(onPressed: (){
                      getAllCustomerData();
                    }, icon: Icon(Icons.refresh,color: themeColor1))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text("Near by you (${dd.customerData.length})",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15) ,),
                    Text("View All",style:TextStyle(fontSize: 15,color: themeColor1) ,)
                  ],),
                ),
                Consumer<CustomerList>(
                  builder: (key,customerList,child){
                    return  Container(
                        child: dd.customerData.length<1?Container(
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
                        ):SingleChildScrollView(
                          child: Container(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dd.customerData.length>10?10:dd.customerData.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    CustomShopContainer(
                                      customerList: dd.customerData,
                                      height: height,
                                      width: width,
                                      customerData: dd.customerData[index],
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
          isLoading?Positioned.fill(child: ProcessLoading()):Container()
      ],)
    );
  }
}

class CustomShopContainerLoading extends StatefulWidget {
  double height, width;

  CustomShopContainerLoading({
     this.height,
     this.width,
  });

  @override
  _CustomShopContainerLoadingState createState() =>
      _CustomShopContainerLoadingState();
}

class _CustomShopContainerLoadingState
    extends State<CustomShopContainerLoading> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              //height: height*0.15,
              //width: widget.width * 0.83,
              //color: Colors.red,
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: widget.height * 0.0055,
                    ),
                    Container(
                      height: widget.height * 0.025,
                      width: widget.width * 0.5,
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: widget.height * 0.0075,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: widget.height * 0.025,
                          width: widget.width * 0.05,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: widget.height * 0.01,
                        ),
                        Container(
                          height: widget.height * 0.025,
                          width: widget.width * 0.3,
                          color: Colors.red,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: widget.height * 0.025,
                                    width: widget.width * 0.05,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: widget.height * 0.01,
                                  ),
                                  Container(
                                    height: widget.height * 0.025,
                                    width: widget.width * 0.2,
                                    color: Colors.red,
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
                                  Container(
                                    height: widget.height * 0.025,
                                    width: widget.width * 0.05,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: widget.height * 0.01,
                                  ),
                                  Container(
                                    height: widget.height * 0.025,
                                    width: widget.width * 0.2,
                                    color: Colors.red,
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
                            child: Container(
                              height: widget.height * 0.035,
                              width: widget.width * 0.22,
                              decoration: BoxDecoration(
                                  color: themeColor1 /*:Color(0xff1F92F6)*/,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: VariableText(
                                  text: '',
                                  fontsize: 11,
                                  fontcolor: themeColor2,
                                  weight: FontWeight.w700,
                                  fontFamily: fontRegular,
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
            ),
          )

          /*   Container(
            height: widget.height * 0.14,
            width: widget.width * 0.28,
            color: Colors.red,
          ),*/
        ],
      ),
    );
  }
}