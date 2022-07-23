
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/model/walletledgermodel.dart';
import 'package:salesmen_app_new/screen/ledgerScreen/pdfapi.dart';


class WalletLedger {
  static Future<File> generate({List<WalletLedgerModel> ledgerdata}) async {
    final pdf = Document();

    final customFont = Font.ttf(await rootBundle.load('assets/OpenSans-Regular.ttf'));
    var outputFormat = DateFormat('dd-MMM -yy');

    String datetime=outputFormat.format(DateTime.now());

    pdf.addPage(
      MultiPage(
        orientation: PageOrientation.portrait,
        maxPages: 1000000,
        ///custom pdf page size a2
        pageFormat: PdfPageFormat(42 * PdfPageFormat.cm, 59 * PdfPageFormat.cm, marginAll: 2 * PdfPageFormat.cm),
        //pageFormat: PdfPageFormat.a3.copyWith(),

        build: (context) => <Widget>[
          buildCustomHeader(ledgerdata,datetime),
          buildInvoice(ledgerdata),
          buildTotal(ledgerdata),


        ],
        footer: (context) {
          final text = 'Page ${context.pageNumber} of ${context.pagesCount}';
          return Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 1 * PdfPageFormat.cm),
            child: Text(
              text,
              style: TextStyle(color: PdfColors.black),
            ),
          );

        },)
    );
    return PdfApi.saveDocument(name: 'WalletLedger${DateTime.now().millisecondsSinceEpoch.toString()}.pdf', pdf: pdf);
  }
  static  Widget buildInvoice(List<WalletLedgerModel> ledgerdata) {
    final headers = [
      //'Date',
      'Transaction Number',
      'Particulars',
      'Receive',
      'Deposite',
      'Balance'


    ];

   final data = ledgerdata[0].ledgerDetails.map((item) {
     return [
       //'ddj',
        item.trNumber.toString()==""?"":item.trNumber,
        item.description,
        item.receive.toString()=="0"?"":oCcy.format(int.parse(item.receive)),
        item.deposit.toString()=="0"?"":oCcy.format(int.parse(item.deposit)),
        item.balance.toString()=="0"?"":oCcy.format(int.parse(item.balance)),
     ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 8),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
      },
    );
  }
  static Widget buildCustomHeader(List<WalletLedgerModel> ledgerdata,String datetime) => Container(
    padding: EdgeInsets.only(bottom:0),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(width: 2, color: PdfColors.black)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        Center(
          child:   Text(
            'SUQ Express.com',
            style: TextStyle(fontSize: 19, color: PdfColor.fromInt(0x19263e7d),),
          ),
        ),
        SizedBox(height: 2* PdfPageFormat.mm),
        Center(
          child:    Text(
            'Wallet Ledger',
            style: TextStyle(fontSize: 17, color: PdfColors.black),
          ),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text("ID :- ${ledgerdata[0].empno}",
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(
          "Sales Name :- ${ledgerdata[0].ename}",
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(
          'Current Balance :- ${oCcy.format(int.parse(ledgerdata[0].currentBalance))}',
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text("Date :- $datetime",
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),

        Divider( color: PdfColors.black,
          thickness:2,
        ),
      ],
    ),
  );

  static Widget buildTotal(List<WalletLedgerModel> ledgerDataList) {
    int totalreceive=0;
    int totaldeposite=0;
    int totalbalance=0;

    final data = ledgerDataList[0].ledgerDetails.map((item) {

      totalreceive=totalreceive+int.parse(item.receive);
      totaldeposite=totaldeposite+int.parse(item.deposit);
      totalbalance=totalbalance+int.parse(item.balance);

      return [
        totalreceive,
        totaldeposite,
        totalbalance,


      ];
    }).toList();


    return  Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4 * PdfPageFormat.mm),

                buildText(
                  title: 'Total Receive',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value: oCcy.format(totalreceive),
                  unite: true,
                ),

                SizedBox(height: 1 * PdfPageFormat.mm),
                buildText(
                  title: 'Total Deposit',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value:  oCcy.format(totaldeposite),
                  unite: true,
                ),

                SizedBox(height: 1 * PdfPageFormat.mm),
                Divider(),
                buildText(
                  title: 'Total Balance',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value:  oCcy.format(totalbalance),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),

              ],
            ),
          ),
        ],
      ),
    );
  }
  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }




}