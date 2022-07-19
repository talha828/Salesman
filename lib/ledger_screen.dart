import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salesmen_app_new/model/legder_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';


class LedgerOnScreen extends StatefulWidget {
  LedgerOnScreen({this.ledgerData});
  List<LedgerModel> ledgerData;

  @override
  State<LedgerOnScreen> createState() => _LedgerOnScreenState();
}

class _LedgerOnScreenState extends State<LedgerOnScreen> {
  double totalBalances = 0;
  double totalCredit = 0;
  double totalDebit = 0;

  @override
  void initState() {
    for (var i = 0; i < widget.ledgerData[0].ledgerDetails.length; i++) {
      totalDebit = totalDebit +
          double.parse(widget.ledgerData[0].ledgerDetails[i].debit.toString());
      totalCredit = totalCredit +
          double.parse(widget.ledgerData[0].ledgerDetails[i].credit.toString());
      totalBalances = totalBalances +
          double.parse(
              widget.ledgerData[0].ledgerDetails[i].balance.toString());
    }
    ;
    // widget.ledgerData[0].ledgerDetails.sort((a,b) => a.date.compareTo(b.date));
    //
    // widget.ledgerData[0].ledgerDetails.sort((a,b) {
    //   return b.date.compareTo(a.date);
    // });
    // for(var i=0;i<widget.ledgerData[0].ledgerDetails.length;i++){
    //   print(widget.ledgerData[0].ledgerDetails[i].date);
    // }
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    setState(() {
      widget.ledgerData.length = 0;
    });
    print("k");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Ledger Details',
        ontap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.ledgerData[0].customerledger_customerName,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        widget.ledgerData[0]
                            .customerledger_customerRegisrationNumber.toString().substring(0,14),
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Today Date: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.ledgerData[0].customerledger_date,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Credit: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.ledgerData[0].customerledger_credit,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Code: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.ledgerData[0].customerledger_customerCode,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Dues: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.ledgerData[0].customerledger_due,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Dues Date: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.ledgerData[0].customerledger_nextdueDate,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Next Dues: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.ledgerData[0].customerledger_nextdue,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Credit: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            totalCredit.toStringAsFixed(2),
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Debit: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            totalDebit.toStringAsFixed(2),
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Balance: ",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        totalBalances.toStringAsFixed(2),
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  )

                  // Text("Credit: $totalCredit",style: TextStyle(fontSize: 14),),
                  // Text("Debit: $totalDebit"),
                  // Text("Balances: ${totalBalances.toStringAsFixed(2)}"),
                ],
              ),
            ),
            ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        var total = double.parse(widget
                                .ledgerData[0].ledgerDetails[index].rate
                                .toString()) *
                            double.parse(widget
                                .ledgerData[0].ledgerDetails[index].quantity
                                .toString());
                        AwesomeDialog(
                          btnOkColor: themeColor1,
                          context: context,
                          dialogType: DialogType.INFO,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Info',
                          body: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Name: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Flexible(
                                        child: Text(widget.ledgerData[0]
                                            .ledgerDetails[index].particular))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Quantity: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(widget.ledgerData[0]
                                        .ledgerDetails[index].quantity)
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rate: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(widget.ledgerData[0]
                                        .ledgerDetails[index].rate)
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(total.toStringAsFixed(2))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          btnOkOnPress: () {},
                        ).show();
                      },
                      child: LedgerCard(
                        color: widget.ledgerData[0].ledgerDetails[index].credit
                                    .toString() ==
                                '0'
                            ? Colors.green
                            : Colors.red,
                        icon: widget.ledgerData[0].ledgerDetails[index].credit
                                    .toString() ==
                                '0'
                            ? FaIcon(
                                FontAwesomeIcons.plus,
                                color: Colors.white,
                                size: 18,
                              )
                            : FaIcon(
                                FontAwesomeIcons.minus,
                                color: Colors.white,
                                size: 18,
                              ),
                        mainText: widget
                                    .ledgerData[0].ledgerDetails[index].debit
                                    .toString() ==
                                '0'
                            ? widget.ledgerData[0].ledgerDetails[index].credit
                                .toString()
                            : widget.ledgerData[0].ledgerDetails[index].debit
                                .toString(),
                        desc: widget
                            .ledgerData[0].ledgerDetails[index].particular
                            .toString(),
                        date: widget.ledgerData[0].ledgerDetails[index].date
                            .toString(),
                        balance: widget
                            .ledgerData[0].ledgerDetails[index].balance
                            .toString(),
                      ));
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemCount: widget.ledgerData[0].ledgerDetails.length),
          ],
        )),
      ),
    );
  }
}

class LedgerCard extends StatelessWidget {
  LedgerCard(
      {this.icon,
      this.mainText,
      this.desc,
      this.balance,
      this.date,
      this.color});
  final icon;
  final mainText;
  final desc;
  final date;
  final balance;
  final color;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: color,
                  child: icon,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: width * 0.52,
                  height: width * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mainText,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                          child: Text(
                        desc,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  date,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  balance,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
