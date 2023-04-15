import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/generated/assets.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/newModel/cartModel.dart';
import 'package:salesmen_app_new/newModel/productModel.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/checkinScreen/checkin_screen.dart';
import 'package:salesmen_app_new/screen/mainScreen/mainScreen.dart';
import 'package:salesmen_app_new/screen/select_item_screen/select_item_screen.dart';
import 'package:shimmer/shimmer.dart';


class SubMenuScreen extends StatefulWidget {
  String productmaintypeId, productsubtypeId;
  int value;
  SubMenuScreen({this.value, this.productmaintypeId, this.productsubtypeId});

  @override
  _SubMenuScreenState createState() => _SubMenuScreenState();
}

class _SubMenuScreenState extends State<SubMenuScreen> {
  Map<String, dynamic> imageUrl;
  List imageList = [];
  List<Widget> imageContainer = [];
  getSliderImage() async {
    Uri url = Uri.parse("https://suqexpress.com/api/getsliderimages");
    var response = await http.get(url).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        var item = data['data'];
        for (var image in item) {
          var temp = ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              image['url'],
              fit: BoxFit.fill,
            ),
          );
          print(image["url"]);
          imageContainer.add(temp);
          setState(() {});
        }
      }
    });
  }

  // Map<String, dynamic> sliderData = {
  //   'auto_slide': true,
  //   'interval': 3,
  //   'slides': [
  //     {
  //       'image_url': 'assets/images/homeSlider_1.png'
  //     },
  //     {
  //       'image_url': 'assets/images/homeSlider_2.png'
  //     },
  //     {
  //       'image_url': 'assets/images/homeSlider_1.png'
  //     },
  //     {
  //       'image_url': 'assets/images/homeSlider_2.png'
  //     },
  //     {
  //       'image_url': 'assets/images/homeSlider_1.png'
  //     }
  //   ]
  // };
  Map<String, dynamic> productList = {
    "products": [
      {
        'id': '1',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product_1.png",
        "description":
            'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "3.5"
      },
      {
        'id': '2',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product_1.png",
        "description":
            'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "1"
      },
      {
        'id': '3',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product_1.png",
        "description":
            'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "5"
      },
      {
        'id': '4',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product_1.png",
        "description":
            'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "3"
      },
      {
        'id': '5',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product_1.png",
        "description":
            'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "5"
      },
      {
        'id': '6',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product_1.png",
        "description":
            'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "2.5"
      },
      {
        'id': '6',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product_1.png",
        "description":
            'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "5"
      },
    ]
  };
  bool addToCart = false;
  // void autoPlayBanner() {
  //   List<Map<String, dynamic>> items = sliderData['slides'];
  //   timer = Timer.periodic(Duration(seconds: sliderData['interval']), (callback) {
  //     if (position >= items.length - 1 && _controller.hasClients) {
  //       _controller.animateToPage(0, duration: const Duration(seconds: 1), curve: Curves.easeInOut); //_controller.jumpToPage(0);
  //     } else {
  //       _controller.animateToPage(position + 1,
  //           duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  //
  //     }
  //
  //   });
  // }
  PageController _controller;
  bool autoPlay;
  Timer timer;
  int intervalTime;
  // int position = 0;
  // List<ProductModel> product=[];
  final item = Get.put(CheckAllProducts());
  @override
  void initState() {
    super.initState();
    _controller = PageController();
    intervalTime = 3;
    // autoPlayBanner();
    //getAllProduct();
    getAllProductData();
    //getSliderImage();
  }

  bool isLoading = false;
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  Product product;
  void getAllProductData() async {
    try {
      setLoading(true);
      var response = await OnlineDatabase.getOffersProduct(
          subType: widget.productsubtypeId, isPromotional: widget.value);
      print("Response is" + response.statusCode.toString());
      print("Response is" + response.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        if (response.statusCode == 200) {
          product = Product.fromJson(data);
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
      } else if (response.statusCode == 400) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        setLoading(false);
        Fluttertoast.showToast(
            msg: "${data['results'].toString()}",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e, stack) {
      print('exception is' + e.toString() + stack.toString());
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Something went wrong try again letter",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  updateCart() {
    setLoading(true);
    List<Results> products = product.results;
    productCartbtn = List.filled(products.length, false);
    var tempCart = Provider.of<CartModel>(context, listen: false).cartItemName;
    print('Cart length: ' + tempCart.length.toString());
    for (int i = 0; i < products.length; i++) {
      for (int j = 0; j < tempCart.length; j++) {
        print(products[i].pRODCODE);
        if (products[i].pRODCODE == tempCart[j].productName.productCode) {
          print(products[i].pRODUCT);
          productCartbtn[i] = true;
        }
      }
    }
    setState(() {});
    setLoading(false);
  }

  /*getAllProduct(){
    for(var item in productList['products']){
      product.add(ProductModel.fromJson(item));
    }
  }*/
  List<bool> productCartbtn = [];
  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalcount = 0;
    int subtotal = 0;
    final customerData = Provider.of<CustomerModel>(context);
    final cartdata = Provider.of<AddToCartModel>(context);
    /*for(int i=0;i<cartdata.cartItemName.length;i++){
      setState(() {
        totalcount+=cartdata.cartItemName[i].itemCount;
        subtotal+=cartdata.cartData[i].itemCount*cartdata.cartData[i].itemPrice;
      });
    }*/
    // if(sliderData['auto_slide'] == true) {
    //   if (!timer.isActive) {
    //     print('timer active');
    //     Future.delayed(Duration(seconds: sliderData['interval']), () => autoPlayBanner());
    //   }
    // }else{
    //   timer.cancel();
    // }

    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    double ratio = height / width;
    return WillPopScope(
      onWillPop: ()=>Get.to(CheckInScreen()),
      child: Scaffold(
        // backgroundColor: Color(0xffE5E5E5),
        appBar: AppBar(
          leading: IconButton(onPressed:()=>Get.back(),icon: Icon(Icons.arrow_back),),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: height * 0.01),
              // CarouselSlider(
              //   items: imageContainer,
              //   options: CarouselOptions(
              //     autoPlay: true,
              //     enlargeCenterPage: true,
              //     viewportFraction: 0.9,
              //     aspectRatio: 2.0,
              //   ),
              // ),
              // // renderSlider(ratio, width),
              // SizedBox(height: height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    VariableText(
                      text: 'All Items',
                      fontsize: 14,
                      weight: FontWeight.w500,
                    ),
                    Spacer(),
                    if (product != null)
                      product.results.length > 0
                          ? InkWell(
                              onTap: () {
                                // Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (_) => ViewAllProduct(
                                //                 productData: product.results)))
                                //     .then((value) {
                                //   getAllProductData();
                                // });
                              },
                              child: Container(
                                width: width * 0.20,
                                child: VariableText(
                                  textAlign: TextAlign.end,
                                  text: 'View All',
                                  fontsize: 11,
                                  fontcolor: themeColor1,
                                  weight: FontWeight.w500,
                                  fontFamily: fontMedium,
                                ),
                              ),
                            )
                          : Container(),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
              isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Padding(
                        padding: EdgeInsets.all(screenpadding),
                        child: Container(
                            width: width,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 1),
                                  )
                                ],
                                // color: themeColor1,
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: height * 0.20,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          Container(
                                            height: height * 0.05,
                                            width: width,
                                            decoration: BoxDecoration(
                                                color: themeColor1,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                                child: Container(
                                              height: 10,
                                              width: 20,
                                              color: themeColor1,
                                            )),
                                          ),
                                        ],
                                      )),
                                  Expanded(
                                      flex: 14,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 200,
                                              color: themeColor1,
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Container(
                                              height: 30,
                                              width: 200,
                                              color: themeColor1,
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Container(
                                              height: 30,
                                              width: 200,
                                              color: themeColor1,
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Container(
                                              height: 30,
                                              width: 200,
                                              color: themeColor1,
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Container(
                                              height: 30,
                                              width: 200,
                                              color: themeColor1,
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            SizedBox(
                                              height: height * 0.0055,
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            )),
                      ),
                    )
                  : product == null
                      ? Container()
                      : product.results.length > 0
                          ? MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: screenpadding / 2,
                                    right: screenpadding / 2),
                                child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: width * 0.04,
                                      );
                                    },
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: product.results.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return product.results[index].oFFERITEM ==
                                              "Y"
                                          ? ProductTile(
                                              width: width,
                                              product: product.results[index],
                                              additem: true,
                                            )
                                          : Container();
                                    }),
                              ))
                          : Container(
                              height: height * 0.48,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  VariableText(
                                    text: 'Product not found',
                                    fontsize: 18,
                                    fontcolor: Colors.black,
                                    weight: FontWeight.w500,
                                    fontFamily: fontRegular,
                                  ),
                                ],
                              ),
                            ),

              //myProductList(context: context,height: height,product: product,showAllProduct: true),
            ],
          ),
        ),

        // bottomNavigationBar:
        //addToCart?
