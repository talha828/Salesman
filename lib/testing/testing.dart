import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

class Testing extends StatefulWidget {
  const Testing({Key key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("text"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          var data=await rootBundle.loadString("assets/excel/offer_2.json");
          List<Map<String, dynamic>> jsonDataList = jsonDecode(data).cast<Map<String, dynamic>>();
          List<Pin> pinList = jsonDataList.map((jsonData) => Pin.fromJson(jsonData)).toList();
          print(pinList.length);
          int j=0;
          for(int i=0;i<39;i++){
            String mrp=pinList[i].mrp.toString() == "NIL"?"":pinList[i].mrp;
            String expire=pinList[i].expiry.toString() == "NIL"?"":pinList[i].expiry;
            // print(pinList[i].prodCode);
            Uri url=Uri.parse("http://api.visionsoft-pk.com:8181/ords/skr2/app/postoffers?pin_cmp=20&pin_kp=A&pin_keyword1=6731&pin_keyword2=U09Z&pin_userid=${pinList[i].userid}&pin_password=${pinList[i].password}&pin_cust_code=${pinList[i].custCode}&pin_prod_code=${pinList[i].prodCode}&pin_rate=${pinList[i].rate}&pin_qty=${pinList[i].qty}&pin_mrp=${mrp}&pin_expiry=${expire}&pin_latitude=123&pin_longitude=456");
          var response=await http.post(url);
          print("${response.statusCode}  $j");
          j++;
          }
        },
        child: Icon(Icons.add),
      ),
      body: Container(),
    );
  }
}


class Pin {
  final String cmp;
  final String kp;
  final String keyword1;
  final String keyword2;
  final String userid;
  final String password;
  final String custCode;
  final String prodCode;
  final String rate;
  final String qty;
  final String mrp;
  final String expiry;

  Pin({
     this.cmp,
     this.kp,
     this.keyword1,
     this.keyword2,
     this.userid,
     this.password,
     this.custCode,
     this.prodCode,
     this.rate,
     this.qty,
     this.mrp,
     this.expiry,
  });

  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
      cmp: json['pin_cmp'],
      kp: json['pin_kp'],
      keyword1: json['pin_keyword1'],
      keyword2: json['pin_keyword2'],
      userid: json['pin_userid'],
      password: json['pin_password'],
      custCode: json['pin_cust_code'],
      prodCode: json['pin_prod_code'],
      rate:json['pin_rate'].toString(),
      qty: json['pin_qty'].toString(),
      mrp: json['pin_mrp'].toString(),
      expiry: json['pin_expiry'].toString(),
    );
  }
}