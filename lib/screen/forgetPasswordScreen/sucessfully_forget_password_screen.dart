import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/model/addressModel.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/loginScreen/verify_phoneno_screen.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart'as http;

class SucessFullyVerifiedForgetPasswordScreen extends StatefulWidget {
  @override
  _SucessFullyVerifiedForgetPasswordScreenState createState() => _SucessFullyVerifiedForgetPasswordScreenState();
}

class _SucessFullyVerifiedForgetPasswordScreenState extends State<SucessFullyVerifiedForgetPasswordScreen> {

  var actualAddress = "Searching....";
  Coordinates userLatLng;
  loc.Location location = new loc.Location();
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
  @override
  void initState() {
    super.initState();
    getAddressFromLatLng();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    var width = media.width;
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenpadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height*0.07,),
              Center(
                child: Image.asset(
                  "assets/images/splashlogo.png",
                  scale: 3.5,
                ),
              ),
              Spacer(),
              Center(
                child: Image.asset(
                  "assets/icons/phone.png",
                  scale: 3,
                ),
              ),
              SizedBox(
                height: height * 0.03,),
              Center(
                child: VariableText(
                  text: "Reset Successfully",
                  fontsize: 18,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  fontcolor: textcolorblack,
                  fontFamily: fontMedium,
                  weight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: height * 0.02,),
              Center(
                child: VariableText(
                  text: "Your password has been changed",
                  fontsize: 15,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  fontcolor: textcolorgrey,
                  fontFamily: fontRegular,
                  weight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: height * 0.005,),
              Center(
                child: VariableText(
                  text: "successfully.",
                  fontsize: 15,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  fontcolor: textcolorgrey,
                  fontFamily: fontRegular,
                  weight: FontWeight.w400,
                ),
              ),


            Spacer(),
              Spacer(),




            ],
          ),
        ),
        floatingActionButton:FloatingActionButton.extended(
    backgroundColor: themeColor1,
    elevation: 1,
    foregroundColor: themeColor2,
    onPressed: () {
      Navigator.push(
      context, MaterialPageRoute(builder: (context)=>VerifyPhoneNoScreen()));
      },

    label:      Row(
      children: [
    VariableText(
      text: "Login Now",
      fontsize: 15,
      textAlign: TextAlign.start,
      line_spacing: 1,
      fontcolor: themeColor2,
      fontFamily: fontMedium,
    ),
    SizedBox(width: height*0.015,),
    Image.asset('assets/icons/arrow_forward.png',scale: 2.3,),
      ],
    ),

    ),
    );
  }
}
