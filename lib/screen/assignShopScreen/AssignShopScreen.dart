import 'dart:convert';
import 'package:location/location.dart' as loc;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:http/http.dart'as http;
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/customer_model.dart';
import 'package:salesmen_app_new/widget/customer_card.dart';
import 'package:salesmen_app_new/widget/loding_indicator.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'dart:math' show cos, sqrt, asin;
class AssignShopScreen extends StatefulWidget {

  @override
  State<AssignShopScreen> createState() => _AssignShopScreenState();
}

class _AssignShopScreenState extends State<AssignShopScreen> {
   Coordinates userLatLng;
  List<CustomerModel> customer=[];
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
  void getCustomerInfo()async{
    setLoading(true);
    loc.Location location = new loc.Location();
    var _location = await location.getLocation();
    userLatLng =Coordinates(_location.latitude, _location.longitude);
    http.Response response=await OnlineDatabase().getCustomer();
    if(response.statusCode==200){
      var list=jsonDecode(response.body);
      int i=0;
      print(list["data"]);
      for (var person in list['data']){
        double dist=calculateDistance(userLatLng.latitude,userLatLng.longitude,double.parse(person['lat'].toString()=="null"?1.toString():person['lat'].toString()), double.parse(person['long'].toString()=="null"?1.toString():person['long'].toString()));
        customer.add(CustomerModel.fromJson(person,dist));
        print(customer[i].userData.firstName);
        print(customer[i].custCode);
        i++;
      }
    }
    setLoading(false);
  }
  void setLoading(bool value){
    setState(() {
      isLoading=value;
    });
  }
  int index = 0;
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
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                index=0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: (index==0)?themeColor1:Colors.white,
                                  border: Border.all(color: themeColor1)
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                              child: Text("Dues Shop",style: TextStyle(color:index==0?Colors.white:themeColor1),),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                index=1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: (index==1)?themeColor1:Colors.white,
                                border: Border.all(color:themeColor1),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                              child: Text("Near By",style: TextStyle(color:index==1?Colors.white:themeColor1),),
                            ),
                          ),
                          // InkWell(
                          //   onTap: (){
                          //     setState(() {
                          //       index=2;
                          //     });
                          //     getNearByCustomerData();
                          //     setState(() {
                          //     });
                          //   },
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //         color: (index==2)?themeColor1:Colors.white,
                          //         border: Border.all(color:themeColor1)
                          //     ),
                          //     padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                          //     child: Text("Dues",style: TextStyle(color:index==2?Colors.white:themeColor1),),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width *0.8,
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
                        IconButton(onPressed: (){}, icon: Icon(Icons.refresh,color: themeColor1,size: 30,))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Near by you (${customer.length})",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15) ,),
                          Text("View All",style:TextStyle(fontSize: 15,color: themeColor1) ,)
                        ],),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: isLoading?LoadingIndicator(width: width, height: height):ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: customer.length,
                          itemBuilder: (context,index){
                            return CustomerCard(
                              height: height,
                              width: width,
                              f: f,
                              menuButton: menuButton,
                              code: customer[index].custCode.toString().toUpperCase()=="NULL"?"NULL":customer[index].custCode.toString(),
                              category: customer[index].custcatId.toString().toUpperCase()=="NULL"?"NULL":customer[index].custcatId.toString(),
                              shopName: customer[index].custPrimName.toString().toUpperCase()=="NULL"?"NULL":customer[index].custPrimName.toString(),
                              address: customer[index].areaId.toString().toUpperCase()=="NULL"?"NULL":customer[index].areaId.toString(),
                              name: customer[index].custName.toString().toUpperCase()=="NULL"?"NULL":customer[index].custName.toString(),
                              phoneNo: customer[index].phone2.toString().toUpperCase()=="NULL"?"NULL":customer[index].phone2.toString(),
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
          ],)
    );
  }
}
