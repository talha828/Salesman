import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/MechanicScreen/successfully_add_mechanic_screen.dart';

import 'codeScreen.dart';

class AddMechanicScreen extends StatefulWidget {
  CustomerModel customer;
  AddMechanicScreen({this.customer});

  @override
  State<AddMechanicScreen> createState() => _AddMechanicScreenState();
}

class _AddMechanicScreenState extends State<AddMechanicScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController idCard = TextEditingController();
  bool showImage = false;
  bool showImage2 = false;
  File personImage;
  File idImage;

  bool loading = false;

  setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  _uploadImg(bool fromCamera) async {
    if (fromCamera) {
      XFile image = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 50);
      if (image != null) {
        print(image.path);
        setState(() {
          this.personImage = File(image.path);
          showImage = true;
        });
      }
    } else {
      XFile image = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 50);
      if (image != null) {
        print(image.path);
        setState(() {
          this.idImage = File(image.path);
          showImage2 = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserModel>(context);
    var cus=Provider.of<CustomerList>(context).singleCustomer;
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return Scaffold(
      appBar: MyAppBar(
          title: 'Add Mechanic',
          ontap: () {
            Navigator.pop(context);
          }),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VariableText(
                    text: "Mechanic Image",
                    fontsize: 12,
                    fontFamily: fontMedium,
                    weight: FontWeight.w500,
                    fontcolor: textcolorblack,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Container(
                    child: showImage != true
                        ? Row(
                      children: [
                        Spacer(),
                        DottedBorder(
                            color:
                            Color(0xffE5E5E5), //color of dotted/dash line
                            strokeWidth: 1.5, //thickness of dash/dots
                            dashPattern: [8, 4],
                            child: Container(
                              height: height * 0.20,
                              width: width -50,
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
                        // //dash patterns, 10 is dash width, 6 is space width
                        // DottedBorder(
                        //     color:
                        //         Color(0xffE5E5E5), //color of dotted/dash line
                        //     strokeWidth: 1.5, //thickness of dash/dots
                        //     dashPattern: [8, 4],
                        //     child: Container(
                        //       height: height * 0.20,
                        //       width: width * 0.42,
                        //       color: Color(0xffE5E5E5),
                        //       child: GestureDetector(
                        //           onTap: () {
                        //             _uploadImg(false);
                        //           },
                        //           child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.center,
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.center,
                        //             children: [
                        //               Image.asset(
                        //                 "assets/icons/gallery.png",
                        //                 scale: 3.5,
                        //               ),
                        //               SizedBox(
                        //                 height: height * 0.02,
                        //               ),
                        //               VariableText(
                        //                 text: "Gallery",
                        //                 fontsize: 13,
                        //                 weight: FontWeight.w400,
                        //                 fontcolor: textcolorblack,
                        //                 fontFamily: fontRegular,
                        //               ),
                        //             ],
                        //           )),
                        //     )),
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
                                  personImage = null;
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
                                      personImage,
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
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius:
                                        BorderRadius.circular(50),
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
                    ),
                  ),
                  MyTextFields(
                    title: "Mechanic Name",
                    controller: name,
                    hint: "Ahsan Iqbal",
                    onChange: (value) {
                      name = TextEditingController(text: value);
                    },
                  ),
                  MyTextFields(
                    title: "Mechanic Phone  Number",
                    controller: phoneNo,
                    hint: "+923012071090",
                    onChange: (value) {
                      phoneNo = TextEditingController(text: value);
                    },
                  ),
                  MyTextFields(
                    title: "Mechanic ID Card No",
                    controller: idCard,
                    hint: "42301-2563-7894-3",
                    onChange: (value) {
                      idCard = TextEditingController(text: value);
                    },
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  VariableText(
                    text: "Id Card Image",
                    fontsize: 12,
                    fontFamily: fontMedium,
                    weight: FontWeight.w500,
                    fontcolor: textcolorblack,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Container(
                    child: showImage2 != true
                        ? Row(
                      children: [
                        Spacer(),
                        DottedBorder(
                            color:
                            Color(0xffE5E5E5), //color of dotted/dash line
                            strokeWidth: 1.5, //thickness of dash/dots
                            dashPattern: [8, 4],
                            child: Container(
                              height: height * 0.20,
                              width: width -50,
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
                        // //dash patterns, 10 is dash width, 6 is space width
                        // DottedBorder(
                        //     color:
                        //         Color(0xffE5E5E5), //color of dotted/dash line
                        //     strokeWidth: 1.5, //thickness of dash/dots
                        //     dashPattern: [8, 4],
                        //     child: Container(
                        //       height: height * 0.20,
                        //       width: width * 0.42,
                        //       color: Color(0xffE5E5E5),
                        //       child: GestureDetector(
                        //           onTap: () {
                        //             _uploadImg(false);
                        //           },
                        //           child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.center,
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.center,
                        //             children: [
                        //               Image.asset(
                        //                 "assets/icons/gallery.png",
                        //                 scale: 3.5,
                        //               ),
                        //               SizedBox(
                        //                 height: height * 0.02,
                        //               ),
                        //               VariableText(
                        //                 text: "Gallery",
                        //                 fontsize: 13,
                        //                 weight: FontWeight.w400,
                        //                 fontcolor: textcolorblack,
                        //                 fontFamily: fontRegular,
                        //               ),
                        //             ],
                        //           )),
                        //     )),
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
                                  personImage = null;
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
                                      idImage,
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
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius:
                                        BorderRadius.circular(50),
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
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  MyButton(onTap: () async {
                    setLoading(true);
                    var location =await Location().getLocation();
                    if (name.text != null &&
                        phoneNo.text != null &&
                        idCard.text != null &&
                        personImage != null &&
                        idImage != null
                    ) {
                      if (phoneNo.text.length > 11) {
                        if (idCard.text.length > 13) {
                          //TODO:// Arsalan Api http 500 not working properly
                          var dio = new Dio();
                          String url = "https://erp.suqexpress.com/api/getcode";
                          Map<String, dynamic> map = {
                            "purpose": 3,
                            "number": phoneNo.text,
                            "emp_name": userData.userName,
                          };
                          FormData formData = FormData.fromMap(map);
                          //TODO sms post
                          Response smsResponse =
                              await dio.post(url, data: formData).then((value){
                                print(value);
                                setLoading(false);
                                if (value.data["success"].toString() == "true") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CodeScreen(
                                            //TODO set arsalan code to controller
                                            pin: value.data["code"].toString(),
                                            contactNumbers: phoneNo.text,
                                            mechanicName: name.text,
                                            //TODO when code match
                                            onSuccess: () async {
                                              String url =
                                                  "https://erp.suqexpress.com/api/mechanics";
                                              var tempImage =
                                              await MultipartFile.fromFile(
                                                  personImage.path,
                                                  filename:
                                                  "${DateTime.now().millisecondsSinceEpoch.toString()}.${personImage.path.split('.').last}",
                                                  contentType: new MediaType(
                                                      'image', 'jpg'));
                                              print(tempImage.filename);
                                              var response1 = await OnlineDatabase
                                                  .uploadImage(
                                                  type: 'mechanics',
                                                  image: tempImage)
                                                  .catchError((error) =>
                                                  Fluttertoast.showToast(
                                                      msg:
                                                      "Image posting fail Please try again",
                                                      toastLength:
                                                      Toast.LENGTH_SHORT,
                                                      backgroundColor:
                                                      Colors.black87,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0));
                                              var tempImage2 =
                                              await MultipartFile.fromFile(
                                                  idImage.path,
                                                  filename:
                                                  "${DateTime.now().millisecondsSinceEpoch.toString()}.${idImage.path.split('.').last}",
                                                  contentType: new MediaType(
                                                      'image', 'jpg'));
                                              print(tempImage2.filename);
                                              var response2 = await OnlineDatabase
                                                  .uploadImage(
                                                  type: 'mechanicscnic',
                                                  image: tempImage2)
                                                  .catchError((error) =>
                                                  Fluttertoast.showToast(
                                                      msg:
                                                      "Image posting fail Please try again",
                                                      toastLength:
                                                      Toast.LENGTH_SHORT,
                                                      backgroundColor:
                                                      Colors.black87,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0));
                                              Map<String, dynamic> map = {
                                                "picture":
                                                'https://suqexpress.com/assets/images/mechanics/${tempImage.filename}',
                                                "cnic_picture":
                                                'https://suqexpress.com/assets/images/mechanicscnic/${tempImage2.filename}',
                                                "name": name.text,
                                                "code_id":value.data["id"],
                                                "phone": phoneNo.text,
                                                "cnic": idCard.text,
                                                "customer_id":cus.customerCode,
                                                "emp_id":userData.userID,
                                                "lat":location.latitude,
                                                "long":location.longitude
                                              };
                                              var dio = new Dio();
                                              FormData fromData =
                                              FormData.fromMap(map);
                                              var response = await dio
                                                  .post(url, data: fromData)
                                                  .catchError((e) {
                                                setLoading(false);
                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.ERROR,
                                                  animType: AnimType.BOTTOMSLIDE,
                                                  title: "Something went wrong",
                                                  desc: "Error: " + e.response.data["data"].toString(),
                                                  btnCancelText: "Ok",
                                                  dismissOnTouchOutside: false,
                                                  btnOkOnPress: () {},
                                                )..show();
                                              }).then((value) {
                                                setLoading(false);
                                               if(value.data["success"].toString()=="true"){
                                                 Fluttertoast.showToast(
                                                     msg:
                                                     value.data["message"].toString(),
                                                     toastLength: Toast.LENGTH_SHORT,
                                                     backgroundColor: Colors.black87,
                                                     textColor: Colors.white,
                                                     fontSize: 16.0);
                                                 Navigator.push(
                                                     context,
                                                     MaterialPageRoute(
                                                         builder: (context) =>
                                                             SuccessFullyMechanicAddScreen(customer: widget.customer,)));
                                               }else{
                                                 Fluttertoast.showToast(
                                                     msg:
                                                     "Something went wrong",
                                                     toastLength: Toast.LENGTH_SHORT,
                                                     backgroundColor: Colors.black87,
                                                     textColor: Colors.white,
                                                     fontSize: 16.0);
                                                 Navigator.pop(context);
                                               }
                                              });
                                            },
                                          )));
                                } else {
                                  setLoading(false);
                                  Fluttertoast.showToast(
                                      msg: "Code not sent, Try again",
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              })
                                  // TODO// when status code in not equal to 200;
                                      .catchError((e){
                                        setLoading(false);
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: "Code Not Sent",
                                  desc: "Error: " + e.response.data["message"].toString(),
                                  btnCancelText: "Ok",
                                  dismissOnTouchOutside: false,
                                  btnOkOnPress: () {},
                                )..show();
                              });
                          //TODO when status code == 200
                        } else {
                          setLoading(false);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.BOTTOMSLIDE,
                            title: "Incorrect ID Card",
                            desc: "Please check ID card Number",
                            btnCancelText: "Ok",
                            dismissOnTouchOutside: false,
                            btnOkOnPress: () {},
                          )..show();
                        }
                      } else {
                        setLoading(false);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.BOTTOMSLIDE,
                          title: "Incorrect Phone Number",
                          desc: "Please check phone Number",
                          btnCancelText: "Ok",
                          dismissOnTouchOutside: false,
                          btnOkOnPress: () {},
                        )..show();
                      }
                    } else {
                      setLoading(false);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.BOTTOMSLIDE,
                        title: "Insufficient Information",
                        desc: "Please fill all the details",
                        btnCancelText: "Ok",
                        dismissOnTouchOutside: false,
                        btnOkOnPress: () {},
                      )..show();
                    }
                  }),
                ],
              ),
            ),
          ),
          loading ? Positioned.fill(child: ProcessLoading()) : Container(),
        ],
      ),
    );
  }
}
