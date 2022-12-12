import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/cart/cart_screen.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/product_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/searchProductScreen/search_product_screen.dart';
import 'package:shimmer/shimmer.dart';


class ProductListScreen extends StatefulWidget {
  String productmaintypeId, productsubtypeId;
  ProductListScreen(
      {
        this.productmaintypeId,
        this.productsubtypeId});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  Map<String, dynamic> productList = {
    "products": [
      {
        'id': '1',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product1.png",
        "description":
        'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "3.5"
      },
      {
        'id': '2',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product1.png",
        "description":
        'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "1"
      },
      {
        'id': '3',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product1.png",
        "description":
        'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "5"
      },
      {
        'id': '4',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product1.png",
        "description":
        'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "3"
      },
      {
        'id': '5',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product1.png",
        "description":
        'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "5"
      },
      {
        'id': '6',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product1.png",
        "description":
        'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "2.5"
      },
      {
        'id': '6',
        "name": "Bike shock absorber",
        "price": "3495.00",
        "image": "assets/images/product1.png",
        "description":
        'A shock absorber or damper is a mechanical or hydraulic device designed to absorb and damp shock impulses. It does this by converting the kinetic energy of the shock into another form of energy (typically heat) which is then dissipated. Most shock absorbers are a form of dashpot (a damper which resists motion via viscous friction).',
        "rating": "5"
      },
    ]
  };
  List<bool> productCartbtn = [];
  bool addToCart = false;
  bool autoPlay;
  Timer timer;
  int intervalTime;
  int position = 0;
  List<ProductModel> product = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getAllProduct();
    getAllProductData();
    if (Provider.of<CartModel>(context, listen: false)
        .cartItemName
        .isNotEmpty) {
      addToCart = true;
    }
  }

  bool isLoading = false;
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  void getAllProductData() async {
    try {
      setLoading(true);
      var response = await OnlineDatabase.getAllproductsubcategory(
          maintypeId: widget.productmaintypeId.toString(),
          subTypeId: widget.productsubtypeId.toString());
      print("Response is" + response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        product = [];
        var datalist = data['results'];
        if (datalist != null) {
          for (var item in datalist) {
            product.add(ProductModel.fromJson(item));
          }
          productCartbtn = List.filled(product.length, false);
          var tempCart = Provider.of<CartModel>(context, listen: false).cartItemName;
          print('Cart length: ' + tempCart.length.toString());
          for (int i = 0; i < product.length; i++) {
            for (int j = 0; j < tempCart.length; j++) {
              if (product[i].productCode == tempCart[j].productName.productCode) {
                //print(product[i].name);
                productCartbtn[i] = true;
              }
            }
          }
          setState(() {});
          // print("All product --> $product");

          setLoading(false);
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

  // getAllProduct() {
  //   for (var item in productList['products']) {
  //     product.add(ProductModel.fromJson(item));
  //   }
  // }
  final item=Get.put(CheckAllProducts());
  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("###,###.0#", "en_US");

    final cartdata = Provider.of<CartModel>(context, listen: true);

    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    double ratio = height / width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
          title: 'Products',
          ontap: () {
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: height * 0.02),
            isLoading
                ? ListView.builder(
              shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context,index){
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Padding(
                      padding: EdgeInsets.all(15),
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
                  );
            })
                : product.length > 0
                ? MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenpadding / 2,
                      right: screenpadding / 2),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.010,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8),
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            SearchProductScreen(
                                              productModel: product,
                                              onAddToCart: (){
                                                setState(() {
                                                  addToCart = true;
                                                });
                                              },
                                            )
                                    )).then((value){
                                  getAllProductData();
                                  addToCart = false;
                                  if (Provider.of<CartModel>(context, listen: false)
                                      .cartItemName
                                      .isNotEmpty) {
                                    addToCart = true;
                                  }
                                  setState(() {});
                                });
                              },
                              child: RectangluartextFeild(
                                bordercolor: Color(0xffEBEAEA),
                                hinttext: "Search by product name",
                                containerColor: Color(0xFFFFFF),
                                enableborder: true,
                                // cont: _controller,
                                enable: false,
                                keytype: TextInputType.text,
                                textlength: 25,
                                //onChanged: searchOperation,
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
                      GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,

                            childAspectRatio: 1.4,
                            //   height: height*0.38 ,
                          ),
                          itemCount:product.length,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:

                              SingleProductTile(
                                productDetails: product[index],
                                ontap: () {
                                  if (productCartbtn[index] == false) {
                                    if(product[index].availableQuantity>0){
                                              setState(() {
                                                productCartbtn[index] = true;
                                                addToCart = true;
                                                Provider.of<CartModel>(
                                                        context,
                                                        listen: false)
                                                    .addToCart(
                                                        item: CartItem(
                                                            productName:
                                                                product[index],
                                                            itemCount: 1,
                                                            itemPrice:
                                                                product[index]
                                                                    .price,
                                                            subTotalPrice:
                                                                product[index]
                                                                    .price,
                                                            priceModel: product[
                                                                    index]
                                                                .productPrice,
                                                            itemcountController:
                                                                TextEditingController(
                                                                    text: '1')),
                                                        itemC: 1);
                                                print("Item added!!!!!!!!!!");
                                              });
                                            }else{
                                      Fluttertoast.showToast(msg: "Stock is not available");
                                    }
                                          }
                                },
                                onquantityUpdate: (count) {
                                  Provider.of<CartModel>(context,
                                      listen: false)
                                      .addToCart(
                                      item: CartItem(
                                          productName:
                                          product[index],
                                          itemCount: count,
                                          itemPrice:
                                          product[index].price,
                                          subTotalPrice:
                                          product[index].price,
                                          priceModel: product[index]
                                              .productPrice,
                                          itemcountController:
                                          TextEditingController(
                                              text: '1')),
                                      itemC: count);
                                  print(
                                      "count is: " + count.toString());
                                },
                                addedToCart: productCartbtn[index],
                                onRemove: (){
                                  for(int i=0 ; i< cartdata.cartItemName.length; i++){
                                    if(cartdata.cartItemName[i].productName.productCode == product[index].productCode){
                                      cartdata.cartItemName.removeAt(i);
                                      Provider.of<CartModel>(context,listen: false).updateCart();
                                      setState(() {
                                        productCartbtn[index] = false;
                                        if(cartdata.cartItemName.isEmpty)
                                          addToCart = false;
                                      });
                                      break;
                                    }
                                  }

                                },
                              ),
                            );
                          }),
                    ],
                  ),
                ))
                : Container(
              height: height * 0.80,
              //color: Colors.red,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      VariableText(
                        text: 'Products not found',
                        fontsize: 18,
                        fontcolor: Colors.black,
                        weight: FontWeight.w500,
                        fontFamily: fontRegular,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //myProductList(context: context,height: height,product: product,showAllProduct: true),
          ],
        ),
      ),
      bottomNavigationBar: addToCart
          ? InkWell(
        onTap: () {
          item.myProducts.value.clear();
          item.cartList.clear();
          item.difference.value=false;
          for(var i in cartdata.cartItemName) {
            print(i.productName.productCode);
            item.myProducts.value.add(i);
          }
          item.indexList.clear();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CartScreen(
                  ))).then((value) {
            getAllProductData();
            addToCart = false;
            if (Provider.of<CartModel>(context, listen: false)
                .cartItemName
                .isNotEmpty) {
              addToCart = true;
            }
          });
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
                    // Container(
                    //   //height: height*0.04,
                    //   decoration: BoxDecoration(
                    //       color: themeColor1,
                    //       shape: BoxShape.circle,
                    //       border: Border.all(color: themeColor2)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(6.0),
                    //     child: VariableText(
                    //       // text: quantity.toString(),
                    //       text: cartdata.cartItemName.length
                    //           .toString(), // totalcount.toString(),
                    //       weight: FontWeight.w500,
                    //       fontsize: 13,
                    //       fontFamily: fontMedium,
                    //       fontcolor: themeColor2,
                    //     ),
                    //   ),
                    // ),
                    Spacer(),
                    VariableText(
                      text: 'Check Order Summary',
                      weight: FontWeight.w500,
                      fontsize: 13,
                      fontFamily: fontMedium,
                      fontcolor: themeColor2,
                    ),
                    Spacer(),
                    // VariableText(
                    //   text: 'Rs. ' +  f.format(double.parse(cartdata.subTotal.toStringAsFixed(2))),
                    //  //${subtotal}',
                    //   weight: FontWeight.w700,
                    //   fontsize: 13,
                    //   fontFamily: fontMedium,
                    //   fontcolor: themeColor2,
                    // ),
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
}
