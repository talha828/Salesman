import 'package:flutter/cupertino.dart';

class AddToCartModel extends ChangeNotifier {
  List<NewCartModel> cart = [];

  createCart({
    String productCode,
    String name,
    int qty,
    double rate,
    double amount,
    String tr,
    bool isChange,
  }) {
    cart.add(NewCartModel(
      productCode: productCode,
      name: name,
      qty: qty,
      rate: rate,
      amount: amount,
      tr: tr,
      isChange: isChange,
    ));
    notifyListeners();
  }

  cartUpdate({String tr, int qty}) {
    if(qty != 0){
      cart.forEach((element) {
        if (element.tr == tr) {
          element.qty = qty;
          element.amount = qty * element.rate;
        }
      });
    }else
    {
      cart.removeWhere((element) => element.productCode == tr);
    }
    notifyListeners();
  }
  cartClear(){
    cart.clear();
  }
}

class NewCartModel {
  String productCode;
  String name;
  int qty;
  double rate;
  double amount;
  String tr;
  bool isChange;
  NewCartModel(
      {this.productCode,
      this.qty,
      this.amount,
      this.rate,
      this.name,
      this.tr,
      this.isChange});
}
