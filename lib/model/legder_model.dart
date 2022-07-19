class LedgerModel{
  String customerledger_customerCode;
  String customerledger_customerName;
  String customerledger_customerRegisrationNumber;
  String customerledger_date;
  String customerledger_credit;
  String customerledger_due;
  String customerledger_nextdue;
  String customerledger_nextdueDate;
  String customerledger_balance;
  List<CustomerLedgerDetails> ledgerDetails=[];
  ///cash ledger
  String cashledger_customerCode;
  String cashledger_date;
  String cashledger_description;
  String cashledger_documentNumber;
  String cashledger_amount;
  ///cheque Ledger
  String chequeledger_customerCode;
  String chequeledger_date;
  String chequeledger_description;
  String chequeledger_documentNumber;
  String chequeledger_chequeNumber;

  ///dues Ledger
  String duesLedger_vendorCode;
  String duesLedger_vendor;
  String duesLedger_registeredNumber;
  String duesLedger_reportDate;
  List<DuesLedgerDetails> duesDetails=[];
  LedgerModel();

  ///customer  ledger
  LedgerModel.customerLedgerDate(Map<String,dynamic> json){
    try{
      customerledger_customerCode=json["CUST_CODE"].toString();
      customerledger_date=json["REPORT_DATE"].toString();
      customerledger_customerName=json['CUSTOMER'];
      customerledger_customerRegisrationNumber=json['REGISTERED_NUMBERS'];
      customerledger_due=json['DUES'].toString();
      customerledger_nextdue=json['NEXT_DUE_AMOUNT'].toString();
      customerledger_nextdueDate=json['DUE_DATE'];
      customerledger_credit=json["CREDIT"].toString();
      customerledger_balance=json['BALANCE'].toString();
      for(var item in json['LEDGER']){
        ledgerDetails.add(CustomerLedgerDetails.fromJson(item));
      }
    }
    catch(e){
      print('exception in customer legder model is'+e.toString());
    }
  }
  ///cash ledger
  LedgerModel.cashLedgerDate(Map<String,dynamic> json){
    try{
      cashledger_customerCode=json["CUST_CODE"];
      cashledger_date=json["TR_DATE"];
      cashledger_description=json["DESCR"];
      cashledger_documentNumber=json["DOC_NO"].toString();
      cashledger_amount=json["AMOUNT"].toString();
    }
    catch(e){
      print('exception in cash legder model is'+e.toString());
    }
  }
  ///cheque ledger
  LedgerModel.chequeLedgerDate(Map<String,dynamic> json){
    try{
      chequeledger_customerCode=json['CUST_CODE'].toString();
      chequeledger_date=json['TR_DATE'].toString();
      chequeledger_description=json['DESCR'].toString();
      chequeledger_documentNumber=json['DOC_NO'].toString();
      chequeledger_chequeNumber=json['CHEQ'].toString();

    }
    catch(e){
      print('exception in cash legder model is'+e.toString());
    }
  }

  ///dues ledger
  LedgerModel.duesLedgerDate(Map<String,dynamic> json){
    try{
      duesLedger_vendorCode = json['VENDOR_CODE'];
      duesLedger_vendor = json['VENDOR'];
      duesLedger_registeredNumber = json['REGISTERED_NUMBERS'];
      duesLedger_reportDate = json['REPORT_DATE'];
      for(var item in json['LEDGER']){
        duesDetails.add(DuesLedgerDetails.fromJson(item));
      }
    }
    catch(e){
      print('exception duesLedgerDate: '+e.toString());
    }
  }

}
class CustomerLedgerDetails{
  String date;
  String tr;
  String particular;
  String quantity;
  String rate;
  String debit;
  String credit;
  String balance;

  CustomerLedgerDetails();

  CustomerLedgerDetails.fromJson(Map<String,dynamic> json){
    try{
      date=json['Date'].toString().substring(0,10);
      tr=json['TR'].toString();
      particular=json['PARTICULARS'].toString();
      quantity=json['QTY'].toString();
      rate=json['RATE'].toString();
      debit=json['DEBIT'].toString();
      credit=json['CREDIT'].toString();
      balance=json['BALANCE'].toString();
    }
    catch(e){
      print('Exception in CustomerLedgerDetails.fromJson is'+e.toString());
    }
  }
}

class DuesLedgerDetails{
  String date;
  String debit;
  String credit;
  String balance;
  String open;

  DuesLedgerDetails.fromJson(Map<String, dynamic> json){
    date = json['Date'].toString();
    debit = json['DEBIT'].toString();
    credit = json['CREDIT'].toString();
    open = json['OPENING'].toString();
    balance = json['BALANCE'].toString();
  }
}