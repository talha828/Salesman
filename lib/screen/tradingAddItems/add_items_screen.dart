import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:http_parser/http_parser.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/generated/assets.dart';
import 'package:salesmen_app_new/newModel/productModel.dart';
import 'package:salesmen_app_new/newModel/search_product_model.dart' as s;
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/checkinScreen/checkin_screen.dart';
import 'package:salesmen_app_new/screen/tradingAddItemDetailsScreen/tradingAddItemDetailsScreen.dart';

class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({Key key}) : super(key: key);

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  bool flag = false;
  final ImagePicker _picker = ImagePicker();
  File file;

  bool isLoading=false;
  List<s.Results> list = [];
  List<s.Results> searchList = [];
  s.ProductSearchModel search;
  getSearchRecord() async{
    setLoading(true);
    var response = await OnlineDatabase.getOfferSearchProduct().catchError((e){
      setLoading(false);
    });
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      search = s.ProductSearchModel.fromJson(data);
      for(var i in search.results){
        if(list.where((element) => element.productCode ==i.productCode).isNotEmpty){

        }else{
          list.add(i);
          searchList.add(i);
        }
      }

      // list=search.results.toSet().toList();
      // searchList=search.results.toSet().toList();
      setLoading(false);
    } else {
      Fluttertoast.showToast(msg: "Error: ${data['results'].toString()}");
      setLoading(false);
    }
  }
  setLoading(bool value)=> setState(()=> isLoading=value,);

  postCategory() async {
    if(name.text.isNotEmpty){
      if(description.text.isNotEmpty){
        if(flag) {
          setLoading(true);
          var tempImage = await MultipartFile.fromFile(file.path,
              filename:
              "${DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString()}.${file.path
                  .split('.')
                  .last}",
              contentType: MediaType('image', 'jpg'));
          print(tempImage.filename);
          var response1 = await OnlineDatabase.uploadImage(
              type: 'product_offer', image: tempImage)
              .catchError((error) =>
              Fluttertoast.showToast(
                  msg: "Image posting fail Please try again",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 16.0));
          if (response1) {
            var location = await Location().getLocation();
            var response = await OnlineDatabase.postNewCategory(
              lat: location.latitude.toString(),
              long: location.longitude.toString(),
              imageUrl: "https://suqexpress.com/assets/images/product_offer/${ tempImage.filename}",
              title: name.text.toString(),
              description: description.text.toString(),)
                .catchError((e) {
              setLoading(false);
            });
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            if (response.statusCode == 200) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Item Post Successfully',
                desc: "Wait for 24 hr",
                btnOkOnPress: () {
                  g.Get.to(CheckInScreen());
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
            Fluttertoast.showToast(
                msg: "Please select The Image",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      }else{
        Fluttertoast.showToast(
            msg: "Please Fill the description of product",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }else{
      Fluttertoast.showToast(
          msg: "Please enter the name of product",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  @override
  void initState() {
    getSearchRecord();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "Add Item",
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
                    vertical: width * 0.12, horizontal: width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    flag
                        ? InkWell(
                        onLongPress: (){
                          setState(() {
                            flag = false;
                          });
                        },
                          child: Container(
                              height: width * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: RotatedBox(
                                  quarterTurns: 135,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        file.readAsBytesSync(),
                                        fit: BoxFit.fill,
                                      ))),
                            ),
                        )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  // PickedFile image = await _picker.getImage(source: ImageSource.camera);
                                  file = File(await ImagePicker()
                                      .getImage(source: ImageSource.gallery,imageQuality:10)
                                      .then((pickedFile) => pickedFile.path));
                                  setState(() {
                                    flag = true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.4))),
                                  padding: EdgeInsets.symmetric(
                                      vertical: width * 0.04,
                                      horizontal: width * 0.04),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: width * 0.10,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        height: width * 0.04,
                                      ),
                                      Text(
                                        "Pick Form Gallery",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  file = File(await ImagePicker()
                                      .getImage(source: ImageSource.camera,imageQuality: 10)
                                      .then((pickedFile) => pickedFile.path));
                                  setState(() {
                                    flag = true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.4))),
                                  padding: EdgeInsets.symmetric(
                                      vertical: width * 0.04,
                                      horizontal: width * 0.04),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.camera,
                                        size: width * 0.10,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        height: width * 0.04,
                                      ),
                                      Text(
                                        "Pick Form Camera",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: width * 0.12,
                    ),
                    TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: name,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)),
                              hintText: "Ex. Lux",
                              labelText: "Product Name",
                              suffixStyle: const TextStyle(color: themeColor1)),
                      ),
                      suggestionsCallback:(String query) {

                    searchList = list
                        .where((product) =>
                    product.productName.toLowerCase().contains(query.toLowerCase()) ||
                    product.productCode.toLowerCase().contains(query.toLowerCase()))
                        .toList();
                    return searchList;
                    },
                      itemBuilder: (context,suggestion) {
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: suggestion.image.toString() ==
                                "null"
                                ? Image.asset(Assets.imagesGear)
                                : Image.network(
                              suggestion.image,
                              width: width * 0.2,
                              height: width * 0.3,
                              fit: BoxFit.fill,
                              errorBuilder:
                                  (context, object, stackTrace) {
                                return Image.asset(Assets.imagesGear);
                              },
                            ),
                          ),
                          title: Text(suggestion.productName),
                          subtitle: Text(suggestion.productCode),
                        );
                      },
                      onSuggestionSelected: (suggestion)async {
                        setLoading(true);
                        var response =
                            await OnlineDatabase.getSingleProduct(
                            productCode:suggestion.productCode)
                            .then((value) {
                          var data = jsonDecode(
                              utf8.decode(value.bodyBytes));
                          if (value.statusCode == 200) {
                            Product product = Product.fromJson(data);
                            g.Get.to(TradingAddProductDetails(results: product.results.first,));
                            setLoading(false);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Error: ${data["results"]}");
                            setLoading(false);
                          }
                        }).catchError((error) {
                          Fluttertoast.showToast(
                              msg: "Error: ${error.toString()}");
                          setLoading(false);
                        });
                      },
                    ),
                    // MyTextField(
                    //   obscureText: false,
                    //   controller: name,
                    //   hintText: "EX. Lifebuoy",
                    //   labelText: "Product Name",
                    // ),
                    SizedBox(
                      height: width * 0.04,
                    ),
                    MyTextField(
                      obscureText: false,
                      controller: description,
                      hintText: "color,size,quantity",
                      labelText: "Product description",
                    ),
                    SizedBox(
                      height: width * 0.04,
                    ),
                    Text("*Enter All detail Color, Size, Quantity"),
                    SizedBox(
                      height: width * 0.12,
                    ),
                    InkWell(
                      onTap: ()=>postCategory(),
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
                            vertical: width * 0.04, horizontal: width * 0.04),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                    // ElevatedButton(
                    //     style: ButtonStyle(
                    //       backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0C9933))
                    //     ),
                    //     onPressed: (){}, child: Text("Submit")),
                  ],
                ),
              ),
            ),
          ),
          isLoading?Positioned.fill(child: GreenLoading(),):Container(),
        ],
      ),
    );
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
