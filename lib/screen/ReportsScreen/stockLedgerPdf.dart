import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/model/legder_model.dart';
import 'package:salesmen_app_new/model/stockLedgerModel.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/screen/ledgerScreen/pdfapi.dart';

class StockLegerPdf {
  static Future<File> generate({List<StockLedgerModel> ledgerdata,String startdate,UserModel userdata}) async {
    final pdf =Document();
    final customFont = Font.ttf(await rootBundle.load('assets/OpenSans-Regular.ttf'));
    pdf.addPage(
        MultiPage(
          orientation: PageOrientation.portrait,
          maxPages: 1000000,
           ///custom pdf page size a2
           pageFormat: PdfPageFormat(42 * PdfPageFormat.cm, 59 * PdfPageFormat.cm, marginAll: 2 * PdfPageFormat.cm),
          //pageFormat: PdfPageFormat.a3.copyWith(),
          build: (context){
            List<Widget> listwidget=[];
            listwidget.add(buildCustomHeader(ledgerdata,userdata));
            for(var item in ledgerdata){
              listwidget.add(buildSubHeading(productCode: item.productCode,productName: item.productName),);
              listwidget.add(SizedBox(height: 3 * PdfPageFormat.mm));
              listwidget.add(buildInvoice(ledgerDetails: item.ledgerDetails ),);
              listwidget.add(SizedBox(height: 6 * PdfPageFormat.mm));
            }
            return listwidget;
          },
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
    return PdfApi.saveDocument(name: 'StockLedger${DateTime.now().millisecondsSinceEpoch.toString()}.pdf', pdf: pdf,);
  }
  static Widget buildSubHeading({    String productCode,
    String productName,}){
        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 2* PdfPageFormat.mm),
        Text(
          'Product $productCode ',
          style: TextStyle(fontSize: 12, color: PdfColors.black,fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2* PdfPageFormat.mm),
        Text(
          'Product Name $productName',
          style: TextStyle(fontSize: 12, color: PdfColors.black,fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2 * PdfPageFormat.mm),


      ],
    );
  }
  static  Widget buildInvoice({
    String productCode,
    String productName,
    List<StockLedgerDetailsModel> ledgerDetails}) {
    var outputFormat=DateFormat('dd-MMM-yy');

    final headers = [
      'Date',
      'Transaction Number',
      'Particulars',
      'Quantity',
      //'Rate',
      'Receive',
      'Deliver',
      'Balance'
    ];

    //int index=0;
    final data2 = ledgerDetails.map((item) {
      return [
        outputFormat.format(DateTime.parse(item.date)),
        item.trNumber=="0"?"":item.trNumber,
        item.description,
        item.qtyin=="0"?"":item.qtyin,
        item.qtyin=="0"?"":item.qtyin,
        item.qtyout=="0"?"":item.qtyout,
        item.balance=="0"?"":oCcy.format(int.parse(item.balance)),
      ];

    }).toList();

        return Table.fromTextArray(
          headers: headers,
          data: data2,

          headerStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 9),
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
  static Widget buildCustomHeader(List<StockLedgerModel> ledgerdata,UserModel userdata ) => Container(
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
            'Stock Ledger',
            style: TextStyle(fontSize: 17, color: PdfColors.black),
          ),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text("Todays Date :- ${ledgerdata[0].reportDate}",
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(
          "Warehouse :- ${ledgerdata[0].warehouse}",
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(
          "Salesman :- ${userdata.userName}",
          style: TextStyle(fontSize: 13, color: PdfColors.black),
        ),
        SizedBox(height: 2 * PdfPageFormat.mm),
      ],
    ),
  );

  static Widget buildTotal(List<LedgerModel> ledgerDataList) {
    int totalreceive=0;
    final data = ledgerDataList.map((item) {
      totalreceive=totalreceive+int.parse('0');
      return [
        totalreceive,
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
                Divider(),
                buildText(
                  title: 'Total Receive',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value: totalreceive.toString(),
                  unite: true,
                ),
                Divider(),

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