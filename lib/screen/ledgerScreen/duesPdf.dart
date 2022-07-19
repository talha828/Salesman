import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/model/legder_model.dart';
import 'package:salesmen_app_new/screen/ledgerScreen/pdfapi.dart';


class DuesPdf {
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
            listwidget.add(buildInvoice(item.duesDetails));
            listwidget.add(SizedBox(height: 3 * PdfPageFormat.mm));
            //listwidget.add(buildTotal(item.ledgerDetails));
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
    return PdfApi.saveDocument(name: 'DuesLedger${DateTime.now().millisecondsSinceEpoch.toString()}.pdf', pdf: pdf);
  }
  static  Widget buildInvoice(List<DuesLedgerDetails> ledgerDataList) {

    final headers = [
      'Date',
      'Debit',
      'Credit',
      'Balance',
    ];
    final data = ledgerDataList.map((item) {
      print("length is: " + ledgerDataList.length.toString());
      var outputFormat = DateFormat('dd-MMM-yy');

      return [
        outputFormat.format(DateTime.parse(item.date)),
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
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
        6: Alignment.centerLeft,
        7: Alignment.centerLeft,
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
          child: Text(
            'SUQ Express.com',
            style: TextStyle(fontSize: 19, color: PdfColor.fromInt(0x19263e7d),),
          ),
        ),
        SizedBox(height: 2* PdfPageFormat.mm),
        Center(
          child:    Text(
            'Dues Ledger',
            style: TextStyle(fontSize: 17, color: PdfColors.black),
          ),
        ),

        SizedBox(height: 2 * PdfPageFormat.mm),
        Row(
            children: [
              Text(
                "Vendor Code :- ${ledgerdata[0].duesLedger_vendorCode}",
                style: TextStyle(fontSize: 13, color: PdfColors.black),
              ),
              Spacer(),
              Text(
                "Vendor Name :- ${ledgerdata[0].duesLedger_vendor}",
                style: TextStyle(fontSize: 13, color: PdfColors.black),
              ),

            ]
        ),
        SizedBox(height: 2 * PdfPageFormat.mm),
        Row(
            children: [
              Text(
                "Registered Number :- ${ledgerdata[0].duesLedger_registeredNumber}",
                style: TextStyle(fontSize: 13, color: PdfColors.black),
              ),
              Spacer(),
              Text(
                "Report Date :- Rs ${ledgerdata[0].duesLedger_reportDate}",
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
    int totalDebit=0;
    int totalCredit=0;
    int totalBalance=0;
    final data = ledgerDataList.map((item) {
      print("length is"+ledgerDataList.length.toString());

      totalQuantity=totalQuantity+int.parse(item.quantity);
      totalDebit=totalDebit+int.parse(item.debit);
      totalCredit=totalCredit+int.parse(item.credit);
      totalBalance=totalBalance+int.parse(item.balance);
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
                    value:oCcy.format(int.parse(totalDebit.toString()))),
                SizedBox(height: 1 * PdfPageFormat.mm),
                buildText(
                    title: 'Total Credit',
                    value:oCcy.format(int.parse(totalCredit.toString()))),
                Divider(),
                buildText(
                  title: 'Total Balance',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value: oCcy.format(int.parse(totalBalance.toString())),
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