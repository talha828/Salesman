class HistoryModel{
  String purpose;
  String datetime;
  String shopName;
  String amount;

  HistoryModel.fromJson(Map<String,dynamic> json){
    try{
      purpose=json['PURPOSE'];
      datetime=json['DATETIME'];
      shopName=json['CUSTOMER'];
      amount=json['AMOUNT'].toString()??'';
    }
    catch(e){
      print('exception in history model is'+e.toString());
    }
  }

}