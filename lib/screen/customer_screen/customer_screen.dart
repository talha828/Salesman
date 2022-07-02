import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart'as http;
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/addressModel.dart';
import 'package:salesmen_app_new/model/customer_model.dart';
import 'package:salesmen_app_new/widget/customer_card.dart';
import 'package:salesmen_app_new/widget/loding_indicator.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:location/location.dart' as loc;
import 'package:shimmer/shimmer.dart';

class CustomerScreen extends StatefulWidget {

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
   Coordinates userLatLng;
  List<CustomerModel> customer=[];
  bool isLoading=true;
  List<AddressModel>addressList=[];
  String actualAddress="Searching....";
  List<String> menuButton = ['DIRECTIONS', 'CHECK-IN'];
   getAddressFromLatLng( double lat, double lng) async {
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
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
  void getCustomerInfo()async{
    loc.Location location = new loc.Location();
    var _location = await location.getLocation();
    userLatLng =Coordinates(_location.latitude, _location.longitude);
    getAddressFromLatLng(_location.latitude, _location.longitude);
    setLoading(true);
    http.Response response=await OnlineDatabase().getCustomer();
    if(response.statusCode==200){
      var list=jsonDecode(response.body);
      int i=0;
     // var data=list["data"];
      print(list);
     for (var person in list){
       double dist=calculateDistance(userLatLng.latitude,userLatLng.longitude,double.parse(person['lat'].toString()=="null"?1.toString():person['lat'].toString()), double.parse(person['long'].toString()=="null"?1.toString():person['long'].toString()));
       customer.add(CustomerModel.fromJson(person,dist));
        print(customer[i].userData.firstName);
        i++;
      }
      setState(() {
        customer.sort((a, b) => a.distances.compareTo(b.distances));
      });
    }
    setLoading(false);
  }


  void setLoading(bool value){
    setState(() {
      isLoading=value;
    });
  }
  @override
  void initState() {
   getCustomerInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(child: Text(actualAddress,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18),),),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: width *0.75,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: InputBorder.none,
                        hintText: "Search by shop name",
                      ),
                    ),),
                    Spacer(),
                    IconButton(onPressed: (){}, icon: Icon(Icons.refresh,color: themeColor1,size: 30,))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text("Near by you (${customer.length})",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15) ,),
                    Text("View All",style:TextStyle(fontSize: 15,color: themeColor1) ,)
                  ],),
                ),
                Container(
                  child: isLoading?Container(
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
                  ):ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context,index){
                        return CustomerCard(
                          height: height,
                          width: width,
                          f: f,
                          menuButton: menuButton,
                          code: customer[index].custOldCode.toString().toUpperCase()=="NULL"?"NULL":customer[index].custOldCode.toString(),
                          category: customer[index].custcatId.toString().toUpperCase()=="NULL"?"NULL":customer[index].custcatId.toString(),
                          shopName: customer[index].userData.firstName.toString().toUpperCase()=="NULL"?"NULL":customer[index].userData.firstName.toString(),
                          address: customer[index].custAddress.toString().toUpperCase()=="NULL"?"NULL":customer[index].custAddress.toString(),
                          name: customer[index].custPrimName.toString().toUpperCase()=="NULL"?"NULL":customer[index].custPrimName.toString(),
                          phoneNo: customer[index].custPrimNb.toString().toUpperCase()=="NULL"?"NULL":customer[index].custPrimNb.toString(),
                          lastVisit: customer[index].cityId.toString().toUpperCase()=="NULL"?"NULL": customer[index].cityId.toString(),
                          dues: customer[index].custMaxCredit.toString().toUpperCase()=="NULL"?"NULL": customer[index].custMaxCredit.toString(),
                          lastTrans: customer[index].custMaxCredit.toString().toUpperCase()=="NULL"?"NULL":customer[index].custMaxCredit.toString(),
                          outstanding: customer[index].custMaxCredit.toString().toUpperCase()=="NULL"?"NULL":customer[index].custMaxCredit.toString(),
                          shopAssigned: customer[index].custPrimPass.toString().toUpperCase()=="NULL"?"NULL":customer[index].custPrimPass.toString(),
                          lat: customer[index].lat.toString().toUpperCase()=="NULL"?"NULL":customer[index].lat.toString(),
                          long: customer[index].long.toString().toUpperCase()=="NULL"?"NULL":customer[index].long.toString(),
                          customerData: customer[index],
                          image:
                          "https://www.google.com/imgres?imgurl=https%3A%2F%2Fimages.indianexpress.com%2F2021%2F12%2Fdoctor-strange-2-1200.jpg&imgrefurl=https%3A%2F%2Findianexpress.com%2Farticle%2Fentertainment%2Fhollywood%2Fdoctor-strange-2-suggest-benedict-cumberbatch-sorcerer-supreme-might-lead-avengers-7698058%2F&tbnid=GxuE_SM1fXrAqM&vet=12ahUKEwjr4bj575_3AhVMxqQKHSC5BRAQMygBegUIARDbAQ..i&docid=6gb_YRZyTk5MWM&w=1200&h=667&q=dr%20strange&ved=2ahUKEwjr4bj575_3AhVMxqQKHSC5BRAQMygBegUIARDbAQ",
                          showLoading: (value) {
                            setState(() {
                              isLoading = value;
                            });
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
         // isLoading?LoadingIndicator(width: width, height: height):Container()
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