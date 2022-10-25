
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
import 'package:salesmen_app_new/model/product_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/widget/loding_indicator.dart';

class OrderDetailsScreen extends StatefulWidget {
  get product => null;

  // List<CartItem> cartData=[];
  // CustomerModel shopDetails;
  // double lat,long;
  // List<ProductModel> product=[];
  // //var shopDetails;
  // OrderDetailsScreen({this.cartData,this.shopDetails,this.lat,this.long,this.product});
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isLoading=false;
  bool isLoading2=false;
  List<int> cartEmptyIndex=[];

  // List<CartModel> cartData=[];

  List<ProductModel> sel_product= [];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   if(widget.cartData[0].productName.name != null){
  //     for(int i=0;i<widget.cartData.length;i++){
  //       sel_product.add(widget.cartData[i].productName);
  //     }
  //   }
  //
  //
  // }


  Map<String,dynamic> orderDetails={
    "order":[
      {
        "itemname":"Motorcycle Spark Plug",
        "itemPrice":"Rs. 110.00",
        "itemquantity":2,
        "itemTotal":"Rs.550.00"
      },
      {
        "itemname":"Motorcycle Engine Oil",
        "itemPrice":"Rs. 520.00",
        "itemquantity":15,
        "itemTotal":"Rs.1,530.00"
      },
      {
        "itemname":"Motorcycle Brake Shoe",
        "itemPrice":"Rs. 125.00",
        "itemquantity":13,
        "itemTotal":"Rs.1,875.00"
      },
      {
        "itemname":"Motorcycle Spark Plug",
        "itemPrice":"Rs. 110.00",
        "itemquantity":2,
        "itemTotal":"Rs.550.00"
      },
    ]
  };

  bool checkOrderSummary=false;
  double sizedboxvalue=0.02;
  int count=0;

  CartModel get cartData =>  cartData;

  changeScreen(){
    setState(() {
      checkOrderSummary=false;
    });
  }
  popScreen(){
    Navigator.pop(context);


  }

  @override
  Widget build(BuildContext context) {
    //CartModel cartData=CartModel(cartItemName:null);
   // var cartData=Provider.of<CartModel>(context,listen: true);
   // double subtotal=0;
   // double quantity=0;
   // for(int i=0;i<cartData.cartItemName.length;i++){
   //   quantity+=cartData.cartItemName[i].itemCount;
   //   try{
   //     //subtotal+=(cartData.cartItemName[i].itemCount)*(cartData.cartItemName[i].productName.price.toInt());
   //     subtotal+=(cartData.cartItemName[i].itemCount)*(cartData.cartItemName[i].itemPrice);
   //   }
   //   catch(e){print("exception is +"+e.toString());
   //   }
   //  }
    var media=MediaQuery.of(context).size;
    double height=media.height;
    double width=media.width;
    return WillPopScope(
      onWillPop: () {
       return checkOrderSummary?
        changeScreen() :
            popScreen();
      },
      //Provider.of<CartModel>(context,listen: false).updateCart();
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(title: Text("Cart"),),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //api integrated
                    customShopDetailsContainer(shopname:
                    "Hadi autos",address:
                    "karachi",
                    height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,imageurl: "sjhdksja"),

                  /*  Container(

                      decoration: BoxDecoration(
                          boxShadow:[ BoxShadow(
                            color:Color(0xffE0E0E099).withOpacity(0.6),)],
                          color: themeColor2
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex:2,
                              child: Container(
                                  height: height*0.08,
                                  decoration: BoxDecoration(


                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),

                                  ),
                                  child:ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: LayoutBuilder(
                                      builder: (_, constraints) => Image(
                                        fit: BoxFit.fill,
                                        width: constraints.maxWidth,
                                        image: AssetImage('assets/images/shop1.jpg'),
                                      ),
                                    ),
                                  )


                              ),
                            ),
                            Expanded(
                              flex:9,
                              child: Container(
                                //width: width*0.70,
                                child: Padding(
                                  padding:  EdgeInsets.only(left:16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      // SizedBox(height: height*0.0055,),
                                      Row(
                                        children: [
                                          VariableText(
                                            text: widget.shopDetails.customerShopName.toString(),
                                            fontsize:15,fontcolor: textcolorblack,
                                            weight: FontWeight.w700,
                                            fontFamily: fontRegular,
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding:  EdgeInsets.only(right:10.0,bottom: 2),
                                            child: Image.asset('assets/icons/arrowup.png',scale: 3,),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: height*0.005,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [

                                          Expanded(
                                            child: Padding(
                                              padding:  EdgeInsets.only(top:0.0),
                                              child: VariableText(
                                                text: widget.shopDetails.customerAddress.toString(),
                                                fontsize:11,fontcolor: textcolorgrey,
                                                line_spacing: 1.1,
                                                textAlign: TextAlign.start,
                                                max_lines: 5,
                                                weight: FontWeight.w500,
                                                fontFamily: fontRegular,
                                              ),
                                            ),
                                          ),




                                        ],
                                      ),
                                      SizedBox(
                                        height: height*0.008,
                                      ),



                                    ],
                                  ),
                                ),
                              ),
                            ),



                          ],
                        ),
                      ),
                    ),*/
                    SizedBox(height:height*sizedboxvalue,),
                    checkOrderSummary?orderSummaryBlock(cartData,height,width):orderDetailsBlock(cartData,height,width),
                  ]

              ),
            ),
           floatingActionButton:checkOrderSummary?Container():FloatingActionButton(
              onPressed: (){
                // if(cartData.cartItemName[cartData.cartItemName.length-1].itemCount == 0){
                //   Fluttertoast.showToast(
                //       msg: "Please select product",
                //       toastLength: Toast.LENGTH_SHORT,
                //       backgroundColor: Colors.black87,
                //       textColor: Colors.white,
                //       fontSize: 16.0);
                // }else{
                //   cartData.cartItemName.add(CartItem(productName: ProductModel(), itemCount: 0, itemPrice: 0, subTotalPrice: 0, itemcountController: TextEditingController(text: '0')));
                //   setState(() {
                //
                //
                //   });
                // }
              },
              elevation: 1,
              child: Image.asset('assets/icons/pluss.png',
                scale: 3.5,
                color:themeColor2,),
              backgroundColor: themeColor1,),
            bottomNavigationBar: BottomAppBar(
              child:     checkOrderSummary?InkWell(
                onTap: (){
                 // postsalesOrder(cartData);
                  },
                child: Container(
                  color: themeColor2,
                  child: Padding(
                    padding:  EdgeInsets.all(screenpadding),
                    child: Container(
                      height: height*0.06,
                      decoration: BoxDecoration(
                        color: themeColor1,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                        child: Center(
                          child: VariableText(
                            text: 'ORDER NOW',
                            weight: FontWeight.w700,
                            fontsize: 15,
                            fontFamily: fontMedium,
                            fontcolor: themeColor2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ):
              InkWell(
                onTap: (){

                  if(checkOrderSummary==false){
                    print("length is"+cartData.cartItemName.length.toString());
                    setState(() {
                     Provider.of<CartModel>(context,listen: false).updateCart();
                     temp.clear();
                      checkOrderSummary=true;
                    });}
                    else{
                    setState(() {
                      checkOrderSummary=false;
                    });
                  }

                },
                child: Container(
                  color: themeColor2,
                  child: Padding(
                    padding:  EdgeInsets.all(screenpadding),
                    child: Container(
                      height: height*0.06,
                      decoration: BoxDecoration(
                        color: themeColor1,
                        borderRadius: BorderRadius.circular(4),

                      ),

                      child:   Padding(
                        padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                        child: Row(
                          children: [
                          Container(
                          //height: height*0.04,
                          decoration: BoxDecoration(
                            color: themeColor1,
                            shape: BoxShape.circle,
                            border: Border.all(color: themeColor2)

                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: VariableText(
                             // text: quantity.toString(),
                              text: cartData.cartItemName.length.toString(),
                              weight: FontWeight.w500,
                              fontsize: 13,
                              fontFamily: fontMedium,
                              fontcolor: themeColor2,
                            ),
                          ),),
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
                              text: 'Rs.300',
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
              ),
            ),
          ),
          isLoading2 ?  LoadingIndicator(width:width,height:height) : Container(),
        ],
      ),
    );
  }

 /* Widget orderDetailsBlock(double height,double width){
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: screenpadding),
          child: VariableText(
            text: 'ITEMS',
            fontsize:12,fontcolor: textcolorgrey,
            weight: FontWeight.w500,
            fontFamily: fontMedium,
          ),
        ),
        SizedBox(height:height*sizedboxvalue,),
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: orderDetails['order'].length,
            itemBuilder: (BuildContext context,int index){
              return  Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                    child: Container(
                      // height: height*0.09,
                      decoration: BoxDecoration(
                          boxShadow:[ BoxShadow(
                            color:Color(0xffE0E0E099).withOpacity(0.6),)],
                          color: themeColor2
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: screenpadding/2),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Image.asset('assets/icons/delete.png',scale: 3.5,),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue/2,),
                            Expanded(
                              flex: 3,
                              child:
                              Container(
                                // height: height*0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Color(0xffF6821F).withOpacity(0.6)),
                                  color: Color(0xffF6821F).withOpacity(0.5),

                                ),
                                child: Row(
                                  children: [
                                    Expanded(

                                      flex: 1,
                                      child: InkWell(
                                        onTap: (){
                                          if( orderDetails['order'][index]['itemquantity']>0){
                                            setState(() {
                                              orderDetails['order'][index]['itemquantity']--;
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                          ),
                                          height: height*0.04,

                                          child: Image.asset('assets/icons/minus.png',scale: 2.5,),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(  height: height*0.04,
                                        color: themeColor2,
                                        child: Center(
                                          child: VariableText(
                                            text: orderDetails['order'][index]['itemquantity'].toString(),
                                            fontsize:13,fontcolor: themeColor1,
                                            weight: FontWeight.w500,
                                            fontFamily: fontMedium,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: (){
                                          if( orderDetails['order'][index]['itemquantity']>=0){
                                            setState(() {
                                              orderDetails['order'][index]['itemquantity']++;
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),

                                          ),
                                          height: height*0.04,
                                          child: Image.asset('assets/icons/plus.png',scale: 2.5,),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue,),
                            Expanded(
                              flex: 6,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(

                                      children: [
                                        VariableText(
                                          text: orderDetails['order'][index]['itemname'],
                                          fontsize:12,fontcolor: textcolorblack,
                                          weight: FontWeight.w500,
                                          textAlign: TextAlign.start,
                                          fontFamily: fontMedium,
                                        ),
                                        Spacer(),
                                        Image.asset('assets/icons/movedown.png',scale: 3.5,)
                                      ],
                                    ),
                                    SizedBox(height:height*0.0025,),
                                    VariableText(
                                      text: orderDetails['order'][index]['itemPrice'],
                                      fontsize:10,fontcolor: Color(0xff828282),
                                      weight: FontWeight.w400,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue,),
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    VariableText(
                                      text: 'Total',
                                      fontsize:10,fontcolor: Color(0xff828282),
                                      weight: FontWeight.w400,
                                      fontFamily: fontRegular,
                                    ),
                                    SizedBox(height:height*0.0025,),
                                    VariableText(
                                      text:  orderDetails['order'][index]['itemTotal'],
                                      fontsize:12,fontcolor: themeColor1,
                                      weight: FontWeight.w700,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //SizedBox(width:height*sizedboxvalue,),


                          ],
                        ),
                      ),
                    ),

                  ),
                  SizedBox(height:height*sizedboxvalue,),
                ],
              );
            }),
        //SizedBox(height:height*sizedboxvalue,),


      ],
    );

  }*/

 // api here
  Widget orderDetailsBlock(CartModel cartData,double height,double width,){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: screenpadding),
              child: VariableText(
                text: 'ITEMS',
                fontsize:12,fontcolor: textcolorgrey,
                weight: FontWeight.w500,
                fontFamily: fontMedium,
              ),
            ),
          ],
        ),
        SizedBox(height:height*sizedboxvalue,),
    isLoading ? Container(
        height: height*0.30,
        width: width,
        child: LoadingIndicator(width:100 ,height:100 ,)) :
    cartData.cartItemName.length<1?Container(
      height: height*0.35,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VariableText(text: "No item Added",)
        ],
      ),
    ):
    ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: cartData.cartItemName.length,
            physics: ScrollPhysics(),
            //itemCount: product.length,
        itemBuilder: (BuildContext context,int index){
              for(int i=0;i<cartData.cartItemName.length;i++){
                // sel_product.add();
              }
              return  Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                    child: Container(
                      // height: height*0.09,
                      decoration: BoxDecoration(
                          boxShadow:[ BoxShadow(
                            color:Color(0xffE0E0E099).withOpacity(0.6),)],
                          color: themeColor2
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: screenpadding/2),
                        child: Row(
                          children: [
                            SizedBox(width:height*sizedboxvalue/2,),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap:(){
                                  if( cartData.cartItemName.length<=1){
                                    Fluttertoast.showToast(
                                        msg: "You can't clear cart",
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor: Colors.black87,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                 else{
                                   cartData.cartItemName.removeAt(index);
                                  sel_product.removeAt(index);
                                  setState(() {
                                  });}

                                },
                                child: Container(
                                  child: Image.asset('assets/icons/delete.png',scale: 3.5,),
                                ),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue/2,),
                            Expanded(
                              flex: 4,
                              child:
                              Container(
                                // height: height*0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Color(0xffF6821F).withOpacity(0.6)),
                                  color: Color(0xffF6821F).withOpacity(0.5),

                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: (){

                                       if(   sel_product[index]!=null){
                                          if( cartData.cartItemName[index].itemCount>1){
                                            setState(() {
                                              cartData.cartItemName[index].itemCount--;
                                              cartData.cartItemName[index].itemcountController.text=cartData.cartItemName[index].itemCount.toString();
                                              cartData.cartItemName[index].itemPrice= (calculatePrice(quantity: cartData.cartItemName[index].itemCount,productDetils: sel_product[index])??0) as double;
                                             // cartData.cartItemName[index].subTotalPrice= cartData.cartItemName[index].itemPrice*cartData.cartItemName[index].itemCount;
                                              cartData.cartItemName[index].subTotalPrice= (cartData.cartItemName[index].itemPrice*cartData.cartItemName[index].itemCount);
                                            });
                                          }}
                                       else{
                                         Fluttertoast.showToast(
                                             msg: "Please select product",
                                             toastLength: Toast.LENGTH_SHORT,
                                             backgroundColor: Colors.black87,
                                             textColor: Colors.white,
                                             fontSize: 16.0);

                                         print("Please select product ");
                                       }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                          ),
                                          height: height*0.04,

                                          child: Image.asset('assets/icons/minus.png',scale: 2.5,),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex:3,
                                      child: Container(
                                        height: height*0.04,
                                        color: themeColor2,
                                        child: Center(
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            textAlignVertical: TextAlignVertical.center,
                                            controller:cartData.cartItemName[index].itemcountController,

                                            decoration:InputDecoration(
                                                  hintText:cartData.cartItemName[index].itemCount.toString(),
                                              hintStyle: TextStyle(
                                                fontSize:13,color: themeColor1,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: fontMedium,),

                                              contentPadding: EdgeInsets.all(2),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,),

                                               ),
                                            readOnly:sel_product[index]==null?true:false,
                                            onChanged: (value){
                                              setState(() {
                                                cartData.cartItemName[index].itemCount=int.parse(value);
                                                cartData.cartItemName[index].itemPrice= (calculatePrice(quantity: cartData.cartItemName[index].itemCount,productDetils: sel_product[index])??0) as double;
                                                cartData.cartItemName[index].subTotalPrice=cartData.cartItemName[index].itemPrice*cartData.cartItemName[index].itemCount??1;

                                              });

                                            },

                                            style: TextStyle(
                                              fontSize:13,color: themeColor1,
                                                  fontWeight: FontWeight.w500,
                                              fontFamily: fontMedium,),
                                          ),

                                         /* child: VariableText(
                                           text: cartData.cartItemName[index].itemCount.toString(),
                                            fontsize:13,fontcolor: themeColor1,
                                            weight: FontWeight.w500,
                                            fontFamily: fontMedium,
                                            max_lines: 1,
                                          ),*/
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: (){
                                          print(sel_product[index]);

                                          if( sel_product[index]!=null){
                                          if(cartData.cartItemName[index].itemCount>=0){
                                          setState(() {
                                          cartData.cartItemName[index].itemCount++;
                                          cartData.cartItemName[index].itemcountController.text=cartData.cartItemName[index].itemCount.toString();
                                          cartData.cartItemName[index].itemPrice= (calculatePrice(quantity: cartData.cartItemName[index].itemCount,productDetils: sel_product[index])??0) as double;
                                          //cartData.cartItemName[index].subTotalPrice= cartData.cartItemName[index].itemPrice*cartData.cartItemName[index].itemCount;
                                          cartData.cartItemName[index].subTotalPrice=(cartData.cartItemName[index].itemPrice*cartData.cartItemName[index].itemCount);
                                          });
                                        //  print("pricee is"+ cartData.cartItemName[index].subTotalPrice.toString());
                                          }}

                                          else{
                                            Fluttertoast.showToast(
                                                msg: "Please select product",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.black87,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                           }

                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),

                                          ),
                                          height: height*0.04,
                                          child: Image.asset('assets/icons/plus.png',scale: 2.5,),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue,),
                            Expanded(
                              flex: 10,
                              child: Container(
                                child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 // mainAxisSize:MainAxisSize.min,
                                  children: [
                                    Container(
                                      // color:Colors.red,
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<ProductModel>(
                                              isDense: true,
                                              icon:Icon(Icons.arrow_drop_down),
                                              hint: Text("Select Product", style: TextStyle(
                                                fontSize:12,color: textcolorblack,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: fontMedium,)),
                                              value: sel_product[index],
                                              //cartData.cartItemName[index].productName,
                                              isExpanded: true,

                                              onTap: (){

                                              },
                                              onChanged: (product){
                                                setState(() {
                                                  cartData.cartItemName[index].itemcountController.text="1";

                                                  sel_product[index]=product;
                                                  cartData.cartItemName[index].itemCount=1;
                                                 // cartData.cartItemName[index].itemPrice= product.price??0;

                                                 cartData.cartItemName[index].itemPrice= product.productPrice[0].price??0;

                                                  //cartData.cartItemName[index].subTotalPrice = product.price??0;

                                                cartData.cartItemName[index].subTotalPrice = product.productPrice[0].price??0;
                                                 // cartData.cartItemName[index].productName = product;
                                                  cartData.cartItemName[index].productName = product;
                                              });
                                                print("selected product is"+"300");
                                              },
                                              style: TextStyle(    fontSize:12,color: textcolorblack,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: fontMedium,),
                                              items:
                                              widget.product.map<DropdownMenuItem<ProductModel>>((ProductModel item) {
                                                return DropdownMenuItem<ProductModel>(
                                                  value: item,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left:0.0),
                                                    child: VariableText(
                                                        text: item.name.toString(),
                                                      fontsize:12,fontcolor: textcolorblack,
                                                      weight: FontWeight.w500,
                                                      textAlign: TextAlign.start,
                                                      fontFamily: fontMedium,),
                                                  ),
                                                );
                                              }).toList()
                                          )),
                                    ),
                                    VariableText(
                                     // text: orderDetails['order'][index]['itemPrice'],
                                      text: 'Rs.'+ "020",
                                      fontsize:10,fontcolor: Color(0xff828282),
                                      weight: FontWeight.w400,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue,),
                            Expanded(
                             flex: 4,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    VariableText(
                                      text: 'Total',
                                      fontsize:10,fontcolor: Color(0xff828282),
                                      weight: FontWeight.w400,
                                      fontFamily: fontRegular,
                                    ),
                                    SizedBox(height:height*0.0025,),
                                    VariableText(
                                      text:'Rs.'+ "55",
                                      fontsize:12,fontcolor: themeColor1,
                                      weight: FontWeight.w700,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ),
                  SizedBox(height:height*sizedboxvalue,),
                ],
              );
            })
        //SizedBox(height:height*sizedboxvalue,),


      ],
    );

  }
  Future<double> calculatePrice({ int quantity, ProductModel productDetils}) async {
    double dynamicprice;
    List productDetils=[];
    for(var item in productDetils){

      if(item.min<=quantity && item.max>=quantity){
        setState(() {
          dynamicprice= double.parse(item.price.toStringAsFixed(2));
        });
      }
    }
    return 00;

  }
  List<CartItem> temp = [];
  Widget orderSummaryBlock(CartModel cartData,double height,double width){
    double subtotal=0;
    for(int i=0;i<cartData.cartItemName.length;i++){
    //  subtotal+=cartData.cartItemName[i].itemCount*cartData.cartItemName[i].productName.price.toInt();
      subtotal+=cartData.cartItemName[i].itemCount*
    0.00;
          //cartData.cartItemName[i].productName.productPrice[0].price;
    }

    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: screenpadding),
          child: Container(
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
                      Image.asset('assets/icons/ledger.png',scale: 8.5,color: themeColor1,),
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
                      itemCount:cartData.cartItemName.length ,
                      itemBuilder: (BuildContext context,int i){
                      bool repeated = false;
                      int totalCount = cartData.cartItemName[i].itemCount;
                        for(int j=i+1; i<cartData.cartItemName.length && j < cartData.cartItemName.length; j++){
                          if(cartData.cartItemName[i].productName.productCode ==
                          cartData.cartItemName[j].productName.productCode){
                            totalCount += cartData.cartItemName[j].itemCount;
                          }
                        }
                        for(int k=0; k<temp.length; k++){
                          if(temp[k].productName.productCode == cartData.cartItemName[i].productName.productCode){
                            return Container();
                          }
                        }
                        temp.add(cartData.cartItemName[i]);
                        return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex:2,
                                    child: VariableText(
                                      text: "totalCount.toString()+??0",
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
                                      text:  cartData.cartItemName[i].productName.name.toString(),
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
                                     //  text:  (cartData.cartItemName[i].itemCount*cartData.cartItemName[i].productName.price).toString(),
                                       text:  (cartData.cartItemName[i].itemCount*2).toString(),
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
                      return Container();
                        /*return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex:1,
                                  child: VariableText(
                                    text: cartData.cartItemName[index].itemCount.toString()+"x"??0,
                                    //orderDetails['order'][index]['itemquantity'].toString()+"x",
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
                                    text:  cartData.cartItemName[index].productName.name.toString(),
                                    //orderDetails['order'][index]['itemname'],
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
                                    //color:Colors.red,
                                    child: VariableText(
                                      text:  (cartData.cartItemName[index].itemCount*cartData.cartItemName[index].productName.price).toString(),
                                      //orderDetails['order'][index]['itemPrice'],
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
                        );*/
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
                        'Rs. '+"+subtotal.toString()??0",
                        fontsize:14,fontcolor: textcolorgrey,
                        weight: FontWeight.w400,
                        fontFamily: fontRegular,
                      ),
                    ],
                  ),
                /*  SizedBox(height: height*0.0055,),
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
                  ),*/
                  SizedBox(height: height*0.015,),


                ],
              ),
            ),

          ),
        ),

        SizedBox(height:height*sizedboxvalue,),

      ],
    );

  }
  // void postsalesOrder(CartModel cartData,) async{
  //   try {
  //     setLoading2(true);
  //     var response =await  OnlineDatabase.postSalesOrder(cartData:cartData,lat:widget.lat.toString(),long:widget.long.toString(),customerCode:widget.shopDetails.customerCode);
  //     print("Response is" + response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       Navigator.push(context, MaterialPageRoute(builder: (_)=>SucessFullyGeneratedOrderScreen(shopDetails: widget.shopDetails,lat: widget.lat,long: widget.long,)));
  //       setLoading2(false);
  //       Provider.of<CartModel>(context,listen:false).clearCart();
  //     }
  //     else if(response.statusCode == 401){
  //       setLoading2(false);
  //        }
  //     else {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));Fluttertoast.showToast(
  //         // msg: "${data.toString()}",
  //           msg: "Internet issue",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       setLoading2(false);
  //
  //
  //     }
  //   } catch (e, stack) {
  //     print('exception is'+e.toString());
  //     setLoading2(false);
  //     Fluttertoast.showToast(
  //         msg: "Something went wrong try again letter",
  //         toastLength: Toast.LENGTH_SHORT,
  //         backgroundColor: Colors.black87,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }
  setLoading(bool loading){
    setState(() {
      isLoading=loading;
    });
  }
  setLoading2(bool loading){
    setState(() {
      isLoading2=loading;
    });
  }
}

