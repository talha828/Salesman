import 'package:flutter/cupertino.dart';

class WalletLedgerModel extends ChangeNotifier{
  String empno;
  String ename;
  String reportdate;
  String currentBalance;
  List<WalletLedgerDetailsModel> ledgerDetails=[];

  WalletLedgerModel();

  WalletLedgerModel.fromJson(Map<String,dynamic> json){
    try{
      empno=json['EMPNO'];
      ename=json['ENAME'];
      reportdate=json['REPORT_DATE'];
      currentBalance=json['CURR_BALANCE'].toString();
      for(var item in json['LEDGER']){
        ledgerDetails.add(WalletLedgerDetailsModel.fromJson(item));

      }
    }
    catch(e){
      print("exception in WalletLedgerModel is"+e.toString());
    }
  }
}
class WalletLedgerDetailsModel extends ChangeNotifier{

  String trNumber;
  String description;
  String receive;
  String deposit;
  String balance;
  String date;
  WalletLedgerDetailsModel();
  WalletLedgerDetailsModel.fromJson(Map<String,dynamic> json){

    try{
      trNumber=json['TR'].toString();
      date=json['DT'].toString().substring(0,10);
      description=json['DESCRIPTION'].toString();
      receive=json['RECEIVE'].toString()=='null'?"":receive=json['RECEIVE'].toString();
      deposit=json['DEPOSIT'].toString()=='null'?"":deposit=json['DEPOSIT'].toString();
      balance=json['BALANCE'].toString();
    }
    catch(e){
      print("exception in WalletLedgerDetailsModel is"+e.toString());
    }
  }}
