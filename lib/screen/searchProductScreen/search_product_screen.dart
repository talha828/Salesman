import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/cart/cart_screen.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/product_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';


class SearchProductScreen extends StatefulWidget {


  List<ProductModel> productModel;
  Function onAddToCart;
  SearchProductScreen({this.productModel, this.onAddToCart,});
  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  int listLength = 0;
  bool _isSearching;
  bool isLoading = false;

  List<bool> productCartbtn = [];
  bool addToCart = false;

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    getAllProductData();
    listLength = 3;
    if (Provider.of<CartModel>(context, listen: false)
        .cartItemName
        .isNotEmpty) {
      addToCart = true;
    }
  }

  int i = 0;
  List<ProductModel> _list = [];
  List<ProductModel> productsearchresult = [];
  final item=Get.put(CheckAllProducts());
  Future getAllProductData() async {
    for (var item in widget.productModel) {
        _list.add(ProductModel(
          name: item.name,
          brand: item.brand,
          brandId: item.brandId,
          model: item.model,
          productPrice: item.productPrice,
          productCode: item.productCode,
          price: item.price,
          stockQuantity: item.stockQuantity,
          availableQuantity: item.availableQuantity,
          productDescription: item.productDescription,
          imageUrl: item.imageUrl,
          outOfStock: item.outOfStock
        ));
    }

    productCartbtn = List.filled(_list.length, false);

    var tempCart = Provider.of<CartModel>(context, listen: false).cartItemName;
    print('Cart length: ' + tempCart.length.toString());
    for (int i = 0; i < _list.length; i++) {
      for (int j = 0; j < tempCart.length; j++) {
        if (_list[i].productCode == tempCart[j].productName.productCode) {
          print(_list[i].name);
          productCartbtn[i] = true;
        }
      }
    }
    setState(() {});

    print("productModel list " + _list.length.toString());
  }

  final TextEditingController _controller = new TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final cartdata = Provider.of<CartModel>(context, listen: true);
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return Scaffold(
      backgroundColor: themeColor2,
      appBar: MyAppBar(
        title: 'Search',
        ontap: () {
          Navigator.pop(context);
        },
        color: themeColor1,
        color2: themeColor2,
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.025,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenpadding),
            child: Stack(
              children: [
                RectangluartextFeild(
                  bordercolor: Color(0xffEBEAEA),
                  hinttext: "Search by Product",
                  containerColor: Color(0xFFFFFF),
                  enableborder: true,
                  cont: _controller,
                  keytype: TextInputType.text,
                  textlength: 25,
                  onChanged: searchOperation,
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
            height: height * 0.03,
          ),
          productsearchresult.length != 0 || _controller.text.isNotEmpty
              ? Expanded(
                  child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (_scrollController.position.pixels ==
                            _scrollController.position.maxScrollExtent) {
                          //  double temp=0.01;
                          setState(() {
                            if (listLength + 1 < productsearchresult.length) {
                              listLength += 1;
                            } else {
                              int temp =
                                  productsearchresult.length - listLength;
                              listLength = listLength + temp;
                            }
                          });
                          //print('temp value is'+listLength.toString());
                        }
                        if (_scrollController.position.pixels ==
                            _scrollController.position.minScrollExtent) {
                          //  print('start scroll');
                        }
                        return false;
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        itemCount: productsearchresult.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: screenpadding),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleProductTile(
                                    productDetails: productsearchresult[index],
                                    ontap: () {
                                      if (productCartbtn[index] == false) {
                                        if(productsearchresult[index].availableQuantity>0){
                                          setState(() {
                                            productCartbtn[index] = true;
                                            addToCart = true;
                                            widget.onAddToCart();
                                            Provider.of<CartModel>(context,
                                                    listen: false)
                                                .addToCart(
                                                    item: CartItem(
                                                        productName:
                                                            productsearchresult[
                                                                index],
                                                        itemCount: 1,
                                                        itemPrice:
                                                            productsearchresult[
                                                                    index]
                                                                .price,
                                                        subTotalPrice:
                                                            productsearchresult[
                                                                    index]
                                                                .price,
                                                        priceModel:
                                                            productsearchresult[
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
                                      }else{
                                        print("Already in cart");
                                      }
                                    },
                                    onquantityUpdate: (count) {
                                      Provider.of<CartModel>(
                                              context,
                                              listen: false)
                                          .addToCart(
                                              item: CartItem(
                                                  productName:
                                                      productsearchresult[
                                                          index],
                                                  itemCount: count,
                                                  itemPrice:
                                                      productsearchresult[
                                                              index]
                                                          .price,
                                                  subTotalPrice:
                                                      productsearchresult[
                                                              index]
                                                          .price,
                                                  priceModel:
                                                      productsearchresult[index]
                                                          .productPrice,
                                                  itemcountController:
                                                      TextEditingController(
                                                          text: '1')),
                                              itemC: count);
                                      print("count is: " + count.toString());
                                    },
                                    addedToCart: productCartbtn[index],
                                    onRemove: (){
                                      for(int i=0 ; i< cartdata.cartItemName.length; i++){
                                        if(cartdata.cartItemName[i].productName.productCode == productsearchresult[index].productCode){
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
                                ),
                                SizedBox(
                                  height: height * 0.025,
                                ),
                              ],
                            ),
                          );
                        },
                      )),
                )
              : Container(),
        ],
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
                          text: cartdata.cartItemName.length
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
                      text: 'Rs. ' +
                          cartdata.subTotal
                              .toStringAsFixed(2), //${subtotal}',
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

  void searchOperation(String searchText) {
    if (_isSearching != null) {
      productsearchresult.clear();
      //productCartbtn.clear();
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i].name;
        String data1 = _list[i].productCode;
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          print("search by name");
          productsearchresult.addAll([_list[i]]);
        }else if(data1.toLowerCase().contains(searchText.toLowerCase())) {
          print("search by code");
          productsearchresult.addAll([_list[i]]);
          setState(() {});
        }
      }
      productCartbtn = List.filled(productsearchresult.length, false);
      var tempCart = Provider.of<CartModel>(context, listen: false).cartItemName;
      print('Cart length: ' + tempCart.length.toString());
      for (int i = 0; i < productsearchresult.length; i++) {
        for (int j = 0; j < tempCart.length; j++) {
          if (productsearchresult[i].productCode == tempCart[j].productName.productCode) {
            print(productsearchresult[i].name);
            productCartbtn[i] = true;
          }
        }
      }
      setState(() {});
      print("result is" + productsearchresult.length.toString());
    }
  }
}
