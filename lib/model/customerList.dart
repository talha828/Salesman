import 'package:flutter/cupertino.dart';
import 'customerModel.dart';


class CustomerList extends ChangeNotifier{
  List<CustomerModel>customerData=[];
  List<CustomerModel>dues=[];
  List<CustomerModel>assign=[];
  String address="Searching...";
  void add(List<CustomerModel> value){
    customerData.addAll(value);
    notifyListeners();
  }
  void updateAddress(String value){
    address=value;
    notifyListeners();
  }
  void getDues(List<CustomerModel> value){
    for (var i in value){
      if(i.shopAssigned=="Yes"){
        if(double.parse(i.dues)>0.00){
          dues.add(i);
        }
      }
    }
  }
  void getAssignShop(List<CustomerModel> value){
    for(var i in value){
      if(i.shopAssigned=="Yes"){
        assign.add(i);
      }
    }
  }
  void clearList(){
    customerData.clear();
    dues.clear();
    assign.clear();
  }
}