import 'package:flutter/cupertino.dart';
import 'package:salesmen_app_new/model/product_model.dart';
import 'customerModel.dart';


class CustomerList extends ChangeNotifier{
  List<CustomerModel>customerData=[];
  List<CustomerModel>dues=[];
  List<CustomerModel>assign=[];
  List<ProductModel>product=[];
  List<Widget> imageContainer=[];
  List<ProductModel>searchProduct=[];
  CustomerModel singleCustomer=CustomerModel();

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
    notifyListeners();
  }
  void sliderPicture(List<Widget> value){
    imageContainer.addAll(value);
    notifyListeners();
  }
  void getAssignShop(List<CustomerModel> value){
    for(var i in value){
      if(i.shopAssigned=="Yes"){
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
    dues.clear();
    assign.clear();
    notifyListeners();
  }
  void clearSliderImage(){
    imageContainer.clear();
  }
  void clearProductList(){
    product.clear();
  }
  void addSearchProduct(List<ProductModel> value){
    searchProduct.addAll(value);
  }
}