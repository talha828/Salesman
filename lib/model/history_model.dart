import 'package:flutter/cupertino.dart';
import 'package:salesmen_app_new/model/product_model.dart';
class OrderModel extends ChangeNotifier{
  String shopname;
  String orderid;
  String image;
  String status;
  String time;
  String subtotal;
  String personname;
  String bookingtime;
  String phoneno;
  List<ProductModel> product=[];
  String date;


  OrderModel({
  this.shopname,
  this.orderid,
    this.image,
  this.status,
  this.time,
  this.subtotal,
  this.personname,
    this.phoneno,
    this.product,
    this.bookingtime,
    this.date
  });
  OrderModel.fromModel(Map<String,dynamic>json,String date){
    try{
      shopname=json['shopname'];
      image=json['image'];
      orderid=json['orderid'];
      status=json['status'];
      time=json['time'];
      subtotal=json['subtotal'];
      personname=json['personname'];
      bookingtime=json['bookingtime'];
      phoneno=json['phoneno'];
      this.date=date;

      for(var item in json['product']){
        print('dkkdk'+item['name'].toString());
        product.add( ProductModel(name: item['name'],productCode: item['quantity'],price: item['price']));

      }

    }
    catch(e){
      print("HistoryModel.fromModel exception is:"+e.toString());
    }
  }
}