
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/legder_model.dart';
import 'package:salesmen_app_new/screen/ledgerScreen/pdfapi.dart';


class CashPdf {
  static Future<File> generate({List<LedgerModel> ledgerDataList,String startdate,String endate,CustomerModel shopDetals,String balance}) async {
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
          buildCustomHeader(startdate:outputFormat.format(DateTime.parse(startdate)),endate:outputFormat.format(DateTime.parse(endate)),datetime: datetime,shopdetails: shopDetals,balance:balance),
          buildInvoice(ledgerDataList),
          buildTotal(ledgerDataList),


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
        },
      ),
    );
    return PdfApi.saveDocument(name: 'CashLedger${DateTime.now().millisecondsSinceEpoch.toString()}.pdf', pdf: pdf);
  }
  static  Widget buildInvoice(List<LedgerModel> ledgerDataList) {
    final headers = [
      'Date',
      'Transaction Number',
      'Particulars',
      'Receive',
    ];
    final data = ledgerDataList.map((item) {
      print("length is"+ledgerDataList.length.toString());
      var outputFormat = DateFormat('dd-MMM -yy');

      return [
        outputFormat.format(DateTime.parse(item.cashledger_date)),
        item.cashledger_documentNumber??'',
        item.cashledger_description,
        item.cashledger_amount,



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
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
      },
    );
  }
  static Widget buildCustomHeader({String startdate,String endate,String shopName,String datetime,CustomerModel shopdetails,String balance}) => Container(
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
            'Cash Ledger',
            style: TextStyle(fontSize: 18, color: PdfColors.black),
          ),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text("ID :- ${shopdetails.customerCode}",
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(
          "Sales Name :- ${shopdetails.customerContactPersonName}",
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(
          'Current Balance :- ${balance.toString()=="0"?"":oCcy.format(double.parse(balance))}',
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),

        Divider( color: PdfColors.black,
          thickness:2,
        ),
      ],
    ),
  );

  static Widget buildTotal(List<LedgerModel> ledgerDataList) {

    double totaldeposite=0;
    double totaReceivedCredit=0;
    double totalBalance=0;
    final data = ledgerDataList.map((item) {
      print("length is"+ledgerDataList.length.toString());

      totaldeposite=totaldeposite+double.parse("0");
      totaReceivedCredit=totaReceivedCredit+double.parse('0');
      totalBalance=totalBalance+double.parse(item.cashledger_amount);
      return [
        totaldeposite,
        totaReceivedCredit,
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
                // buildText(
                //   title: 'Total Receive',
                //   value:oCcy.format(int.parse(totaReceivedCredit.toString())),
                //   unite: false,
                // ),
                // SizedBox(height: 1 * PdfPageFormat.mm),
                // buildText(
                //     title: 'Total Deposite',
                //     value:oCcy.format(int.parse(totaldeposite.toString())),),
                //
                //
                // Divider(),
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




}