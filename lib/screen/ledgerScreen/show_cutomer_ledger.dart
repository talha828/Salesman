import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/legder_model.dart';
import 'package:salesmen_app_new/others/common.dart';

import '../../ledger_screen.dart';

class ShowCustomerLedger extends StatefulWidget {
  ShowCustomerLedger({this.ledgerData,this.shopDetails});
  List<LedgerModel> ledgerData;
  CustomerModel shopDetails;

  @override
  State<ShowCustomerLedger> createState() => _ShowCustomerLedgerState();
}

class _ShowCustomerLedgerState extends State<ShowCustomerLedger> {
  double total=0;
  getTotal(){
    for (var item in widget.ledgerData){
     total=total+ double.parse(item.cashledger_amount);
    }
    setState(() {});
  }
  @override
  void initState() {
    getTotal();
    super.initState();
  }
  @override
  void dispose() {
    widget.ledgerData.length=0;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    print("vbalsvsav;sa");
    return Scaffold(
        appBar: MyAppBar(
          title: 'Wallet Ledger',
          ontap: () {
            Navigator.pop(context);
          },
        ),
        body: InteractiveViewer(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Text("Name: ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                  Text(widget.shopDetails.customerShopName,style: TextStyle(fontSize: 15,color: Colors.grey),),

                                ],
                              ),
                              Row(
                                children: [
                                  Text("Customer ID: ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                  Text(widget.shopDetails.customerCode,style: TextStyle(fontSize: 15,color: Colors.grey),),

                                ],
                              ),
                              Row(
                                children: [
                                  Text("Total:  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                  Text(total.toInt().toString(),style: TextStyle(fontSize: 15,color: Colors.grey),),

                                ],
                              ),
                              SizedBox(height: 10,),
                              Container(
                                child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context,index){
                                      return InkWell(
                                          child: LedgerCard(color:Colors.red,icon:FaIcon(FontAwesomeIcons.plus,color: Colors.white,size: 18,),mainText: widget.ledgerData[index].cashledger_amount,desc:  widget.ledgerData[index].cashledger_description.toString(),date:  widget.ledgerData[index].cashledger_date.toString().substring(0,10),balance:""));

                                    }, separatorBuilder: (context,index){
                                  return SizedBox(height: 10,);
                                }, itemCount: widget.ledgerData.length),
                              ),
                            ],
                          )
                      ),]
                ),
              ),
            )
        ));
  }
}
