import 'dart:convert';

import 'package:flutter/cupertino.dart';

class StockLedgerModel{
  String warehouse;
  String productCode;
  String productName;
  String reportDate;
  List<StockLedgerDetailsModel> ledgerDetails=[];
  StockLedgerModel();
  StockLedgerModel.fromJson(Map<String,dynamic> json){
    try{

  warehouse=json['WAREHOUSE'];
  productCode=json['PROD_CODE'];
  productName=json['PRODUCT'];
  reportDate=json['REPORT_DATE'];

  for(var item in json['LEDGER'])  {
          ledgerDetails.add(StockLedgerDetailsModel.fromJson(item));
    }
    }
    catch(e){print('exception in stockLedgerModel is'+e.toString());}
  }
}

class StockLedgerDetailsModel{
  String date;
  String trNumber;
  String description;
  String qtyin;
  String qtyout;
  String balance;
StockLedgerDetailsModel();

StockLedgerDetailsModel.fromJson(Map<String,dynamic> json){

  try{
    date=json['DATE'].toString();
    trNumber=json['TR'].toString()=="null"?"0":json['TR'].toString().toString();
    description=json['DESCRIPTION'].toString();
    qtyin=json['QTYIN'].toString()=="null"?"0":json['QTYIN'].toString().toString();
    qtyout=json['QTYOUT'].toString()=="null"?"0":json['QTYOUT'].toString().toString();
    balance=json['BALANCE'].toString().toString()=="null"?"0":json['BALANCE'].toString().toString();
}
  catch(e){
    print("exception in stockLedgerDetailsModel is"+e.toString());
}
}


}