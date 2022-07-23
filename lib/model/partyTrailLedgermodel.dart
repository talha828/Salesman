import 'package:flutter/cupertino.dart';

class PartyTrailLedgerModel extends ChangeNotifier{
  String id;
  String name;
  List<PartyTrailLedgerDetailModel> details=[];

  PartyTrailLedgerModel();

  PartyTrailLedgerModel.fronJson(Map<String,dynamic> json){
    try{
      id=json['ID'];
      name=json['SALESMAN'];
      for(var item in json['DATA']){
        details.add(PartyTrailLedgerDetailModel.fromJson(item));
      }
    }
    catch(e){
      print("exception in PartyTrailLedgerModel is"+e.toString());
    }

  }


}
class PartyTrailLedgerDetailModel extends ChangeNotifier{
  String partyName;
  String salesOrder;
  String salesReturn;
  String cheque;
  String cash;
  String totalDebit;
  String paymentReturn;
  String partyAdjust;
  String salesServiceInvoice;
  String salesInvoice;
  String totalCredit;

  PartyTrailLedgerDetailModel();

  PartyTrailLedgerDetailModel.fromJson(Map<String,dynamic> json){
    try{
      partyName=json["CUSTOMER"].toString();
      salesOrder=json["ORDERS"].toString();
      salesReturn=json["SAL_RETURN"].toString();
      cheque=json["CHEQ"].toString();
      cash=json["CASH"].toString();
      totalDebit=json["TOTAL_DEBIT"].toString();
      paymentReturn=json["PAYMENT"].toString();
      partyAdjust=json["ADJ"].toString();
      salesServiceInvoice=json["SAL_SER_INV"].toString();
      salesInvoice=json["SALES"].toString();
      totalCredit=json["TOTAL_CREDIT"].toString();
    }
    catch(e){
      print("exception in PartyTrailLedgerDetailModel is "+e.toString() );
    }
  }



}
