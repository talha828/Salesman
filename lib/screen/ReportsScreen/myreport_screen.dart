import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/others/common.dart';


class MyReportScreen extends StatefulWidget {

  @override
  State<MyReportScreen> createState() => _MyReportScreenState();
}

class _MyReportScreenState extends State<MyReportScreen> {
  @override
  Widget build(BuildContext context) {
    var userData=Provider.of<UserModel>(context);
    return Scaffold(
      appBar: MyAppBar(title: 'Reports Details',ontap: (){
        Navigator.pop(context);
      },) ,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child:Column(children: [
               Container(
                 height: 140,
                 child: Row(children: [
                   Expanded(
                       flex: 1,
                       child: CustomCheckInContainer(
                         onTap: (){},
                         text: 'Wallet Ledger',
                         image: 'assets/icons/wallet_ledger.png',
                         containerColor: Color(0xff219653),
                       )),
                   SizedBox(width: 10,),
                   Expanded(
                       flex: 1,
                       child: CustomCheckInContainer(
                         onTap: (){},
                         text: 'Party Trail Ledger',
                         image: 'assets/icons/party_ledger.png',
                         containerColor: Color(0xffF6821F),
                       )),
                 ],),
               ),
          Row(children: [
            Expanded(
                flex: 1,
                child: CustomCheckInContainer(
                  onTap: (){},
                  text: 'Delivers',
                  image: 'assets/icons/delivery.png',
                  containerColor: Color(0xff1F92F6),
                )),
          ],)
        ],),),
    );
  }
}