//       InkWell(
//         onTap: (){
//           item.myProducts.value.clear();
//           item.cartList.clear();
//           item.difference.value=false;
//           for(var i in cartdata.cartItemName) {
//             print(i.productName.productCode);
//             item.myProducts.value.add(i);
//           }
//           item.indexList.clear();
//           addToCart=false;
//           //productCartbtn=List.filled(product.length, false);
//           Navigator.push(context, MaterialPageRoute(builder: (_)=>CartScreen())).then((value){
//             getAllProductData();
//           });
//
//         },
//         child: Container(
//           color: themeColor2,
//           child: Padding(
//             padding:  EdgeInsets.all(screenpadding),
//             child: Container(
//               height: height*0.06,
//               decoration: BoxDecoration(
//                 color: cartdata.cartItemName.length>0? themeColor1:Colors.grey,
//                 borderRadius: BorderRadius.circular(4),
//
//               ),
//
//               child:   Padding(
//                 padding:  EdgeInsets.symmetric(horizontal: screenpadding),
//                 child: Row(
//                   children: [/*
//                     Container(
//                       //height: height*0.04,
//                       decoration: BoxDecoration(
//                           color: themeColor1,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: themeColor2)
//
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(6.0),
//                         child: VariableText(
//                           // text: quantity.toString(),
//                           text:totalcount.toString(),
//                           weight: FontWeight.w500,
//                           fontsize: 13,
//                           fontFamily: fontMedium,
//                           fontcolor: themeColor2,
//                         ),
//                       ),
//                     ),*/
//                     Spacer(),
//                     VariableText(
//                       text: 'Check Cart',
//                       weight: FontWeight.w500,
//                       fontsize: 13,
//                       fontFamily: fontMedium,
//                       fontcolor: themeColor2,
//                     ),
//                     Spacer(),
// /*
//                     VariableText(
//                       text: 'Rs. ${subtotal}',
//                       weight: FontWeight.w700,
//                       fontsize: 13,
//                       fontFamily: fontMedium,
//                       fontcolor: themeColor2,
//                     ),*/
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       )
        //     :
        // Container(
        //   height: height*0.00005,
        //   color: Colors.red,
        // ),
      ),
    );
  }
  // Widget renderSlider(double ratio, double width){
  //   List<Map<String, dynamic>> items = imageUrl.values;
  //   return Column(
  //     children: [
  //     Container(
  //     height: 100 * ratio,
  //     child: Padding(
  //       child: Stack(
  //         children: <Widget>[
  //           PageIndicatorContainer(
  //             child: PageView(
  //               controller: _controller,
  //               onPageChanged: (index) {
  //                 setState(() {
  //                   position = index;
  //                 });
  //               },
  //               children: <Widget>[
  //                 for (int i = 0; i < imageList.length; i++)
  //                   Container(
  //
  //                     child: Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 25),
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.circular(5),
  //                         child: Image.network(
  //                           imageList[i],
  //                           fit: BoxFit.fill,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //               ],
  //             ),
  //             align: IndicatorAlign.bottom,
  //             length: items.length,
  //             indicatorSpace: 5.0,
  //             padding: const EdgeInsets.all(10.0),
  //             indicatorColor: Colors.transparent,
  //             indicatorSelectorColor: Colors.transparent,
  //             shape: IndicatorShape.circle(
  //               size: 5.0,
  //             ),
  //           ),
  //         ],
  //       ),
  //       padding: const EdgeInsets.only(top: 10, bottom: 5),
  //     ),
  //   ),
  //       SizedBox(height:ratio*5,),
  //       Center(
  //         child: SmoothPageIndicator(
  //           controller: _controller,
  //           count: items.length,
  //           effect: WormEffect(
  //             dotHeight: 8,
  //             dotWidth: 8,
  //             activeDotColor: Color(0xffE91F22),
  //             dotColor: Color.fromRGBO(233, 31, 34, 0.3),
  //             type: WormType.thin,
  //             // strokeWidth: 5,
  //           ),
  //         ),
  //       ),
  //
  //     ],
  //   );
  //
  //
  // }

}

