import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/model/legder_model.dart';
import 'package:salesmen_app_new/screen/ledgerScreen/pdfapi.dart';


class CustomerPdf {
  static Future<File> generate({List<LedgerModel> ledgerDataList,String startdate,String endate,String shopName}) async {
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
        build: (context){
          List<Widget> listwidget=[];
          listwidget.add(buildCustomHeader(ledgerdata: ledgerDataList),);
          listwidget.add(SizedBox(height: 3 * PdfPageFormat.mm));
          for(var item in ledgerDataList){
            listwidget.add(buildInvoice(item.ledgerDetails));
            listwidget.add(SizedBox(height: 3 * PdfPageFormat.mm));
            listwidget.add(buildTotal(item.ledgerDetails));
          }
          return listwidget;

        },
 /*       build: (context) => <Widget>[
          buildCustomHeader(startdate:outputFormat.format(DateTime.parse(startdate)),endate:outputFormat.format(DateTime.parse(endate)),shopName: shopName,datetime: datetime),
          buildInvoice(ledgerDataList),
          buildTotal(ledgerDataList),
        ],*/
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
        },
      ),
    );
    return PdfApi.saveDocument(name: 'CustomerLedger${DateTime.now().millisecondsSinceEpoch.toString()}.pdf', pdf: pdf);
  }
 static  Widget buildInvoice(List<CustomerLedgerDetails> ledgerDataList) {

    final headers = [
      'Date',
      'Trans.#',
      'Particular/Item',
      'Quantity',
      'Rate',
      'Debit',
      'Credit',
      'Balance',
    ];
    final data = ledgerDataList.map((item) {
      print("length is"+ledgerDataList.length.toString());
      var outputFormat = DateFormat('dd-MMM -yy');

      return [
      outputFormat.format(DateTime.parse(item.date)),
       item.tr.toString()=="0"?"":item.tr,
        item.particular,
        item.quantity.toString()=="0"?"":item.quantity,
        item.rate.toString()=="0"?"":oCcy.format(double.parse(item.rate)),
        item.debit.toString()=="0"?"":oCcy.format(double.parse(item.debit)),
        item.credit.toString()=="0"?"":oCcy.format(double.parse(item.credit)),
        item.balance.toString()=="0"?"":oCcy.format(double.parse(item.balance)),



      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      //border: Border.all(color: Colors.black),
      headerStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 8),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),

      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
        7: Alignment.centerRight,
        8: Alignment.centerLeft,
      },
    );
  }


  static Widget buildCustomHeader({List<LedgerModel> ledgerdata,}) =>Container(
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
            'Customer Ledger',
            style: TextStyle(fontSize: 17, color: PdfColors.black),
          ),
        ),

        SizedBox(height: 2 * PdfPageFormat.mm),
        Row(
            children: [
              Text(
                "Today's Date :- ${ledgerdata[0].customerledger_date}",
                style: TextStyle(fontSize: 13, color: PdfColors.black),
              ),
              Spacer(),
              Text(
                "Store Credit :- ${ledgerdata[0].customerledger_credit.toString()=="0"?"":oCcy.format(double.parse(ledgerdata[0].customerledger_credit.toString()))}",
                style: TextStyle(fontSize: 13, color: PdfColors.black),
              ),

            ]
        ),
        SizedBox(height: 2 * PdfPageFormat.mm),
        Row(
            children: [
              Text(
                "Store Code :- ${ledgerdata[0].customerledger_customerCode}",
                style: TextStyle(fontSize: 13, color: PdfColors.black),
              ),
              Spacer(),
              Text(
                "Store Dues :- Rs ${ledgerdata[0].customerledger_due.toString()=="0"?"":oCcy.format(double.parse(ledgerdata[0].customerledger_due.toString()))}",
                style: TextStyle(fontSize: 13, color: PdfColors.black),
              ),
            ]
        ),
        SizedBox(height: 2 * PdfPageFormat.mm),
        Row(
            children: [
              Text(
                "Store Name :- ${ledgerdata[0].customerledger_customerName}",
                style: TextStyle(fontSize: 13, color: PdfColors.black),
              ),
              Spacer(),
              Text(
                "Next due Amount :- Rs ${ledgerdata[0].customerledger_nextdue.toString()=="0"?"":oCcy.format(double.parse(ledgerdata[0].customerledger_nextdue.toString()))}",
                style: TextStyle(fontSize: 13, color: PdfColors.black),
              ),
            ]
        ),
        SizedBox(height: 2 * PdfPageFormat.mm),
        Row(
            children: [
              Text(
                "Registration Number :- ${ledgerdata[0].customerledger_customerRegisrationNumber}",
                style: TextStyle(fontSize: 13, color: PdfColors.black),
              ),
              Spacer(),
              Text(
                "Due Date :- ${ledgerdata[0].customerledger_nextdueDate}",
                style: TextStyle(fontSize: 13, color: PdfColors.black),
              ),
            ]
        ),
        SizedBox(height: 2 * PdfPageFormat.mm),

      ],
    ),
  );


  static Widget buildTotal(List<CustomerLedgerDetails> ledgerDataList) {
    int totalQuantity=0;
    double totalDebit=0;
    double totalCredit=0;
    double totalBalance=0;
    final data = ledgerDataList.map((item) {
      print("length is"+ledgerDataList.length.toString());

      totalQuantity=totalQuantity+int.parse(item.quantity);
      totalDebit=totalDebit+double.parse(item.debit);
      totalCredit=totalCredit+double.parse(item.credit);
      totalBalance=totalBalance+double.parse(item.balance);
      return [
        totalQuantity,
        totalDebit,
        totalCredit,
        totalBalance,


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
                  title: 'Total Quantity',
                  value: oCcy.format(int.parse(totalQuantity.toString())),
                  unite: false,
                ),
                SizedBox(height: 1 * PdfPageFormat.mm),
                buildText(
                    title: 'Total Debit',
                    value:oCcy.format(double.parse(totalDebit.toString()))),
                SizedBox(height: 1 * PdfPageFormat.mm),
                buildText(
                    title: 'Total Credit',
                    value:oCcy.format(double.parse(totalCredit.toString()))),
                Divider(),
                buildText(
                  title: 'Total Balance',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value: oCcy.format(double.parse(totalBalance.toString())),
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
  static Widget buildCustomHeadline() => Header(
    child: Text(
      'My Third Headline',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: PdfColors.white,
      ),
    ),
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(color: PdfColors.red),
  );

  static Widget buildLink() => UrlLink(
    destination: 'https://flutter.dev',
    child: Text(
      'Go to flutter.dev',
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: PdfColors.blue,
      ),
    ),
  );



}