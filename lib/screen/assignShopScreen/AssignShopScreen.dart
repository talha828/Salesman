import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/model.dart';
import 'package:http/http.dart'as http;
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/addressModel.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/newCustomerModel.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/allShopScreen/allShopScreen.dart';
import 'package:salesmen_app_new/screen/searchCustomer/srearchCustomerScreen.dart';
import 'package:salesmen_app_new/screen/viewAll/viewAllScreen.dart';
import 'package:salesmen_app_new/widget/customer_card.dart';
import 'package:shimmer/shimmer.dart';
class AssignShopScreen extends StatefulWidget {
  List<CustomerModel> customer;
  AssignShopScreen({this.customer});


  @override
  State<AssignShopScreen> createState() => _AssignShopScreenState();
}

class _AssignShopScreenState extends State<AssignShopScreen> {
   Coordinates userLatLng;
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
       // try {
         // Provider.of<CustomerList>(context, listen: false).setLoading(true);
         // Provider.of<CustomerList>(context, listen: false).setDuesLoading(true);
         Provider.of<CustomerList>(context, listen: false).setAssignLoading(true);
         var data = await location.getLocation();
         List<AddressModel> addressList = [];
         userLatLng = Coordinates(data.latitude, data.longitude);
         // String mapApiKey = "AIzaSyDhBNajNSwNA-38zP7HLAChc-E0TCq7jFI";
         // String _host = 'https://maps.google.com/maps/api/geocode/json';
         // final url =
         //     '$_host?key=$mapApiKey&language=en&latlng=${userLatLng.latitude},${userLatLng.longitude}';
         // print(url);
        // if (userLatLng.latitude != null && userLatLng.longitude != null) {
        //    var response1 = await http.get(Uri.parse(url));
        //    if (response1.statusCode == 200) {
        //      Map data = jsonDecode(response1.body);
        //      String _formattedAddress = data["results"][0]["formatted_address"];
        //      var address = data["results"][0]["address_components"];
        //      for (var i in address) {
        //        addressList.add(AddressModel.fromJson(i));
        //      }
        //      actualAddress = addressList[3].shortName;
        //      Provider.of<CustomerList>(context, listen: false)
        //          .updateAddress(actualAddress);
        //      print("response ==== $_formattedAddress");
        //      _formattedAddress;
        //    }



           // var response = await OnlineDatabase.getGDuesShop(lat:userLatLng.latitude.toString() ,long:userLatLng.longitude.toString() );
           // print("Response code is " + response.statusCode.toString());
           // // if (response.statusCode == 200) {
           //   var data = jsonDecode(utf8.decode(response.bodyBytes));
           //   for (var item in data["results"]) {
           //     customer.add(CustomerInfo.fromJson(item));
           //     print(item['CUST_CODE']);
           //   }
           //   Provider.of<CustomerList>(context, listen: false).clearAssign();
           //   Provider.of<CustomerList>(context, listen: false).getMotorBikeDues(customer);
           //   Provider.of<CustomerList>(context, listen: false).setDuesLoading(false);
           //


             customer.clear();
             Provider.of<CustomerList>(context, listen: false).clearAssign();
             var response1 = await OnlineDatabase.getAssignShop(lat:userLatLng.latitude.toString() ,long:userLatLng.longitude.toString() );
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
             // setState(() {
             //   isLoading=false;
             // });
             //print("length is"+limitedcustomer.length.toString());
             Provider.of<CustomerList>(context, listen: false).setAssignLoading(false);
           // } else if (response.statusCode == 400) {
           //   var data = jsonDecode(utf8.decode(response.bodyBytes));
           //   Fluttertoast.showToast(
           //       msg: "${data['results'].toString()}",
           //       toastLength: Toast.LENGTH_SHORT,
           //       backgroundColor: Colors.black87,
           //       textColor: Colors.white,
           //       fontSize: 16.0);
           //   Provider.of<CustomerList>(context, listen: false).setDuesLoading(false);
           //   Provider.of<CustomerList>(context, listen: false).setAssignLoading(false);
           // }
         // }
       // } catch (e, stack) {
       //   print('exception is' + e.toString());
       //   Fluttertoast.showToast(
       //       msg: "Error: " + e.toString(),
       //       toastLength: Toast.LENGTH_SHORT,
       //       backgroundColor: Colors.black87,
       //       textColor: Colors.white,
       //       fontSize: 16.0);
       //   Provider.of<CustomerList>(context, listen: false).setLoading(false);
       // }
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
   getLocation()async{
     var location=await loc.Location().getLocation();
     userLatLng=Coordinates(location.latitude,location.longitude);
     Provider.of<CustomerList>(context,listen: false).updateList(userLatLng);
   }
   // getLocation()async{
   //   var location=await loc.Location().getLocation();
   //   userLatLng=Coordinates(location.latitude,location.longitude);
   //   setState(() {});
   // }
  var dues;
  void setLoading(bool value){
    setState(() {
      isLoading=value;
    });
  }
  int index = 0;
   @override
   void initState() {
    // getLocation();
     getAllCustomerData();
     super.initState();
   }
  @override
  Widget build(BuildContext context) {
    var dd=Provider.of<CustomerList>(context);
    var dds=Provider.of<CustomerList>(context).assign;
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    //dds.length>0?getLocation():false;
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
                                        builder: (_) => SearchScreen(customerModel: dd.assign,)));
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
                              //setLoading(true);
                              getAllCustomerData();

                            }, icon: Icon(Icons.refresh,color: themeColor1)),
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
                          Text("Near by you (${dds.length})",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15) ,),
                          InkWell(
                              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllScreen(customer: dds,))),
                              child: Text("View All",style:TextStyle(fontSize: 15,color: themeColor1) ,))
                        ],),
                    ),
                    dd.assignLoading? Container(
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
                    ):
                    SingleChildScrollView(
                              child: Container(
                                child:
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: dd.assign.length >25 ?25:dd.assign.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                       CustomerCard(
                                         image:"null" ,
                                         height: height,
                                         width: width,
                                         f:f,
                                         menuButton: ['DIRECTIONS', 'CHECK-IN'],
                                         code: dds[index].cUSTCODE,
                                         category: dds[index].pARTYCATEGORY,
                                         shopName: dds[index].cUSTOMER ,
                                         address:  dds[index].aDDRESS,
                                         name: dds[index].cONTACTPERSON ,
                                         phoneNo: dds[index].pHONE1 ,
                                         lastVisit:"--" ,
                                         dues: "0",
                                         lastTrans:dds[index].lASTDAYS ,
                                         outstanding:  dds[index].bALANCE,
                                         shopAssigned: dds[index].sHOPASSIGNED ,
                                         lat:  dds[index].lATITUDE,
                                         long:  dds[index].lONGITUDE,
                                         //customerData: CustomerInfo,
                                         showLoading:(value){
                                           setState(() {
                                             isLoading=value;
                                           });
                                         } ,
                                       ),
                                        // SizedBox(
                                        //   height: height * 0.025,
                                        // ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                  ],
                ),
              ),
            ),
            dd.assign.length<1 &&dd.assignLoading != true ?
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
