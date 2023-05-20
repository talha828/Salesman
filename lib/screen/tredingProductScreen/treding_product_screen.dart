import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/generated/assets.dart';
import 'package:salesmen_app_new/newModel/productModel.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/tradingAddItemDetailsScreen/tradingAddItemDetailsScreen.dart';
import 'package:shimmer/shimmer.dart';


class TradingProductScreen extends StatefulWidget {
  final String subId;
  TradingProductScreen({Key key, this.subId}) : super(key: key);

  @override
  State<TradingProductScreen> createState() => _TradingProductScreenState();
}

class _TradingProductScreenState extends State<TradingProductScreen> {
  bool flag = false;
  Product product;
  getOffers() async {
    setLoading(true);
    var response = await OnlineDatabase.getOffers(subType: widget.subId,isPromotional: 0);
    print("Response is" + response.statusCode.toString());
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
  }

  setLoading(bool value) {
    setState(() {
      flag = value;
    });
  }

  @override
  void initState() {
    getOffers();
    super.initState();
  }

  var onTap = () {};

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
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
            "Product List",
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
        body: InteractiveViewer(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.symmetric(
              vertical: width * 0.04,
            ),
            child: product == null ?ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context,index){
              return Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Padding(
                  padding:  EdgeInsets.all(15),
                  child: Container(
                      width:width,
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
                          borderRadius: BorderRadius.circular(5)
                      ),

                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex:8,
                                child:Column(
                                  children: [
                                    Container(
                                      height: height * 0.20,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5),
                                      ),),
                                    SizedBox(height: height*0.02,),
                                    Container(
                                      height: height*0.05,
                                      width: width,
                                      decoration: BoxDecoration(
                                          color: themeColor1,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child:Center(
                                          child:Container(
                                            height: 10,
                                            width: 20,
                                            color: themeColor1,
                                          )
                                      )
                                      ,
                                    ),

                                  ],
                                )),
                            Expanded(flex:14,
                                child:
                                Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 200,
                                        color: themeColor1,
                                      ),
                                      SizedBox(height: height*0.01,),
                                      Container(
                                        height: 30,
                                        width: 200,
                                        color: themeColor1,
                                      ),
                                      SizedBox(height: height*0.01,),
                                      Container(
                                        height: 30,
                                        width: 200,
                                        color: themeColor1,
                                      ),

                                      SizedBox(height: height*0.01,),
                                      Container(
                                        height: 30,
                                        width: 200,
                                        color: themeColor1,
                                      ),
                                      SizedBox(height: height*0.01,),
                                      SizedBox(height: height*0.01,),