class ProductTile extends StatelessWidget {
  ProductTile(
      {Key key,
      @required this.width,
      @required this.product,
      @required this.additem})
      : super(key: key);

  final double width;
  final Results product;
  final bool additem;
  final Shader linearGradient = LinearGradient(
    end: Alignment.topRight,
    begin: Alignment.bottomLeft,
    colors: <Color>[
      themeColor1,
      themeColor1,
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    var cart=Provider.of<AddToCartModel>(context);
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: width * 0.04, horizontal: width * 0.04),
      margin: EdgeInsets.symmetric(horizontal: width * 0.04),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.5))
          // boxShadow: [
          //   BoxShadow(
          //     offset: Offset(-2, 2),
          //     blurRadius: 7,
          //     color: Colors.grey.withOpacity(0.5),
          //   ),
          // ],
          ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                // color:Colors.grey,
                child: InkWell(
                  onTap: () {
                    Image _img = Image.network(product.iMAGEURL);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        barrierColor: Colors.black,
                        pageBuilder: (BuildContext context, _, __) {
                          return FullScreenPage(
                            child: product.iMAGEURL,
                            dark: false,
                          );
                        },
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      product.iMAGEURL,
                      errorBuilder: (context, object, stackTrace) {
                        return Image.asset(Assets.iconsHistory);
                      },
                      width: width * 0.25,
                      fit: BoxFit.fitHeight,
                      height: width * 0.4,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: width * 0.04,
              ),
            ],
          ),
          SizedBox(
            width: width * 0.04,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.pRODCODE,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        product.bRAND,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = linearGradient),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: width * 0.02,
                ),
                Text(
                  product.pRODUCT,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    foreground: Paint()..shader = linearGradient,
                  ),
                ),
                SizedBox(
                  height: width * 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (product.mODEL != null)
                      Text(
                        product.mODEL,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    if (product.dESCRIPTION != null)
                      Text(
                        product.dESCRIPTION,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
                SizedBox(
                  height: width * 0.04,
                ),
                product.oFFERITEM == "Y"
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            for(int i = 0 ;i<product.pRICE.length;i++){
                              for(int j = 0 ;j<cart.cart.length;j++){
                                if(product.pRICE[i].tR.toString() ==cart.cart[j].tr){
                                  product.pRICE[i].count=cart.cart[j].qty;
                                }
                              }
                            }
                            Get.to(SelectItemScreen(results: product,));
                            },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              gradient: LinearGradient(
                                  end: Alignment.topRight,
                                  begin: Alignment.bottomLeft,
                                  colors: <Color>[
                                    themeColor1,
                                    themeColor1,
                                    // const Color(0xFFFFBC09),
                                  ]),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: width * 0.02, horizontal: width * 0.045),
                            child: Text(
                              "SELECT",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                  // width: width * 0.2,
                            height: width * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Total Price",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                Text("RS. ${product.pRICE[0].sELLINGPRICE}",style: TextStyle(color: themeColor1,fontSize: 15),),

                                // Row(r
                                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     Text("Prices",
                                //         style: TextStyle(
                                //             //fontWeight: FontWeight.bold,
                                //             color: Colors.grey,
                                //             fontSize: 13),),
                                //     // ),
                                //     // Text(
                                //     //   "RATE",
                                //     //   style: TextStyle(
                                //     //       fontWeight: FontWeight.bold,
                                //     //       fontSize: 13),
                                //     // ),
                                //     // Text(
                                //     //   "MRP",
                                //     //   style: TextStyle(
                                //     //       fontWeight: FontWeight.bold,
                                //     //       fontSize: 13),
                                //     // ),
                                //     // Text(
                                //     //   "EXPIRE",
                                //     //   style: TextStyle(
                                //     //       fontWeight: FontWeight.bold,
                                //     //       fontSize: 13),
                                //     // ),
                                //   ],
                                // ),
                                // SizedBox(
                                //   height: width * 0.02,
                                // ),
                                // Expanded(
                                //   child: ListView.separated(
                                //       itemBuilder: (context, index) {
                                //         return product.pRICE[index].sTATUS == "N"
                                //             ? Container()
                                //             : Container(
                                //                 child: Row(
                                //                   mainAxisAlignment:
                                //                       MainAxisAlignment.spaceEvenly,
                                //                   children: [
                                //                     Text(
                                //                       product.pRICE[index].qTY
                                //                           .toString(),
                                //                       style: TextStyle(
                                //                           fontSize: width * 0.03),
                                //                     ),
                                //                     Text(
                                //                       product.pRICE[index].rATE
                                //                           .toString(),
                                //                       style: TextStyle(
                                //                           fontSize: width * 0.03),
                                //                     ),
                                //                     Text(
                                //                       product.pRICE[index].mRP,
                                //                       style: TextStyle(
                                //                           fontSize: width * 0.03),
                                //                     ),
                                //                     if (product.pRICE[index]
                                //                             .eNTRYDATE !=
                                //                         null)
                                //                       Text(
                                //                         product
                                //                                     .pRICE[index]
                                //                                     .eNTRYDATE
                                //                                     .length >
                                //                                 10
                                //                             ? product.pRICE[index]
                                //                                 .eNTRYDATE
                                //                                 .substring(0, 10)
                                //                             : product.pRICE[index]
                                //                                 .eNTRYDATE,
                                //                         style: TextStyle(
                                //                             fontSize: width * 0.03),
                                //                       ),
                                //                   ],
                                //                 ),
                                //               );
                                //       },
                                //       separatorBuilder: (context, index) {
                                //         return SizedBox(
                                //           height: width * 0.01,
                                //         );
                                //       },
                                //       itemCount: product.pRICE.length),
                                // )
                              ],
                            ),
                          ),
                      ],
                    )
                    : Container(
                        alignment: Alignment.center,
                        height: width * 0.2,
                        child: Text(
                          "No Offer Found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
