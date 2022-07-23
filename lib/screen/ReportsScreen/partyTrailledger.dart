
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/model/partyTrailLedgermodel.dart';
import 'package:salesmen_app_new/screen/ledgerScreen/pdfapi.dart';


class PartyTrailLedger {
  static Future<File> generate({List<PartyTrailLedgerModel> ledgerdata,String startdate}) async {
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
            buildCustomHeader(ledgerdata),
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
    return PdfApi.saveDocument(name: 'PartyTrialLedger${DateTime.now().millisecondsSinceEpoch.toString()}.pdf', pdf: pdf);
  }
  static  Widget buildInvoice(List<PartyTrailLedgerModel> ledgerdata) {
    final headers = [
      'PartyName',
      'Sales Order',
      'Sales Return',
      'Cheque',
      'Cash',
      'DebitTotal',
      'Payment Return',
      'Party Adjust',
      'Sales Service Invoice',
      'Sales Invoice',
      'Credit Total',

    ];


    final data = ledgerdata[0].details.map((item) {
      return [
        item.partyName,
          item.salesOrder.toString()=="0"?"":oCcy.format(double.parse(item.salesOrder)),
          item.salesReturn.toString()=="0"?"":oCcy.format(double.parse(item.salesReturn)),
          item.cheque.toString()=="0"?"":oCcy.format(double.parse(item.cheque)),
          item.cash.toString()=="0"?"":oCcy.format(double.parse(item.cash)),
          item.totalDebit.toString()=="0"?"":oCcy.format(double.parse(item.totalDebit)),
          item.paymentReturn.toString()=="0"?"":oCcy.format(double.parse(item.paymentReturn)),
          item.partyAdjust.toString()=="0"?"":oCcy.format(double.parse(item.partyAdjust)),
          item.salesServiceInvoice.toString()=="0"?"":oCcy.format(double.parse(item.salesServiceInvoice)),
          item.salesInvoice.toString()=="0"?"":oCcy.format(double.parse(item.salesInvoice)),
          item.totalCredit.toString()=="0"?"":oCcy.format(double.parse(item.totalCredit)),];
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
  static Widget buildCustomHeader(List<PartyTrailLedgerModel> ledgerdata ) => Container(
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
            'Party Trial Ledger',
            style: TextStyle(fontSize: 18, color: PdfColors.black),
          ),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text("ID :- ${ledgerdata[0].id}",
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(
          "Sales Name :- ${ledgerdata[0].name}",
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),


        Divider( color: PdfColors.black,
          thickness:2,
        ),
      ],
    ),
  );

  static Widget buildTotal(List<PartyTrailLedgerModel> ledgerDataList) {
    double totaldebit=0;
    double totalcredit=0;
    double totalcheque=0;
    double totalcash=0;



    final data = ledgerDataList[0].details.map((item) {

    totaldebit=totaldebit+double.parse(item.totalDebit);
    totalcredit=totalcredit+double.parse(item.totalCredit);
    totalcheque=totalcheque+double.parse(item.cheque);
    totalcash=totalcash+double.parse(item.cash);

      return [
    totaldebit,
    totalcredit,
    totalcheque,
    totalcash,


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
                  title: 'Total Cheque',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value: oCcy.format(totalcheque),
                  unite: true,
                ),

                SizedBox(height: 2 * PdfPageFormat.mm),
                buildText(
                  title: 'Total Cash',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value: oCcy.format(totalcash),
                  unite: true,
                ),

                SizedBox(height: 1 * PdfPageFormat.mm),
                Divider(),
                buildText(
                  title: 'Total Credit',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value: oCcy.format(totalcredit),
                  unite: true,
                ),

                SizedBox(height: 1 * PdfPageFormat.mm),
                Divider(),
                buildText(
                  title: 'Total Debit',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value: oCcy.format(totaldebit),
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