                                      Container(
                                        height: 30,
                                        width: 200,
                                        color: themeColor1,
                                      ),
                                      SizedBox(height: height*0.01,),
                                      SizedBox(height: height*0.0055,),

                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                      )
                  ),
                ),);
            }, separatorBuilder:  (context,index){return SizedBox(height: width * 0.04,); }, itemCount:4):ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ProductTile(
                      width: width, product: product.results[index],additem: true,);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: width * 0.04,
                  );
                },
                itemCount: product.results.length),
          )),
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  ProductTile({
    Key key,
    @required this.width,
    @required this.product,
    @required this.additem
  }) : super(key: key);

  final double width;
  final Results product;
  final bool  additem;
  final Shader linearGradient = LinearGradient(
    end: Alignment.topRight,
    begin: Alignment.bottomLeft,
    colors: <Color>[
      const Color(0xFF22E774),
      const Color(0xFF0C9933),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    product.pRICE.sort((a, b) {
      if (a.sTATUS == "A" && b.sTATUS != "A") {
        return -1; // a comes before b
      } else if (a.sTATUS != "A" && b.sTATUS == "A") {
        return 1; // b comes before a
      } else {
        return 0; // keep the same order
      }
    });
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: width * 0.02, horizontal: width * 0.02),
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
                  onTap: (){
                    Image _img = Image.network(product.iMAGEURL);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        barrierColor:  Colors.black,
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
                      fit: BoxFit.cover,
                      height: width * 0.3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: width * 0.04,
              ),
              additem?InkWell(
                onTap: (){ Get.to(TradingAddProductDetails(results: product,));},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    gradient: LinearGradient(
                        end: Alignment.topRight,
                        begin: Alignment.bottomLeft,
                        colors: <Color>[
                          const Color(0xFF22E774),
                          const Color(0xFF0C9933),
                        ]),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: width * 0.02, horizontal: width * 0.045),
                  child: Text(
                    "ADD OFFER",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ):Container(),
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
                    Text(product.pRODCODE, maxLines: 1,style: TextStyle(fontSize: 12,),),
                    Flexible(
                      child: Text(
                        product.bRAND,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize:13,
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
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      foreground: Paint()..shader = linearGradient,
                      ),
                ),
                SizedBox(height: width * 0.04,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(product.mODEL != null)
                    Text(
                      product.mODEL,
                      maxLines: 1,
                      style: TextStyle(fontSize: 13,color: Colors.grey),
                    ),
                    if(product.dESCRIPTION != null)
                    Text(
                      product.dESCRIPTION,
                      maxLines: 1,
                      style: TextStyle(fontSize: 13,color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(
                  height: width * 0.02,
                ),
                product.oFFERITEM == "Y"
                    ? Container(
                  //height: width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                  ),
                  child: Table(
                    children: [
                      TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text("Qty",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),)),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text("Rate",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),)),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text("MRP",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),)),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text("Expire",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),)),
                            ),
                          ]
                      ),
                      for(int i=0;i<(additem?(product.pRICE.length>5 ?5:product.pRICE.length):product.pRICE.length);i++)
                        product.pRICE[i].sTATUS=="A"?
                        TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text(product.pRICE[i].qTY.toString(),style: TextStyle(fontSize: 11,color: Colors.black45),)),
                              ),
                              TableCell(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text(product.pRICE[i].rATE.toString(),style: TextStyle(fontSize: 11,color: Colors.black45),)),
                              ),
                              TableCell(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text(product.pRICE[i].mRP.toString() == "NULL"?"--":product.pRICE[i].mRP.toString(),style: TextStyle(fontSize: 11,color: Colors.black45),)),
                              ),
                              TableCell(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text(product.pRICE[i].eXPIRE.toString()=="NULL"?"--":product.pRICE[i].eXPIRE.toString(),style: TextStyle(fontSize: 9,color: Colors.black45,),)),
                              ),
                            ]
                        ): TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  ),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  ),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                ),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                 ),
                            ),
                          ]
                        ),
                    ],
                  ),
                  // Column(
                  //   children: [
                  //
                  //     // Row(
                  //     //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     //   children: [
                  //     //     Text("QTY",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                  //     //     Text("RATE",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                  //     //     Text("MRP",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                  //     //     Text("EXPIRE",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                  //     //   ],
                  //     // ),
                  //     // SizedBox(height: width*0.02,),
                  //     // Expanded(
                  //     //   child: ListView.separated(
                  //     //       itemBuilder: (context, index) {
                  //     //         return product.pRICE[index].sTATUS=="N"?Container():Container(
                  //     //           child: Row(
                  //     //             mainAxisAlignment:
                  //     //             MainAxisAlignment.spaceEvenly,
                  //     //             children: [
                  //     //               Text(product.pRICE[index].qTY.toString(),style: TextStyle(fontSize: width * 0.03),),
                  //     //               Text(product.pRICE[index].rATE.toString(),style: TextStyle(fontSize: width * 0.03),),
                  //     //               Text(product.pRICE[index].mRP,style: TextStyle(fontSize: width * 0.03),),
                  //     //               if(product.pRICE[index].eNTRYDATE != null)
                  //     //               Text(product.pRICE[index].eXPIRE.toString(),style: TextStyle(fontSize: width * 0.03),),
                  //     //             ],
                  //     //           ),
                  //     //         );
                  //     //       },
                  //     //       separatorBuilder: (context, index) {
                  //     //         return SizedBox(
                  //     //           height: width * 0.01,
                  //     //         );
                  //     //       },
                  //     //       itemCount: product.pRICE.length),
                  //     // )
                  //   ],
                  // ),
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
// DataTable(
// columns: [
// DataColumn(
// label: Text('QTY',
// style: TextStyle(
// fontWeight:
// FontWeight.bold))),
// DataColumn(
// label: Text('Rate',
// style: TextStyle(
// fontWeight:
// FontWeight.bold))),
// DataColumn(
// label: Text('MRP',
// style: TextStyle(
// fontWeight:
// FontWeight.bold))),
// DataColumn(
// label: Text('Expire',
// style: TextStyle(
// fontWeight:
// FontWeight.bold))),
// ],
// rows: product.pRICE
//     .map<DataRow>(
// (e) => DataRow(cells: [
// DataCell(
// Text(e.pURQTY.toString())),
// DataCell(
// Text(e.rATE.toString())),
// DataCell(
// Text(e.mRP.toString())),
// DataCell(Text(e.eNTRYDATE
//     .substring(0, 10))),
// ]),
// )
// .toList()),
