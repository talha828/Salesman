import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/cart/checkout.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/product_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/checkinScreen/checkin_screen.dart';


class CartScreen extends StatefulWidget{


  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  int count=0;
  bool isLoading=false;
  final item=  Get.find<CheckAllProducts>();
  void getAllProduct(var item) async {
    try {
      setLoading(true);
      var response = await OnlineDatabase.getAllproductsubcategory(
          subTypeId: "", maintypeId: "");
      print("Response is" + response.statusCode.toString());
      //print("Response is" + response .toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        List<ProductModel> searchProduct = [];
        var datalist = data['results'];
        print("data is " + datalist.toString());
        if (datalist.isNotEmpty) {
          for (var item in datalist) {
            searchProduct.add(ProductModel.fromJson(item));
          }
          for (int i=0;i<searchProduct.length;i++){
            for(int j=0;j<item.myProducts.length;j++){
              print(item.myProducts[j].productName.productCode);
              print(item.myProducts[j].productName.productPrice[0].price);
              if(searchProduct[i].productCode.toString() ==item.myProducts[j].productName.productCode.toString()){
                if(searchProduct[i].productPrice[0].price > item.myProducts[j].productName.productPrice[0].price || searchProduct[i].productPrice[0].price< item.myProducts[j].productName.productPrice[0].price ){
                  item.difference.value =true;
                  //item.searchList.add(searchProduct[i]);
                  var dd=  item.myProducts[j];
                  dd.productName.productPrice[0].price = searchProduct[i].productPrice[0].price;
                  item.cartList.add(dd);
                  print(searchProduct[j].availableQuantity);
                  print(searchProduct[j].productPrice[0].max);
                }
                if(searchProduct[i].availableQuantity < item.myProducts[j].itemCount){
                  item.difference.value =true;
                  //item.searchList.add(searchProduct[i]);
                  var dd =item.myProducts[j] ;
                  searchProduct[i].availableQuantity<1?dd.itemCount =0 :dd.itemCount =searchProduct[i].availableQuantity;
                  item.cartList.add(dd);
                  item.indexList.add(dd.productName.name);
                  print(searchProduct[j].availableQuantity);
                  print(searchProduct[j].productPrice[0].min);
                }
              }
            }
          }
          if(item.difference.value == true){
            Alert(
              context: context,
              type: AlertType.warning,
              title: "Order is Updated",
              desc: "آپ کا آرڈر دیر ہونے کی وجہ سے قیمت اور تعداد میں اپڈیٹ ہوا ہے۔",
              style: AlertStyle(
                  descStyle:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
              buttons: [
                DialogButton(
                  color: Colors.red,
                  child: Text(
                    "ok",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  width: 120,
                )
              ],
            ).show();
          }
          setLoading(false);
        } else {
          setLoading(false);
          Fluttertoast.showToast(
              msg: "Product not found",
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
      } else if (response.statusCode == 401) {
        setLoading(false);
        Fluttertoast.showToast(
            msg: "User not found",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e, stack) {
      print('exception is' + e.toString() + stack.toString());
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Something went wrong try again later",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    getAllProduct(item);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("###,###.0#", "en_US");
    CustomerModel customer=Provider.of<CustomerList>(context).singleCustomer;
    var cartData=Provider.of<CartModel>(context,listen: true).cartItemName;
    var media =MediaQuery.of(context).size;
    double height=media.height;
    double width=media.width;
    double ratio=height/width;

    return Stack(
      children: [
        Scaffold(
          appBar:MyAppBar(
              title: 'Cart',
              ontap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckInScreen(shopDetails: customer,)));
              }),
          body:
          cartData.length > 0 ?
          SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: screenpadding),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            VariableText(
                              text:customer.customerShopName,
                              fontsize: 13,
                              fontcolor: textcolorblack,
                              weight: FontWeight.w600,
                              line_spacing: 1.2,
                              textAlign: TextAlign.center,
                              fontFamily: fontRegular,
                            ),
                            SizedBox(
                              width: height * 0.008,
                            ),
                            VariableText(
                              text: customer.customerCode,
                              fontsize: 13,
                              fontcolor: textcolorblack,
                              weight: FontWeight.w400,
                              textAlign: TextAlign.start,
                              line_spacing: 1.2,
                              max_lines: 2,
                              fontFamily: fontRegular,
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(height: height*0.02,),
                  Container(
                    //  height: height*0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                       boxShadow: [
                         BoxShadow(
                           color: Color.fromRGBO(31, 31, 31, 0.15),
                           blurRadius: 0.5
                         )
                       ]
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                      child:Column(
                        children: [
                          SizedBox(height: height*0.02,),
                          Row(
                            children: [
                              VariableText(
                                text: 'My Cart',
                                fontsize: 14,
                                fontcolor: textcolorblack,
                                weight: FontWeight.w500,
                                fontFamily: fontMedium,
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                               Provider.of<CartModel>(context,listen: false).clearCart();
                                },
                                child: Container(
                                 width: width * 0.20,
                                  child: VariableText(
                                    textAlign: TextAlign.end,
                                    text: 'Delete All',
                                    fontsize: 11,
                                    fontcolor: themeColor1,
                                    weight: FontWeight.w500,
                                    fontFamily: fontMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height*0.02,),
                          ListView.separated(
                            separatorBuilder:(context,int index) {
                             return Divider(color: Colors.black,height: 1,);
                            },
                            shrinkWrap: true,
                              itemCount: cartData.length,
                              physics: ScrollPhysics(),
                              itemBuilder:(BuildContext context,int index){
                              TextEditingController itemCountController=new TextEditingController();
                              itemCountController.text=cartData[index].itemCount.toString();
                              return Slidable(
                                  key: const ValueKey(1),
                                endActionPane: ActionPane(
                                  extentRatio: 0.30,
                                motion: const ScrollMotion(),/*
                                  dismissible: DismissiblePane(onDismissed: () {
                                    cartData.removeAt(index);
                                    Provider.of<CartModel>(context,listen: false).upDateCart();
                                  }),*/

                                  children:  [
                                    SlidableAction(
                                      onPressed:(context) {
                                        cartData.removeAt(index);
                                        Provider.of<CartModel>(context,listen: false).updateCart();
                                      },
                                      backgroundColor:themeColor1,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),

                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  height: height*0.10,
                                  width: width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: item.indexList.contains(cartData[index].productName.name)?Colors.amberAccent.withOpacity(0.3):Colors.white ?? Colors.white
                                   // color: Colors.pink
                                  ),
                                  child:Row(
                                    children: [
                                      Expanded(
                                        flex:4,
                                        child: Container(
                                            height: height*0.09,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(5),
                                              child: LayoutBuilder(
                                                builder: (_, constraints){
                                                  return
                                                    cartData[index].productName.imageUrl != null ?
                                                   Image.network(cartData[index].productName.imageUrl
                                                    /* cartData[index].productName.imageUrl,
                                                     fit: BoxFit.scaleDown,
                                                     loadingBuilder: (BuildContext context,
                                                         Widget child,
                                                         ImageChunkEvent loadingProgress) {
                                                       if (loadingProgress == null) return child;
                                                       return Shimmer.fromColors(
                                                         baseColor: Colors.grey[300],
                                                         highlightColor: Colors.grey[100],
                                                         child: Container(
                                                           decoration: BoxDecoration(
                                                             color: Colors.black54,
                                                             borderRadius: BorderRadius.circular(5),
                                                           ),
                                                         ),
                                                       );
                                                     },*/
                                                   ) : Image.asset("assets/images/placeHolder.png");
                                                }
                                              ),
                                            )
                                        ),
                                      ),
                                      Expanded(
                                        flex: 9,
                                        child: Padding(
                                          padding:  EdgeInsets.only(left: height*0.01,),
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(height: height*0.01/2.2,),
                                                VariableText(
                                                  text: cartData[index].productName.name,
                                                  fontsize:12,
                                                  textAlign: TextAlign.start,
                                                  fontcolor:Colors.black,
                                                  weight: FontWeight.w500,
                                                  max_lines: 2,
                                                  fontFamily: fontMedium,
                                                ),
                                                SizedBox(height: height*0.006,),
                                                VariableText(
                                                  text: cartData[index].productName.brand??'-',
                                                  fontsize:9,
                                                  fontcolor:Color(0xff828282),
                                                  weight: FontWeight.w400,
                                                  fontFamily: fontRegular,
                                                ),
                                                SizedBox(height: 3),
                                                VariableText(
                                                  text: cartData[index].productName.model??'-',
                                                  fontsize:9,
                                                  fontcolor:Color(0xff828282),
                                                  weight: FontWeight.w400,
                                                  fontFamily: fontRegular,
                                                ),
                                                SizedBox(height: height*0.0050,),
                                            VariableText(
                                              text: 'Rs. ${f.format(double.parse((cartData[index].itemCount*calculatePrice(quantity: cartData[index].itemCount,productDetils: cartData[index].productName)).toString()))
                                              }',
                                              //text: '${f.format(double.parse((cartData[index].itemCount*calculatePrice(quantity: cartData[index].itemCount,productDetils: cartData[index].productName)).toString())) }',

                                            fontsize:12,
                                              fontcolor:themeColor1,
                                              weight: FontWeight.w600,
                                              fontFamily: fontRegular,
                                            ),
                                                SizedBox(height: height*0.0065,),
                                                /*Row(
                                                  children: [
                                                    VariableText(
                                                      linethrough: true,
                                                      text:'Rs. 5,250.00',
                                                      fontsize:12,
                                                      fontcolor:Color(0xff828282),
                                                      weight: FontWeight.w500,
                                                      fontFamily: fontRegular,

                                                    ),
                                                    SizedBox(width: 8,),
                                                    VariableText(
                                                      text:'-45%',
                                                      fontsize:12,
                                                      fontcolor:Color(0xff585757),
                                                      weight: FontWeight.w500,
                                                      fontFamily: fontRegular,

                                                    ),
                                                  ],
                                                ),*/
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 7,
                                        child: Padding(
                                          padding:  EdgeInsets.only(left: 0.0),
                                          child: Row(
                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap:(){
                                                  //
                                                  if( cartData[index].itemCount>1){
                                                    setState(() {
                                                      cartData[index].itemCount--;
                                                      itemCountController.text=cartData[index].itemCount.toString();
                                                      Provider.of<CartModel>(context, listen: false).updateSubTotal();
                                                      //cartData[index].itemPrice = calculatePrice(quantity: cartData[index].itemCount,productDetils: cartData[index].productName)??0;
                                                     //cartData[index].itemTotal = cartData[index].itemPrice*cartData[index].itemCount;
                                                    });
                                                  }

                                                },
                                                child: Container(
                                                  height: ratio*12,
                                                  width: ratio*12 ,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffF1F1F1),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Align(
                                                      alignment: Alignment.center,
                                                      child:Icon(Icons.remove,color: Color(0xff828282),size: 18,)
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: ratio*20,
                                                      //width: ratio*22 ,
                                                      child: Center(
                                                        child: TextField(
                                                          maxLines: 1,
                                                          textAlignVertical: TextAlignVertical.center,
                                                            controller:itemCountController,
                                                          textAlign: TextAlign.center,
                                                          keyboardType: TextInputType.number,
                                                          onChanged: (value){
                                                            print("ajjjjjjjj");
                                                              cartData[index].itemCount=int.parse(value);
                                                            Provider.of<CartModel>(context, listen: false).updateSubTotal();
                                                              //cartData[index].itemPrice= calculatePrice(quantity: cartData[index].itemCount,productDetils: cartData[index].itemDetails)??0;
                                                              //cartData[index].itemTotal=cartData[index].itemPrice*cartData[index].itemCount??1;

                                                          },
                                                          decoration: InputDecoration(
                                                            //isCollapsed: true,
                                                           // hintText:cartData[index].itemCount.toString(),
                                                            hintStyle: TextStyle(
                                                              fontSize:14,
                                                              fontWeight: FontWeight.w500,
                                                              color: Color(0xff333333),
                                                            ),

                                                            border: InputBorder.none,
                                                            focusedBorder: InputBorder.none,
                                                            enabledBorder: InputBorder.none,
                                                            errorBorder: InputBorder.none,
                                                            disabledBorder: InputBorder.none,
                                                          ),



                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap:(){
                                                  if( cartData[index].itemCount>=0){
                                                   if(cartData[index].itemCount < cartData[index].productName.availableQuantity) {
                                                                setState(() {
                                                                  cartData[
                                                                          index]
                                                                      .itemCount++;
                                                                  itemCountController
                                                                      .text = cartData[
                                                                          index]
                                                                      .itemCount
                                                                      .toString();
                                                                  Provider.of<CartModel>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .updateSubTotal();
                                                                  //cartData[index].itemPrice= calculatePrice(quantity: cartData[index].itemCount,productDetils: cartData[index].itemDetails)??0;
                                                                  //cartData[index].itemTotal= cartData[index].itemPrice*cartData[index].itemCount;
                                                                });
                                                              }else{
                                                     Fluttertoast.showToast(msg: "you reach the stock limit");
                                                   }
                                                            }

                                                },
                                                child:  Container(
                                                  height: ratio*12,
                                                  width: ratio*12 ,
                                                  decoration: BoxDecoration(
                                                      color: themeColor1,
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Align(
                                                      alignment: Alignment.center,
                                                      child:Icon(Icons.add,color: themeColor2,size: 18,)
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                              );
                              }),
                          SizedBox(height: height*0.02,),

                        ],
                      )
                    ),

                  ),
                  SizedBox(height: height*0.02,),
               /*   Container(
                    //  height: height*0.07,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Color(0xffF6821F).withOpacity(0.6)),
                        color: Color(0xffFFEEE0)
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: screenpadding/2),
                      child: Column(
                        children: [
                          SizedBox(height: height*0.015,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Image.asset('assets/icons/ic_ledger.png.png',scale: 3.5,color: themeColor1,),
                              SizedBox(width: height*0.0055,),
                              VariableText(
                                text:  'Order Summary',
                                fontsize:14,fontcolor: textcolorblack,
                                weight: FontWeight.w700,
                                textAlign: TextAlign.start,
                                fontFamily: fontRegular,
                              ),
                            ],
                          ),
                          SizedBox(height: height*0.01,),
                          ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:5,
                              itemBuilder: (BuildContext context,int i){
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex:2,
                                          child: VariableText(
                                            text: "1x"??0,
                                            fontsize:13,fontcolor: textcolorblack,
                                            weight: FontWeight.w600,
                                            line_spacing:1.2 ,
                                            textAlign: TextAlign.center,
                                            fontFamily: fontRegular,
                                          ),
                                        ),
                                        SizedBox(width: height*0.008,),
                                        Expanded(
                                          flex:12,
                                          child: VariableText(
                                            text:'Motorcycle Spark Plug',
                                            fontsize:13,fontcolor: textcolorblack,
                                            weight: FontWeight.w400,
                                            textAlign: TextAlign.start,
                                            line_spacing:1.2 ,
                                            max_lines: 2,
                                            fontFamily: fontRegular,
                                          ),
                                        ),
                                        Expanded(
                                          flex:4,
                                          child: Container(
                                            child: VariableText(
                                              text:'Rs. 1,530.00',
                                              fontsize:13,fontcolor: textcolorblack,
                                              weight: FontWeight.w400,
                                              line_spacing:1.2 ,
                                              textAlign: TextAlign.end,
                                              fontFamily: fontRegular,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height*0.0025,),
                                  ],
                                );
                              }),
                          SizedBox(height: height*0.01,
                          ),
                          Container(height: 1,
                            color: themeColor1,),
                          SizedBox(height: height*0.01,
                          ),

                          Row(
                            children: [
                              VariableText(
                                text:  'Sub Total',
                                fontsize:14,fontcolor: textcolorgrey,
                                weight: FontWeight.w400,
                                fontFamily: fontRegular,
                              ),
                              Spacer(),
                              VariableText(
                                text:
                                'Rs. 3,995.00',
                                fontsize:14,fontcolor: textcolorgrey,
                                weight: FontWeight.w400,
                                fontFamily: fontRegular,
                              ),
                            ],
                          ),
                           SizedBox(height: height*0.0055,),
                      Row(
                        children: [
                          VariableText(
                            text:  'Delivery Fee',
                            fontsize:14,fontcolor: textcolorgrey,
                            weight: FontWeight.w400,
                            fontFamily: fontRegular,
                          ),
                          Spacer(),
                          VariableText(
                            text:  'Rs. 50',
                            fontsize:14,fontcolor: textcolorgrey,
                            weight: FontWeight.w400,
                            fontFamily: fontRegular,
                          ),
                        ],
                      ),
                          SizedBox(height: height*0.015,),


                        ],
                      ),
                    ),

                  ),*/

                ],
              ),
            ),

          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: VariableText(
                  text: 'Cart is empty',
                  weight: FontWeight.w500,
                  fontsize: 16,
                  fontFamily: fontMedium,
                  fontcolor: Colors.black87,
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: InkWell(
              onTap:(){
                cartData.length > 0 ?
                Navigator.push(context, MaterialPageRoute(builder: (_)=>CheckOutScreen(
                ))).then((value) =>setState(() {})) :
                Fluttertoast.showToast(msg: "Cart is empty",toastLength: Toast.LENGTH_SHORT);
                item.myProducts.value.clear();
                item.cartList.clear();
                item.difference.value=false;
                for(var i in cartData) {
                  print(i.productName.productCode);
                  item.myProducts.value.add(i);
                }
                item.indexList.clear();
              },
              child: Container(
                color: themeColor2,
                child: Padding(
                  padding:  EdgeInsets.all(screenpadding),
                  child: Container(
                    height: height*0.06,
                    decoration: BoxDecoration(
                      color: cartData.length>0?themeColor1:Color(0xffBDBDBD),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child:   Center(
                      child: VariableText(
                        text: 'Continue',
                        weight: FontWeight.w500,
                        fontsize: 16,
                        fontFamily: fontMedium,
                        fontcolor: themeColor2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        isLoading?Positioned.fill(child: ProcessLoading()):Container()
      ],
    );
  }
  double calculatePrice({int quantity,ProductModel productDetils}){
    double dynamicprice = double.parse(productDetils.productPrice.last.price.toStringAsFixed(2));
    for(var item in productDetils.productPrice){
      if(item.min<=quantity && item.max>=quantity){
        dynamicprice=double.parse(item.price.toStringAsFixed(2));
      }
    }
    return dynamicprice;

  }
}
/*void doNothing(BuildContext context,List<CartModel> cartData,int index) {
  cartData.removeAt(index);
  Provider.of<CartModel>(context,listen: false).upDateCart();
}*/
