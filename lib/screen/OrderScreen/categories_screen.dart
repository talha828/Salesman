
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/cart/cart_screen.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/product_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/OrderScreen/products_list_screen.dart';
import 'package:salesmen_app_new/screen/searchProductScreen/search_product_screen.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesScreen extends StatefulWidget {


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



  // void getAllProduct() async {
  //   try {
  //     setLoading(true);
  //     var response = await OnlineDataBase.getAllproductsubcategory(
  //         subTypeId: "", maintypeId: "");
  //     print("Response is" + response.statusCode.toString());
  //     //print("Response is" + response .toString());
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //          searchProduct = [];
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


  final item=Get.put(CheckAllProducts());
  var f = NumberFormat("###,###.0#", "en_US");

  @override
  Widget build(BuildContext context) {
     List<Widget>imageContainer=Provider.of<CustomerList>(context).imageContainer;
     List<ProductModel> product=Provider.of<CustomerList>(context).product;
     List<ProductModel> searchProduct=Provider.of<CustomerList>(context).searchProduct;
     final cartdata = Provider.of<CartModel>(context, listen: true);
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:MyAppBar(
          title: 'Categories',
          ontap: ()=>Navigator.pop(context)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.02),
            product.length<1
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SearchProductScreen(
                                            productModel: searchProduct,
                                        onAddToCart: (){}))).then((value){
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
                          itemCount: product.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenpadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VariableText(
                                    text: product[index].productmaintypeName,
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
                                        itemCount: product[index]
                                            .productsubtypeList
                                            .length,
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
                                                  text: product[index]
                                                      .productsubtypeList[i]
                                                      .productsubtypeName,
                                                  height: height,
                                                  width: width,
                                                  ontap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => ProductListScreen(
                                                                productmaintypeId: product[index].productmaintypeId,
                                                                productsubtypeId: product[index].productsubtypeList[i].productsubtypeId))).then((value){
                                                      addToCart = false;
                                                      if (Provider.of<CartModel>(context, listen: false)
                                                          .cartItemName
                                                          .isNotEmpty) {
                                                        addToCart = true;
                                                      }
                                                      setState(() {});
                                                    });
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
            //getAllProductData();
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
                    Spacer(),
                    VariableText(
                      text: 'Check Order Summary',
                      weight: FontWeight.w500,
                      fontsize: 13,
                      fontFamily: fontMedium,
                      fontcolor: themeColor2,
                    ),
                    Spacer(),
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
