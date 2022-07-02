import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/model/customer_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/OrderScreen/products_list_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart'as http;

class CategoriesScreen extends StatefulWidget {
  // CustomerModel shopDetails;
  // double lat, long;
  // var locationdata;
  // List<CustomerModel> customerlist;
  //
  // CategoriesScreen(
  //     {this.shopDetails,
  //     this.customerlist,
  //     this.lat,
  //     this.long,
  //     this.locationdata});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // List<ProductModel> product = [];
  // List<ProductModel> searchProduct = [];
  bool addToCart = false;
  bool isLoading = false;
  TextEditingController _controller=TextEditingController();
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  //
  // void getAllProductCategory() async {
  //   try {
  //     setLoading(true);
  //     var response = await OnlineDataBase.getAllCategories();
  //     print("Response is" + response.statusCode.toString());
  //     //print("Response is" + response .toString());
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       product = [];
  //       var datalist = data['results'];
  //       // print("data is "+datalist.toString());
  //       if (datalist.isNotEmpty) {
  //         for (var item in datalist) {
  //           product.add(ProductModel.getProductMainCategory(item));
  //         }
  //         setLoading(false);
  //       } else {
  //         setLoading(false);
  //         Fluttertoast.showToast(
  //             msg: "Product not found",
  //             toastLength: Toast.LENGTH_SHORT,
  //             backgroundColor: Colors.black87,
  //             textColor: Colors.white,
  //             fontSize: 16.0);
  //       }
  //     } else if (response.statusCode == 400) {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       setLoading(false);
  //       Fluttertoast.showToast(
  //           msg: "${data['results'].toString()}",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     } else if (response.statusCode == 401) {
  //       setLoading(false);
  //       Fluttertoast.showToast(
  //           msg: "User not found",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: "Something went wrong try again later",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   } catch (e, stack) {
  //     print('exception is' + e.toString() + stack.toString());
  //     setLoading(false);
  //     Fluttertoast.showToast(
  //         msg: "Something went wrong try again later",
  //         toastLength: Toast.LENGTH_SHORT,
  //         backgroundColor: Colors.black87,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }
  //
  // void getAllProduct() async {
  //   try {
  //     setLoading(true);
  //     var response = await OnlineDataBase.getAllproductsubcategory(
  //         subTypeId: "", maintypeId: "");
  //     print("Response is" + response.statusCode.toString());
  //     //print("Response is" + response .toString());
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       searchProduct = [];
  //       var datalist = data['results'];
  //       // print("data is "+datalist.toString());
  //       if (datalist.isNotEmpty) {
  //         for (var item in datalist) {
  //           searchProduct.add(ProductModel.fromJson(item));
  //         }
  //         setLoading(false);
  //       } else {
  //         setLoading(false);
  //         Fluttertoast.showToast(
  //             msg: "Product not found",
  //             toastLength: Toast.LENGTH_SHORT,
  //             backgroundColor: Colors.black87,
  //             textColor: Colors.white,
  //             fontSize: 16.0);
  //       }
  //     } else if (response.statusCode == 400) {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       setLoading(false);
  //       Fluttertoast.showToast(
  //           msg: "${data['results'].toString()}",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     } else if (response.statusCode == 401) {
  //       setLoading(false);
  //       Fluttertoast.showToast(
  //           msg: "User not found",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: "Something went wrong try again later",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   } catch (e, stack) {
  //     print('exception is' + e.toString() + stack.toString());
  //     setLoading(false);
  //     Fluttertoast.showToast(
  //         msg: "Something went wrong try again later",
  //         toastLength: Toast.LENGTH_SHORT,
  //         backgroundColor: Colors.black87,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }
  List<Widget> imageContainer=[];
  getSliderImage()async{
    Uri url=Uri.parse("https://suqexpress.com/api/getsliderimages");
    var response= await http.get(url).then((response) {
      print(response.body);
      if(response.statusCode==200){
        var data=jsonDecode(utf8.decode(response.bodyBytes));
        var item=data['data'];
        for (var image in item){
          var temp=ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(image['url'],fit: BoxFit.fill,),
          );
          print(image["url"]);
          imageContainer.add(temp);
          setState(() {
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSliderImage();
    // if(Provider.of<CartModel>(context, listen: false).cartItemName.length > 0){
    //   addToCart = true;
    // }
    // print(widget.customerlist.length.toString());
  }
  var f = NumberFormat("###,###.0#", "en_US");

  @override
  Widget build(BuildContext context) {
    // final cartdata = Provider.of<CartModel>(context, listen: true);
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Order"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.02),
            isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: themeColor1,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Container(
                                  //color: Colors.red,
                                  height: height * 0.16,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: 4,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, int i) {
                                        return Row(
                                          children: [
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                            Container(
                                              height: height * 0.14,
                                              width: width * 0.28,
                                              decoration: BoxDecoration(
                                                  color: themeColor1,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
                                            SizedBox(
                                              width: width * 0.03,
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: height * 0.010,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) => SearchProductScreen(
                                //             productModel: searchProduct,
                                //             shopDetails: widget.shopDetails,
                                //             lat: widget.lat,
                                //             long: widget.long,
                                //             locationdata: widget.locationdata,
                                //         onAddToCart: (){}))).then((value){
                                //   addToCart = false;
                                //   if (Provider.of<CartModel>(context, listen: false)
                                //       .cartItemName
                                //       .isNotEmpty) {
                                //     addToCart = true;
                                //   }
                                //   setState(() {});
                                // });
                              },
                              child: RectangluartextFeild(
                                bordercolor: Color(0xffEBEAEA),
                                hinttext: "Search all products",
                                containerColor: Color(0xFFFFFF),
                                enableborder: true,
                                // cont: _controller,
                                enable: false,
                                keytype: TextInputType.text,
                                textlength: 25, onSubmit: (String ) {  }, onChanged: (String ) {  },
                                cont: _controller,
                                // onChanged: searchOperation,
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Image.asset(
                                    'assets/icons/search.png',
                                    scale: 3,
                                  ),
                                ))
                          ],
                        ),
                      ),

                      SizedBox(
                        height: height * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: VariableText(
                              text: "Today Offer",
                              fontsize: 18,
                              fontcolor: Color(0xff1F1F1F),
                              fontFamily: fontRegular,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      CarouselSlider(
                        items: imageContainer,
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
                          aspectRatio: 2.0,
                        ),
                      ),

                      SizedBox(
                        height: height * 0.025,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenpadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VariableText(
                                    text: "SKR",
                                    fontsize: 18,
                                    fontcolor: Color(0xff1F1F1F),
                                    fontFamily: fontRegular,
                                    weight: FontWeight.w600,
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Container(
                                    //color: Colors.red,
                                    height: height * 0.16,
                                    child: ListView.builder(
                                        //shrinkWrap: true,
                                        itemCount: 10,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, int i) {
                                          return Row(
                                            children: [
                                              SizedBox(
                                                width: width * 0.01,
                                              ),
                                              customMenuContainer(
                                                  imagepath:
                                                      'assets/images/placeHolder.png',
                                                  text:"Temp",
                                                  height: height,
                                                  width: width,
                                                  ontap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                ProductListScreen(
                                                            )));
                                                    //         .then((value){
                                                    //   addToCart = false;
                                                    //   // if (Provider.of<CartModel>(context, listen: false)
                                                    //   //     .cartItemName
                                                    //   //     .isNotEmpty) {
                                                    //   //   addToCart = true;
                                                    //   // }
                                                    //   setState(() {});
                                                    // });
                                                  }),
                                              SizedBox(
                                                width: width * 0.03,
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
          ],
        ),
      ),
      bottomNavigationBar: addToCart
          ? InkWell(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => CartScreen(
          //         ))).then((value) {
          //   //getAllProductData();
          //   // addToCart = false;
          //   // if (Provider.of<CartModel>(context, listen: false)
          //   //     .cartItemName
          //   //     .isNotEmpty) {
          //   //   addToCart = true;
          //   // }
          // });
        },
        child: Container(
          color: themeColor2,
          child: Padding(
            padding: EdgeInsets.all(screenpadding),
            child: Container(
              height: height * 0.06,
              decoration: BoxDecoration(
                color: themeColor1,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenpadding),
                child: Row(
                  children: [
                    Container(
                      //height: height*0.04,
                      decoration: BoxDecoration(
                          color: themeColor1,
                          shape: BoxShape.circle,
                          border: Border.all(color: themeColor2)),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: VariableText(
                          // text: quantity.toString(),
                          text: "5"
                              .toString(), // totalcount.toString(),
                          weight: FontWeight.w500,
                          fontsize: 13,
                          fontFamily: fontMedium,
                          fontcolor: themeColor2,
                        ),
                      ),
                    ),
                    Spacer(),
                    VariableText(
                      text: 'Check Order Summary',
                      weight: FontWeight.w500,
                      fontsize: 13,
                      fontFamily: fontMedium,
                      fontcolor: themeColor2,
                    ),
                    Spacer(),
                    VariableText(
                      text: 'Rs. ' + "1000",
                      weight: FontWeight.w700,
                      fontsize: 13,
                      fontFamily: fontMedium,
                      fontcolor: themeColor2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
          : Container(
        height: height * 0.000002,
        color: Colors.white,
      ),
    );
  }

  Widget customMenuContainer(
      { String imagepath,
       String text,
       void Function() ontap,
       double height,
       double width}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: height * 0.14,
        width: width * 0.28,
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeColor1,
          //boxShadow: [BoxShadow(color:  Color.fromRGBO(31, 31, 31, 0.25),offset: Offset(0,0),blurRadius: 1.5)]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image.asset(imagepath,scale: 5.5),
            VariableText(
              text: text,
              fontsize: height * 0.016,
              fontcolor: themeColor2,
              fontFamily: fontMedium,
              weight: FontWeight.w600,
              line_spacing: 1.2,
              max_lines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
