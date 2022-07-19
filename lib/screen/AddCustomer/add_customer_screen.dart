import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';

///image picker use here
//import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/model/area_model.dart';
import 'package:salesmen_app_new/model/city_model.dart';
import 'package:salesmen_app_new/model/partycategories.dart';
import 'package:salesmen_app_new/model/town_model.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/AddCustomer/sucessfully_add_customer_screen.dart';

///email,cnic,cnic exp,uc,citymarket,payterm,

class AddCustomerScreen extends StatefulWidget {
  var locationdata;
  AddCustomerScreen({this.locationdata});
  File _image1;
  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  File image;
  List image2;
  String base64Image;
  bool checkbox = false;
  String formattedDate;
  TextEditingController name = TextEditingController();
  TextEditingController secondname = TextEditingController();
  TextEditingController thirdName = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  TextEditingController secondphoneno = TextEditingController();
  TextEditingController thirdPhoneNo = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController town = TextEditingController();
  TextEditingController currentlocation = TextEditingController();
  TextEditingController shoptown = TextEditingController();
  TextEditingController shopname = TextEditingController();
  List<Town> townList = [];
  List s_r_imageList2 = [];

  String CustomerId="00";
  bool isLoading = false;
  bool hasArea = false;
  bool hasPartyCategory = false;

  var actualaddress;
  bool showImage = false;
  bool _serviceEnabled = false;
  LocationData _locationData;
  Location location = new Location();
  Town sel_town;
  List<City> cities;
  City sel_cities;
  List<Area> areas;
  Area sel_areas;
  List<PartyCategories> party_categories;
  PartyCategories sel_party_categories;

