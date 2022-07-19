import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salesmen_app_new/model/legder_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import '../../ledger_screen.dart';

class ShowDuesLedger extends StatefulWidget {
  ShowDuesLedger({this.ledgerData});
  List<LedgerModel> ledgerData;

  @override
  State<ShowDuesLedger> createState() => _ShowDuesLedgerState();
}

class _ShowDuesLedgerState extends State<ShowDuesLedger> {
  // double totalBalances=0;
  // double totalCredit=0;
  // double totalDebit=0;
  //
  @override
  void initState() {
    print("length: ${widget.ledgerData[0].duesDetails.length}");
  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    var tempWidth=width;
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
                          padding:EdgeInsets.symmetric(vertical: 10,horizontal: 9),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(children: [
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(widget.ledgerData[0].duesLedger_vendor,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    Spacer(),
                                    Text(widget.ledgerData[0].duesLedger_vendorCode,style: TextStyle(fontSize: 15,color: Colors.grey),),

                                  ],
                                ),
                                SizedBox(height: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Text("Phone No: ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      Text(widget.ledgerData[0].duesLedger_registeredNumber,style: TextStyle(fontSize: 15,color: Colors.grey),),
                                    ],),Row(children: [
                                      Text("Today Date: ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      Text(widget.ledgerData[0].duesLedger_reportDate,style: TextStyle(fontSize: 15,color: Colors.grey),),
                                    ],),
                                  ],
                                ),
                              ],),
                            ),
                              Container(
                                child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context,index){
                                      return InkWell(
                                          onTap: (){
                                            // var total=double.parse(widget.walletledgerData[0].ledgerDetails[index].receive .toString()) * double.parse(widget.walletledgerData[0].ledgerDetails[index].s.toString());
                                            // AwesomeDialog(
                                            //   btnOkColor: themeColor1,
                                            //   context: context,
                                            //   dialogType: DialogType.INFO,
                                            //   animType: AnimType.BOTTOMSLIDE,
                                            //   title: 'Info',
                                            //   body: Container(
                                            //     padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                            //     child: Column(
                                            //       crossAxisAlignment: CrossAxisAlignment.stretch,
                                            //       children: [
                                            //         Row(
                                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //           children: [Text("Name: ",style: TextStyle(fontWeight: FontWeight.bold),),Flexible(child: Text(widget.walletledgerData[0].ledgerDetails[index].particular))],),
                                            //         Row(
                                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //           children: [Text("Quantity: ",style: TextStyle(fontWeight: FontWeight.bold),),Text(widget.walletledgerData[0].ledgerDetails[index].quantity)],),
                                            //         SizedBox(height: 4,),
                                            //         Row(
                                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //           children: [Text("Rate: ",style: TextStyle(fontWeight: FontWeight.bold),),Text(widget.walletledgerData[0].ledgerDetails[index].rate)],),
                                            //         SizedBox(height: 4,),
                                            //         Row(
                                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //           children: [Text("Total: ",style: TextStyle(fontWeight: FontWeight.bold),),Text(total.toStringAsFixed(2))],),
                                            //
                                            //       ],),
                                            //   ),
                                            //   btnOkOnPress: () {},
                                            // ).show();
                                          },
                                          child: LedgerCard(color:widget.ledgerData[0].duesDetails[index].credit.toString()=='0'?Colors.green:Colors.red,icon:widget.ledgerData[0].duesDetails[index].credit.toString()=='0'?FaIcon(FontAwesomeIcons.plus,color: Colors.white,size: 18,):FaIcon(FontAwesomeIcons.minus,color: Colors.white,size: 18,),mainText: widget.ledgerData[0].duesDetails[index].debit.toString()=='0'?widget.ledgerData[0].duesDetails[index].debit.toString():widget.ledgerData[0].duesDetails[index].debit.toString(),desc:  widget.ledgerData[0].duesDetails[index].open.toString(),date:  widget.ledgerData[0].duesDetails[index].date.toString().substring(0,10),balance:widget.ledgerData[0].duesDetails[index].balance.toString(),));

                                    }, separatorBuilder: (context,index){
                                  return SizedBox(height: 10,);
                                }, itemCount: widget.ledgerData[0].duesDetails.length),
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

class BottomText extends StatelessWidget {
  BottomText({this.heading,this.text});
  final heading;
  final text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(heading,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
          Text(text,style: TextStyle(fontSize: 12),),
        ],),
    );
  }
}

class HeadText extends StatelessWidget {
  HeadText({this.heading, this.text});
  final heading;
  final text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            heading,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            text,
          ),
        ],
      ),
    );
  }
}
