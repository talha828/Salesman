import 'package:flutter/material.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/newCustomerModel.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/widget/customer_card.dart';

class ViewAllScreen extends StatefulWidget {
  List<CustomerInfo>customer;
  ViewAllScreen({this.customer});

  @override
  _ViewAllScreenState createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
  var height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: MyAppBar(title: 'View All',ontap: (){
        Navigator.pop(context);
      },) ,
      body:Stack(
        children:[ SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
            child:
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.customer.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CustomerCard(
                      image:"null" ,
                      height: height,
                      width: width,
                      f:f,
                      menuButton: ['DIRECTIONS', 'CHECK-IN'],
                      code: widget.customer[index].cUSTCODE,
                      category: widget.customer[index].pARTYCATEGORY,
                      shopName:widget.customer[index].cUSTOMER ,
                      address: widget.customer[index].aDDRESS,
                      name:widget.customer[index].cONTACTPERSON ,
                      phoneNo:widget.customer[index].pHONE1 ,
                      lastVisit:"--" ,
                      dues: "0",
                      lastTrans:"--" ,
                      outstanding: widget.customer[index].bALANCE,
                      shopAssigned:widget.customer[index].sHOPASSIGNED ,
                      lat: widget.customer[index].lATITUDE,
                      long: widget.customer[index].lONGITUDE,
                      //customerData: CustomerInfo,
                      showLoading:(value){
                        setState(() {
                          isLoading=value;
                        });
                      } ,
                    ),
                    SizedBox(
                      height: height * 0.025,
                    ),
                  ],
                );
              },
            ),

          ),
        ),
          widget.customer.length<1?
        Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:[
                Text("No shops are Found",textAlign: TextAlign.center,),
              ]
          ),
        ):Container(),

          isLoading?Positioned.fill(child: ProcessLoading()):Container()
        ]
      ) ,
    );
  }
}
