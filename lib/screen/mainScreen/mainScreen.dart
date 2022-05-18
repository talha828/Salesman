import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:location/location.dart' as loc;
class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _serviceEnabled = false;
  var actualAddress = "Searching....";
  late Coordinates userLatLng;
  void onStart()async{
    loc.Location location = new loc.Location();
    var _location = await location.getLocation();
      _serviceEnabled = true;
      actualAddress = "Searching....";
    userLatLng =Coordinates(_location.latitude, _location.longitude);
    print("userLatLng: " + userLatLng.toString());
    var addresses = await Geocoder.local.findAddressesFromCoordinates(userLatLng);
    actualAddress = addresses.first.subLocality.toString();
    print(actualAddress);
    setState(() {});
  }
  
  @override
  void initState() {
    onStart();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context, listen: true);
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("DashBoard",style: TextStyle(color: Colors.white),)),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Center(
                child: VariableText(
                  text: actualAddress,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset("assets/tabviewicon/all.png",color: Colors.white,width: 24,height: 24,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset("assets/tabviewicon/user.png",color: Colors.white,width: 24,height: 24,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset("assets/icons/delivery.png",color: Colors.white,width: 24,height: 24,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset("assets/icons/alliedmcb.png",color: Colors.white,width: 24,height: 24,),
                  ],
                ),
              ),
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
                            text: userData.firstName+ userData.lastName,
                            fontsize: 16,
                            fontcolor: textcolorblack,
                            fontFamily: fontMedium,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(
                            height: height * 0.0055,
                          ),
                          VariableText(
                            text:userData.email,
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
                                "20,000" +
                                ' / ' +"40,000",
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
            One(text: "one"),
            One(text:"Two"),
            One(text: "Three"),
            One(text: "Four"),

          ],
        ),
      ),
    );
  }
}

class One extends StatelessWidget {
  One({required this.text});
  String text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(text),),);
  }
}

