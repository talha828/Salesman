import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:salesmen_app_new/model/box_model.dart';
import 'package:salesmen_app_new/model/delivery_model.dart';
import 'package:salesmen_app_new/model/newCustomerModel.dart';
import 'package:salesmen_app_new/model/product_model.dart';
import 'package:get/get.dart';
import 'customerModel.dart';

class CustomerList extends ChangeNotifier{
  //loader
  bool loading =false;
  //customer list
  List<CustomerInfo>customerData=[];
  List<CustomerInfo>dues=[];
  List<CustomerInfo>assign=[];
  // main product list or category
  List<ProductModel>product=[];
  List<ProductModel>searchProduct=[];
  // slider image
  List<Widget> imageContainer=[];
  CustomerModel singleCustomer=CustomerModel();
  //delivery list
  List<DeliveryModel> delivery =[];
  List<BoxModel>boxDelivery=[];
  List<DeliveryModel>fulldeliveryDetails=[];
  List initialCount=[];
  // store json response
  Map<String,dynamic> response={};
  // product list
  List<List<ProductModel>> pp=[];

  String address="Searching...";
  void getAllCustomer(List<CustomerInfo> value){
    customerData.clear();
    customerData.addAll(value);
    notifyListeners();
  }
  void updateAddress(String value){
    address=value;
    notifyListeners();
  }
  void getDues(List<CustomerInfo> value){
    dues.clear();
    for (var i in value){
      if(i.sHOPASSIGNED=="Yes"){
        if(double.parse(i.bALANCE)>0.00){
          dues.add(i);
        }
      }
    }
    for(int i=0; i < dues.length-1; i++){
      for(int j=0; j < dues.length-i-1; j++){
        if(double.parse(dues[j].bALANCE) > double.parse(dues[j+1].bALANCE)){
          CustomerInfo temp = dues[j];
          dues[j] = dues[j+1];
          dues[j+1] = temp;
        }
      }
    }
    notifyListeners();
  }
  void sliderPicture(List<Widget> value){
    imageContainer.addAll(value);
    notifyListeners();
  }
  void getAssignShop(List<CustomerInfo> value){
    assign.clear();
    for(var i in value){
      if(i.sHOPASSIGNED=="Yes"){
        assign.add(i);
      }
    }
    notifyListeners();
  }
  void addProduct(List<ProductModel> value){
    product.addAll(value);
    notifyListeners();
  }
  void myCustomer(CustomerModel value){
    singleCustomer=value;
    notifyListeners();
  }
  void clearList(){
    customerData.clear();
    //dues.clear();
    assign.clear();
    notifyListeners();
  }
  void clearSliderImage(){
    imageContainer.clear();
  }
  void clearProductList(){
    product.clear();
  }
  void clearProductSearchList(){
    searchProduct.clear();
  }
  void addSearchProduct(List<ProductModel> value){
    searchProduct.addAll(value);
  }
  void addDelivery(List<DeliveryModel> value){
    delivery.addAll(value);
  }
  void addBoxDelivery(List<BoxModel> value){
    boxDelivery.addAll(value);
  }
  void addFullDeliveryDetails(List<DeliveryModel> value){
    fulldeliveryDetails.addAll(value);
  }
  void addInitialCount(List value){
    initialCount.addAll(value);
  }
  // void addNewCustomer(CustomerModel value){
  //   customerData.insert(0,value);
  //   assign.insert(0,value);
  // }
  void setLoading(bool value){
    loading=value;
  }
  void storeResponse(Map<String,dynamic>value){
    response.addAll(value);
  }
  void addProductItem(List<List<ProductModel>> value){
    pp.addAll(value);
  }
  void updateList(Coordinates userLocation ){
    List<CustomerInfo>customer=[];
    for (var item in response["results"]){
      var dist=calculateDistance(double.parse(item["LATITUDE"].toString()=="null"?1.toString():item["LATITUDE"].toString()), double.parse(item["LONGITUDE"].toString()=="null"?1.toString():item["LONGITUDE"].toString()),userLocation.latitude,userLocation.longitude);
      customer.add(CustomerInfo.fromJson(item,dist));
    }
    //customer.sort((a,b)=>a.distance.compareTo(b.distance));
    getAllCustomer(customer);
    getDues(customer);
    getAssignShop(customer);
    notifyListeners();
  }
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}

class CheckAllProducts extends GetxController{
  var myProducts=[].obs;
  var searchList=[].obs;
  var cartList=[].obs;
  var indexList=[].obs;
  var difference=false.obs;
}