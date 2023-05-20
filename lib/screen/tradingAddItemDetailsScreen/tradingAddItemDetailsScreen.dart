import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/newModel/productModel.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/checkinScreen/checkin_screen.dart';
import 'package:salesmen_app_new/screen/tredingProductScreen/treding_product_screen.dart';

class TradingAddProductDetails extends StatefulWidget {
  Results results;
  TradingAddProductDetails({this.results, Key key}) : super(key: key);

  @override
  State<TradingAddProductDetails> createState() =>
      _TradingAddProductDetailsState();
}

class _TradingAddProductDetailsState extends State<TradingAddProductDetails> {
  TextEditingController qty = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController mrp = TextEditingController();
  TextEditingController expire = TextEditingController();

  String date = "Expire Date";

  bool isLoading = false;
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  postData(String custCode) async {
    if (qty.text.isNotEmpty) {
      if (rate.text.isNotEmpty) {
        setLoading(true);
        var location = await Location().getLocation();
        var response = await OnlineDatabase.postOffer(
          customerCode: custCode,
          productCode: widget.results.pRODCODE,
          qty: qty.text,
          rate: rate.text,
          MRP: mrp.text,
          expire: date == "Expire Date" ? "" : date,
          lat: location.latitude.toString(),
          long: location.longitude.toString(),
        );
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        if (response.statusCode == 200) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Offer Post Successfully',
            desc: 'Your Offer Post  Successfully return to main screen',
            btnOkOnPress: () {
              Get.to(CheckInScreen());
            },
          ).show();
          setLoading(false);
        } else {
          setLoading(false);
          Fluttertoast.showToast(
              msg: data["results"].toString(),
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(msg: "Please add Rate");
      }
    } else {
      Fluttertoast.showToast(msg: "Please add Quantity");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var userData = Provider.of<CustomerList>(context).singleCustomer;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Get.back(),
              ),
              title: Text(
                "Add Product Details",
                style: TextStyle(color: Colors.white),
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      end: Alignment.topRight,
                      begin: Alignment.bottomLeft,
                      colors: <Color>[
                        const Color(0xFF22E774),
                        const Color(0xFF0C9933),
                      ]),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: width * 0.04,
                ),
                child: Column(
                  children: [
                    ProductTile(
                      width: width,
                      product: widget.results,
                      additem: false,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      child: Column(
                        children: [
                          SizedBox(
                            height: width * 0.08,
                          ),
                          MyTextField(
                            textInputType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            obscureText: false,
                            controller: qty,
                            hintText: "Ex. 9",
                            labelText: "Quantity",
                          ),
                          SizedBox(
                            height: width * 0.04,
                          ),
                          MyTextField(
                            textInputType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            obscureText: false,
                            controller: rate,
                            hintText: "Ex. 1200",
                            labelText: "Rate",
                          ),
                          SizedBox(
                            height: width * 0.04,
                          ),
                          MyTextField(
                            textInputType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            obscureText: false,
                            controller: mrp,
                            hintText: "Ex. 1300",
                            labelText: "MRP",
                          ),
                          SizedBox(
                            height: width * 0.04,
                          ),
                          InkWell(
                              onTap: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2023, 3),
                                    lastDate: DateTime(2050, 12),
                                    builder: (context, picker) {
                                      return Theme(
                                        //TODO: change colors
                                        data: ThemeData.dark().copyWith(
                                          colorScheme: ColorScheme.dark(
                                            primary: Colors.blue,
                                            onPrimary: Colors.white,
                                            surface: Colors.blue,
                                            onSurface: Colors.white,
                                          ),
                                          // dialogBackgroundColor:,
                                        ),
                                        child: picker,
                                      );
                                    }).then((selectedDate) {
                                  //TODO: handle selected date
                                  if (selectedDate != null) {
                                    setState(() {
                                      date = selectedDate
                                          .toString()
                                          .substring(0, 10);
                                    });
                                  }
                                });
                              },
                              child: IgnorePointer(
                                  ignoring: true,
                                  child: MyTextField(
                                    obscureText: false,
                                    textInputType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                    controller: expire,
                                    hintText: "Ex. 12-13-2023",
                                    labelText: date,
                                  ))),
                          SizedBox(
                            height: width * 0.08,
                          ),
                          InkWell(
                            onTap: () => postData(userData.customerCode),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        const Color(0xFF22E774),
                                        const Color(0xFF0C9933),
                                      ])),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: width * 0.04,
                                  horizontal: width * 0.04),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          isLoading
              ? Positioned.fill(
                  child: GreenLoading(),
                )
              : Container(),
        ],
      ),
    );
  }
}

class GreenLoading extends StatefulWidget {
  @override
  State createState() {
    return _GreenLoadingState();
  }
}

class _GreenLoadingState extends State<GreenLoading>
    with SingleTickerProviderStateMixin {
  AnimationController _cont;
  Animation<Color> _anim;

  @override
  void initState() {
    _cont = AnimationController(
        duration: Duration(
          seconds: 1,
        ),
        vsync: this);
    _cont.addListener(() {
      setState(() {
        //print("val: "+_cont.value.toString());
      });
    });
    ColorTween col = ColorTween(
      begin: Color(0xFF22E774),
      end: Color(0xFF0C9933),
    );
    _anim = col.animate(_cont);
    _cont.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        child: Center(
          child: Container(
              width: 50 * _cont.value,
              height: 50 * _cont.value,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  _anim.value,
                ),
              )),
        ));
  }
}

class MyTextField extends StatelessWidget {
  MyTextField({
    Key key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText,
    this.suffixIcon,
    this.textInputType,
    this.inputFormatters,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  bool obscureText = false;
  TextInputType textInputType;
  List<TextInputFormatter> inputFormatters;
  Widget suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)),
          hintText: hintText,
          labelText: labelText,
          suffixIcon: suffixIcon,
          suffixStyle: const TextStyle(color: themeColor1)),
    );
  }
}