  void printWrapped(String text) {
    final pattern = RegExp('.{1,100000}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    print("init call");
    cities = [];
    areas = [];
    party_categories = [];

    checkLocation();
    getAllCities();
    getPartyCategory();
  }

  Future<List<City>> getAllCities() async {
    List<City> tempCity = await OnlineDatabase.getAllCities();
    isLoading = false;
    setState(() {
      cities = tempCity;
    });
  }

  Future<List<Area>> getAreas(cityID) async {
    List<Area> tempArea = await OnlineDatabase.getAreaByCity(cityID);
    setState(() {
      areas = tempArea;
    });
  }

  Future<List<PartyCategories>> getPartyCategory() async {
    List<PartyCategories> tempPartyCategory =
    await OnlineDatabase.getPartyCategories();
    setState(() {
      party_categories = tempPartyCategory;
    });
  }

  Coordinates userLatLong;
  checkLocation() async {
    if (widget.locationdata == null) {
      _serviceEnabled = await location.requestService();
    } else {}
    widget.locationdata = await location.getLocation();
    final coordinates = new Coordinates(
        widget.locationdata.latitude, widget.locationdata.longitude);
    userLatLong = new Coordinates(
        widget.locationdata.latitude, widget.locationdata.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      actualaddress = addresses.first.addressLine;
    });
    print("address is" + actualaddress.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.clear();
    secondname.clear();
    phoneno.clear();
    secondphoneno.clear();
    address.clear();
    town.clear();
    currentlocation.clear();
    shoptown.clear();
    shopname.clear();
    widget._image1 = null;
  }

  _uploadImg(bool fromCamera) async {
    if (fromCamera) {
      XFile image = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 50);
      if (image != null) {
        print(image.path);
        setState(() {
          this.image = File(image.path);
          showImage = true;
        });
      }
    } else {
      XFile image = await ImagePicker().pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      if (image != null) {
        print(image.path);
        setState(() {
          this.image = File(image.path);
          showImage = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserModel>(context);
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: MyAppBar(
            title: 'Add Customers',
            ontap: () {
              Navigator.pop(context);
            },
            color: themeColor1,
            color2: themeColor2,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: width,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenpadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Column(
                        children: [
                          showImage != true
                              ? Row(
                            children: [
                              DottedBorder(
                                  color: Color(
                                      0xffE5E5E5), //color of dotted/dash line
                                  strokeWidth:
                                  1.5, //thickness of dash/dots
                                  dashPattern: [8, 4],
                                  child: Container(
                                    height: height * 0.20,
                                    width: width * 0.42,
                                    color: Color(0xffE5E5E5),
                                    child: GestureDetector(
                                        onTap: () {
                                          _uploadImg(true);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icons/camera.png",
                                              scale: 3.5,
                                            ),
                                            SizedBox(
                                              height: height * 0.02,
                                            ),
                                            VariableText(
                                              text: "Camera",
                                              fontsize: 13,
                                              weight: FontWeight.w400,
                                              fontcolor: textcolorblack,
                                              fontFamily: fontRegular,
                                            ),
                                          ],
                                        )),
                                  )),
                              Spacer(),
                              //dash patterns, 10 is dash width, 6 is space width
                              DottedBorder(
                                  color: Color(
                                      0xffE5E5E5), //color of dotted/dash line
                                  strokeWidth:
                                  1.5, //thickness of dash/dots
                                  dashPattern: [8, 4],
                                  child: Container(
                                    height: height * 0.20,
                                    width: width * 0.42,
                                    color: Color(0xffE5E5E5),
                                    child: GestureDetector(
                                        onTap: () {
                                          _uploadImg(false);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icons/gallery.png",
                                              scale: 3.5,
                                            ),
                                            SizedBox(
                                              height: height * 0.02,
                                            ),
                                            VariableText(
                                              text: "Gallery",
                                              fontsize: 13,
                                              weight: FontWeight.w400,
                                              fontcolor: textcolorblack,
                                              fontFamily: fontRegular,
                                            ),
                                          ],
                                        )),
                                  )),
                            ],
                          )
                              : Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: height * 0.20,
                                  width: width,
                                  color: Colors.white,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showImage = false;
                                        image = null;
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (Rect bounds) {
                                            return LinearGradient(
                                              // center: Alignment.topLeft,
                                              //radius: 1.0,
                                              colors: <Color>[
                                                Colors.grey,
                                                Colors.grey
                                              ],
                                            ).createShader(bounds);
                                          },
                                          child: Image.file(
                                            image,
                                            height: height * 0.20,
                                            width: width,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Align(
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.5),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  50),
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      VariableText(
                        text: 'Owner Name',
                        fontsize: 12,
                        fontFamily: fontMedium,
                        weight: FontWeight.w500,
                        fontcolor: textcolorblack,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      RectangluartextFeild(
                        hinttext: "Ayaz Qureshi",
                        cont: name,
                        //onChanged: enableBtn(email.text),
                        keytype: TextInputType.text,
                        textlength: 25,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      VariableText(
                        text: 'Phone No. #',
                        fontsize: 12,
                        fontFamily: fontMedium,
                        weight: FontWeight.w500,
                        fontcolor: textcolorblack,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      RectangluartextFeildWithPrefix(
                        showprefix: true,
                        hinttext: "3123045267",
                        cont: phoneno,
                        //onChanged: enableBtn(email.text),
                        keytype: TextInputType.number,
                        textlength: 10,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),

                      ///get city
                      VariableText(
                        text: 'City',
                        fontsize: 12,
                        fontFamily: fontMedium,
                        weight: FontWeight.w500,
                        fontcolor: textcolorblack,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF4F4F4),
                            border: Border.all(color: Color(0xffEEEEEE))),
                        height: height * 0.065,
                        child: InputDecorator(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xffEEEEEE))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 5, right: 10),
                            ),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<City>(
                                    icon: Icon(Icons.arrow_drop_down),
                                    hint: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text("Select your city",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: fontLight,
                                              color: Color(
                                                0xffB2B2B2,
                                              ))),
                                    ),
                                    value: sel_cities,
                                    isExpanded: true,
                                    onTap: () {},
                                    onChanged: (city) async {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        sel_cities = city;
                                        print("Selected city is: " +
                                            sel_cities.cityName.toString() +
                                            " " +
                                            sel_cities.cityCode.toString());
                                      });
                                      if (areas != null) {
                                        hasArea = true;
                                        areas.clear();
                                        sel_areas = null;
                                      }

                                      List<Area> a = await getAreas(
                                          sel_cities.cityCode.toString());
                                      setState(() {
                                        //areas = a;
                                        print(
                                            "area list is" + areas.toString());
                                        if (areas != null) {
                                          hasArea = true;
                                        } else {
                                          hasArea = false;
                                        }
                                      });
                                    },
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(
                                          0xffC5C5C5,
                                        )),
                                    items: cities.map<DropdownMenuItem<City>>(
                                            (City item) {
                                          return DropdownMenuItem<City>(
                                            value: item,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: VariableText(
                                                    text: item.cityName ??
                                                        'Not Found',
                                                    fontsize: 13,
                                                    weight: FontWeight.w400,
                                                    fontFamily: fontLight,
                                                    fontcolor: textcolorblack)),
                                          );
                                        }).toList()))),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),

                      ///get area
                      VariableText(
                        text: 'Area',
                        fontsize: 12,
                        fontFamily: fontMedium,
                        weight: FontWeight.w500,
                        fontcolor: textcolorblack,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF4F4F4),
                            border: Border.all(color: Color(0xffEEEEEE))),
                        height: height * 0.065,
                        child: InputDecorator(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xffEEEEEE))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 5, right: 10),
                            ),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<Area>(
                                    icon: Icon(Icons.arrow_drop_down),
                                    hint: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text("Select your area",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: fontLight,
                                              color: Color(
                                                0xffB2B2B2,
                                              ))),
                                    ),
                                    value: sel_areas,
                                    isExpanded: true,
                                    onTap: () {},
                                    onChanged: (area) async {
                                      setState(() {
                                        sel_areas = area;

                                        //print("Selected area is: "+sel_areas.areaCode.toString());
                                      });
                                    },
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(
                                          0xffC5C5C5,
                                        )),
                                    items: hasArea
                                        ? areas.map<DropdownMenuItem<Area>>(
                                            (Area item) {
                                          return DropdownMenuItem<Area>(
                                            value: item,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: VariableText(
                                                  text: item.areaName ??
                                                      'Not Found',
                                                  fontsize: 13,
                                                  weight: FontWeight.w400,
                                                  fontFamily: fontLight,
                                                  fontcolor: textcolorblack),
                                            ),
                                          );
                                        }).toList()
                                        : []))),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),

                      ///get partycategory
                      VariableText(
                        text: 'PartyCategories',
                        fontsize: 12,
                        fontFamily: fontMedium,
                        weight: FontWeight.w500,
                        fontcolor: textcolorblack,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffF4F4F4),
                            border: Border.all(color: Color(0xffEEEEEE))),
                        height: height * 0.065,
                        child: InputDecorator(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xffEEEEEE))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 5, right: 10),
                            ),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<PartyCategories>(
                                    icon: Icon(Icons.arrow_drop_down),
                                    hint: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child:
                                      Text("Select your party categories",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: fontLight,
                                              color: Color(
                                                0xffB2B2B2,
                                              ))),
                                    ),
                                    value: sel_party_categories,
                                    isExpanded: true,
                                    onTap: () {},
                                    onChanged: (partycategory) async {
                                      setState(() {
                                        sel_party_categories = partycategory;

                                        print("Selected cat is: " +
                                            sel_party_categories
                                                .partyCategoriesCode
                                                .toString() +
                                            " " +
                                            sel_party_categories
                                                .partyCategoriesName);
                                      });
                                    },
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(
                                          0xffC5C5C5,
                                        )),
                                    items: party_categories
                                        .map<DropdownMenuItem<PartyCategories>>(
                                            (PartyCategories item) {
                                          return DropdownMenuItem<PartyCategories>(
                                            value: item,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(left: 8.0),
                                              child: VariableText(
                                                  text: item.partyCategoriesName ??
                                                      'Not Found',
                                                  fontsize: 13,
                                                  weight: FontWeight.w400,
                                                  fontFamily: fontLight,
                                                  fontcolor: textcolorblack),
                                            ),
                                          );
                                        }).toList()))),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      VariableText(
                        text: 'Address',
                        fontsize: 12,
                        fontFamily: fontMedium,
                        weight: FontWeight.w500,
                        fontcolor: textcolorblack,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Stack(
                        children: [
                          RectangluartextFeild(
                            hinttext: actualaddress == null
                                ? "Searching"
                                : actualaddress.toString(),
                            //cont: currentlocation,
                            enable: false,
                            //onChanged: enableBtn(email.text),
                            keytype: TextInputType.text,
                            textlength: 25,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                //child: Image.asset('assets/icons/locationpin.png',scale: 3.5,),
                                child: actualaddress == null
                                    ? Image.asset(
                                  'assets/icons/locationpin.png',
                                  scale: 3.5,
                                )
                                    : Container(),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      VariableText(
                        text: 'Shop Name',
                        fontsize: 12,
                        fontFamily: fontMedium,
                        weight: FontWeight.w500,
                        fontcolor: textcolorblack,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      RectangluartextFeild(
                        hinttext: "Shahid Ustaad Jeep Alteration",
                        cont: shopname,
                        //onChanged: enableBtn(email.text),
                        keytype: TextInputType.text,
                        textlength: 25,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      VariableText(
                        text: 'Second Name',
                        fontsize: 12,
                        fontFamily: fontMedium,
                        weight: FontWeight.w500,
                        fontcolor: textcolorblack,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      RectangluartextFeild(
                        hinttext: secondname.text,
                        cont: secondname,
                        //onChanged: enableBtn(email.text),
                        keytype: TextInputType.text,
                        textlength: 25,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      VariableText(
                        text: 'Second Number',
                        fontsize: 12,
                        fontFamily: fontMedium,
                        weight: FontWeight.w500,
                        fontcolor: textcolorblack,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      RectangluartextFeild(
                        hinttext: secondphoneno.text,
                        cont: secondphoneno,
                        //onChanged: enableBtn(email.text),
                        keytype: TextInputType.text,
                        textlength: 25,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      VariableText(
                        text: 'third Name',
                        fontsize: 12,
                        fontFamily: fontMedium,
                        weight: FontWeight.w500,
                        fontcolor: textcolorblack,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      RectangluartextFeild(
                        hinttext: thirdName.text,
                        cont: thirdName,
                        //onChanged: enableBtn(email.text),
                        keytype: TextInputType.text,
                        textlength: 25,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      VariableText(
                        text: 'Third Number',
                        fontsize: 12,
                        fontFamily: fontMedium,
                        weight: FontWeight.w500,
                        fontcolor: textcolorblack,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      RectangluartextFeild(
                        hinttext: thirdPhoneNo.text,
                        cont: thirdPhoneNo,
                        //onChanged: enableBtn(email.text),
                        keytype: TextInputType.text,
                        textlength: 25,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      // Row(
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         if (checkbox == true) {
                      //           setState(() {
                      //             checkbox = false;
                      //           });
                      //         } else if (checkbox == false) {
                      //           setState(() {
                      //             checkbox = true;
                      //           });
                      //         }
                      //       },
                      //       child: Container(
                      //         height: height * 0.025,
                      //         width: height * 0.025,
                      //         decoration: BoxDecoration(
                      //             color: checkbox == true ? themeColor1 : Colors.white,
                      //             border: Border.all(
                      //                 color: checkbox == true
                      //                     ? themeColor1
                      //                     : Color(0xFFB7B7B7)),
                      //             borderRadius: BorderRadius.circular(3)),
                      //         child: Center(
                      //             child:
                      //             Icon(Icons.check, size: 15, color: Colors.white)),
                      //       ),
                      //     ),
                      //     SizedBox(width: height*0.025,),
                      //     VariableText(
                      //       text: "Child Contact Details (Optional)",
                      //       fontsize: 13,
                      //       fontcolor: textcolorlightgrey2,
                      //       fontFamily: fontRegular,
                      //     ),
                      //
                      //
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: height * 0.03,
                      // ),
                      // checkbox == true?Container(
                      //   height: height*0.28,
                      //   width: width,
                      //   decoration: BoxDecoration(
                      //       color: Color(0xffF4F4F4),
                      //       borderRadius: BorderRadius.circular(4),
                      //       border: Border.all(color: Color(0xffEEEEEE))
                      //
                      //   ),
                      //   child: Padding(
                      //     padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         SizedBox(
                      //           height: height * 0.03,
                      //         ),
                      //         VariableText(
                      //           text: 'Second Name',
                      //           fontsize:12,
                      //           fontFamily: fontMedium,
                      //           weight: FontWeight.w500,
                      //           fontcolor: textcolorblack,
                      //         ),
                      //         SizedBox(
                      //           height: height * 0.01,
                      //         ),
                      //         RectangluartextFeild(
                      //           containerColor:Color(0xffE5E5E5),
                      //           hinttext: "Farhan Ali",
                      //           cont: secondname,
                      //           //onChanged: enableBtn(email.text),
                      //           keytype: TextInputType.text,
                      //           textlength: 25,
                      //
                      //           enableborder: false,
                      //         ),
                      //         SizedBox(
                      //           height: height * 0.03,
                      //         ),
                      //         VariableText(
                      //           text: 'Second Phone No.#',
                      //           fontsize:12,
                      //           fontFamily: fontMedium,
                      //           weight: FontWeight.w500,
                      //           fontcolor: textcolorblack,
                      //         ),
                      //         SizedBox(
                      //           height: height * 0.01,
                      //         ),
                      //         RectangluartextFeild(
                      //           enableborder: false,
                      //           hinttext: "+921231234567",
                      //           cont: secondphoneno,
                      //
                      //
                      //           containerColor:Color(0xffE5E5E5),
                      //           //onChanged: enableBtn(email.text),
                      //           keytype: TextInputType.number,
                      //           textlength: 25,
                      //         ),
                      //         SizedBox(
                      //           height: height * 0.03,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      //
                      //
                      // ):Container(
                      // ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      InkWell(
                        onTap: () async{
                          if (validateFields()) {
                            setLoading(true);
                          Response response = await  addCustomer(
                              emp_id: userData.id,
                              shopName: shopname.text,
                              shopAddress: actualaddress,
                              person1: name.text,
                              person1No: phoneno.text,
                              person2: secondname.text,
                              person2No: secondphoneno.text,
                              person3: thirdName.text,
                              person3No: thirdPhoneNo.text,
                              image: image,
                              city: sel_cities.cityCode,
                              area: sel_areas.areaCode,
                              category:
                              sel_party_categories.partyCategoriesCode,
                            ).then((response) {
                             SucessFullyCreatCustomer(
                                 CustomerId: CustomerId);
                             Fluttertoast.showToast(
                                 msg: "Shop Successfully Created",
                                 toastLength: Toast.LENGTH_LONG);
                              // var data=jsonDecode(utf8.decode(response.bodyBytes));
                              // var str =data['results'][0].toString();
                              // CustomerId=str.toString().split("y ")[1].split("}")[0];
                              // print("str is"+str.toString());
                              // const start = ";";
                              // const end = "}";
                              // final startIndex = str.indexOf(start);
                              // final endIndex = str.indexOf(end, startIndex + start.length);
                              // final resultToast=str.substring(startIndex + start.length, endIndex);
                            }).catchError((ex, stack) {
                              setLoading(false);
                              print("exception is" +
                                  ex.toString() +
                                  stack.toString());
                              Fluttertoast.showToast(
                                  msg: ex.toString(),
                                  toastLength: Toast.LENGTH_SHORT);
                            }).timeout(Duration(seconds: _secs), onTimeout: () {
                              setLoading(false);
                              Fluttertoast.showToast(
                                  msg: _timeoutString,
                                  toastLength: Toast.LENGTH_SHORT);
                            });
                           if(response.statusCode==200){
                             SucessFullyCreatCustomer(
                                 CustomerId: CustomerId);
                             Fluttertoast.showToast(
                                 msg: "Shop Successfully Created",
                                 toastLength: Toast.LENGTH_LONG);
                           }
                            //addShopNew();
                          }
                        },
                        child: Container(
                          height: height * 0.06,
                          decoration: BoxDecoration(
                            color: themeColor1,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: VariableText(
                              text: 'Add Customer',
                              weight: FontWeight.w700,
                              fontsize: 16,
                              fontFamily: fontRegular,
                              fontcolor: themeColor2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        isLoading ? Positioned.fill(child: ProcessLoading()) : Container(),
      ],
    );
  }

  bool validateFields() {
    bool ok = false;
    if (name.text.isNotEmpty) {
      if (phoneno.text.isNotEmpty) {
        if (sel_cities != null) {
          if (sel_areas != null) {
            if (sel_party_categories != null) {
              if (currentlocation.text.isEmpty) {
                if (shopname.text.isNotEmpty) {
                  ok = true;
                } else {
                  Fluttertoast.showToast(
                      msg: "Please Enter Shop Name",
                      toastLength: Toast.LENGTH_SHORT);
                }
              } else {
                Fluttertoast.showToast(
                    msg: "Please Enable Location",
                    toastLength: Toast.LENGTH_SHORT);
              }
            } else {
              Fluttertoast.showToast(
                  msg: "Please Select Party Categories",
                  toastLength: Toast.LENGTH_SHORT);
            }
          } else {
            Fluttertoast.showToast(
                msg: "Please Select Area", toastLength: Toast.LENGTH_SHORT);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Please Select City", toastLength: Toast.LENGTH_SHORT);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please Enter Phone", toastLength: Toast.LENGTH_SHORT);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Name", toastLength: Toast.LENGTH_SHORT);
    }
    return ok;
  }

  int _secs = 20;
  String _timeoutString = "Response Timed Out";

  Future<void> addShopNew() async {
    setLoading(true);
    if (image != null) {
      var tempImage = await MultipartFile.fromFile(image.path,
          filename:
          "${DateTime.now().millisecondsSinceEpoch.toString()}.${image.path.split('.').last}",
          contentType: new MediaType('image', 'jpg'));
      print(tempImage.filename);
      postImage(tempImage);
    } else {
      registerCustomer('');
    }
  }

  Future<Response> addCustomer(
      {String emp_id,
        String shopName,
        String shopAddress,
        String Address,
        String person1,
        String person1No,
        String person2,
        String person2No,
        String person3,
        String person3No,
        String city,
        String area,
        String category,
        File image}) async {
    var tempImage;
    if (image != null) {
      tempImage = await MultipartFile.fromFile(image.path,
          filename:
          "${DateTime.now().millisecondsSinceEpoch.toString()}.${image.path.split('.').last}",
          contentType: new MediaType('image', 'jpg'));
      print(tempImage.filename);
      var response =
      await OnlineDatabase.uploadImage(type: 'customer', image: tempImage)
          .catchError((error) => Fluttertoast.showToast(
          msg: "Image posting fail Please try again",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0))
          .then((value) async {
        Map<String, dynamic> data = {
          "employee_id": emp_id,
          "phone": phoneNumber,
          "password": password,
          "shop_name": shopName,
          "shop_address": shopAddress,
          "shop_lat": widget.locationdata.latitude,
          "shop_long": widget.locationdata.longitude,
          "person1_name": person1,
          "person1_number": person1No,
          "person2_name": person2,
          "person2_number": person2No,
          "person3_name": person3,
          "person3_number": person3No,
          "shop_state": 1,
          "shop_city": city,
          "shop_area": area,
          "shop_category": category,
          "shop_image":
          'https://suqexpress.com/assets/images/customer/${tempImage.filename}'
        };
        var dio = Dio();
        String url = "http://erp.suqexpress.com/api/customer";
        print(data);
        FormData formData = new FormData.fromMap(data);
        var response = await dio.post(url, data: formData);
        return response;
      });
    } else {
      Map<String, dynamic> data = {
        "employee_id": emp_id,
        "phone": phoneNumber,
        "password": password,
        "shop_name": shopName,
        "shop_address": shopAddress,
        "shop_lat": widget.locationdata.latitude,
        "shop_long": widget.locationdata.longitude,
        "person1_name": person1,
        "person1_number": person1No,
        "person2_name": person2,
        "person2_number": person2No,
        "person3_name": person3,
        "person3_number": person3No,
        "shop_state": 1,
        "shop_city": city,
        "shop_area": area,
        "shop_category": category,
        "shop_image": null,
      };
      var dio = Dio();
      String url = "http://erp.suqexpress.com/api/customer";
      print(data);
      FormData formData = new FormData.fromMap(data);
      var response = await dio.post(url, data: formData);
      return response;
    }
  }

  void postImage(var image) async {
    try {
      var response =
      await OnlineDatabase.uploadImage(type: 'customer', image: image);
      if (response) {
        setLoading(false);
        print("Success");
        String imageUrl =
            'https://suqexpress.com/assets/images/customer/${image.filename}';
        registerCustomer(imageUrl);
      } else {
        setLoading(false);
        print("failed");
        Fluttertoast.showToast(
            msg: 'Image upload failed', toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e, stack) {
      setLoading(false);
      print('exception is: ' + e.toString());
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<dynamic> registerCustomer(String imageUrl) async {
    String URL = directory +
        'postcreateshop?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&'
            'pin_userid=$phoneNumber&pin_password=$password&pin_shopname=${shopname.text}&pin_address=${actualaddress.toString()}&pin_partycategory=$sel_party_categories&'
            'pin_city=${sel_cities.cityCode ?? ''}&pin_image_url=${imageUrl}&pin_area=${sel_areas.areaCode == 'null' ? '' : sel_areas.areaCode}&pin_mobile=${'+92' + phoneno.text}&pin_phone1=${'+92' + phoneno.text}&pin_phone2= ${'+92' + secondphoneno.text}&pin_ntn=1'
            '&pin_person1=${name.text}&pin_person2=${secondname.text}&pin_longitude=${widget.locationdata.longitude.toString()}&pin_latitude=${widget.locationdata.latitude.toString()}&po_cust_code';
    print("url is: " + URL.toString());
    var url = Uri.parse(URL);
    setLoading(true);
    await http
        .post(
      url,
      body: null,
    )
        .then((response) {
      print("response code is" + response.statusCode.toString());
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      var str = data['results'][0].toString();
      CustomerId = str.toString().split("y ")[1].split("}")[0];
      print("str is" + str.toString());
      const start = ";";
      const end = "}";
      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);
      final resultToast = str.substring(startIndex + start.length, endIndex);
      if (response.statusCode == 200) {
        print("data is" + data.toString());
        SucessFullyCreatCustomer(CustomerId: CustomerId);
      } else {
        setLoading(false);
        String msg = data["message"]
            .toString()
            .replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll(",", "\n");
        Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((ex, stack) {
      setLoading(false);
      print("exception is" + ex.toString() + stack.toString());
      Fluttertoast.showToast(
          msg: ex.toString(), toastLength: Toast.LENGTH_SHORT);
    }).timeout(Duration(seconds: _secs), onTimeout: () {
      setLoading(false);
      Fluttertoast.showToast(
          msg: _timeoutString, toastLength: Toast.LENGTH_SHORT);
    });
  }

  SucessFullyCreatCustomer({String CustomerId}) {
    setLoading(false);
    Fluttertoast.showToast(
        msg: "Shop Created Successfully $CustomerId",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.push(context,MaterialPageRoute(builder: (context)=>SucessFullyAddCustomerScreen()));
        //SwipeLeftAnimationRoute(widget: SucessFullyAddCustomerScreen()));
  }

  /*void postImage({String customerId}) async{
    try {
      setLoading(true);
      var response =await  OnlineDataBase.postImage(customerCode: customerId,source:'CUSTOMER',apiName: 'postcreateshop',imageFor: 'PAGETITLE',imageBinary:image.path );
      print("Response is" + response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print("Response is: " + data.toString());
        Fluttertoast.showToast(
            msg: "Shop Created Successfully",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0
        );     setLoading(false);
        Navigator.push(
            context, SwipeLeftAnimationRoute(widget: SucessFullyAddCustomerScreen()));

      }
      else if(response.statusCode == 401){
        setLoading(false);
      }
      else {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        setLoading(false);

      }
    } catch (e, stack) {
      print('exception is'+e.toString());
      setLoading(false);
    }
  }*/

  failedToCreateCustomer() {
    setLoading(false);
    Fluttertoast.showToast(
        msg: "Failed to Create Shop",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
}
