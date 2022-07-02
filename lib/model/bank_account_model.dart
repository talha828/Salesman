class BankAccountModel{
  String bankName;
  String accountTitle;
  String accountNumber;
  String balance;
  BankAccountModel();
  BankAccountModel.fromJson(Map<String,dynamic>json){
    try{
      bankName=json['BANKNAME'];
      accountTitle=json['ACCOUNT_TITLE'];
      accountNumber=json['ACCOUNT_NO'];
      balance=json['BALANCE'].toString();
    }
    catch(e){
      print('exception in bank model is'+e.toString());
    }
  }
}