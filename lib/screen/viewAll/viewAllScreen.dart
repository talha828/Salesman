import 'package:flutter/material.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/others/common.dart';

class ViewAllScreen extends StatefulWidget {
  List<CustomerModel>customer;
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
                    CustomShopContainer(
                      customerList: widget.customer,
                      height: height,
                      width: width,
                      customerData:widget.customer[index],
                      //isLoading2: isLoading2,
                      //enableLocation: _serviceEnabled,
                      lat: 1.0,
                      long:1.0,
                      showLoading: (value) {
                        setState(() {
                          isLoading = value;
                        });
                      },
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
