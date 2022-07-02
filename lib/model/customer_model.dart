import 'package:flutter/cupertino.dart';

class CustomerModel extends ChangeNotifier{
  int id;
  String custRegDate;
  int custStatus;
  int custEditable;
  int custParentCheck;
  int custCode;
  String custName;
  String custOldCode;
  String custPrimNb;
  String custPrimName;
  String custPrimPass;
  String custPrimApp;
  String custAddress;
  String cnic;
  int countryId;
  int provId;
  int cityId;
  int areaId;
  String marketId;
  int custcatId;
  int custtypeId;
  int custclassId;
  double custMinCredit;
  double custMaxCredit;
  double custCreditCheck;
  String parentId;
  String warehouseCode;
  int addedBy;
  String contactPerson2;
  String phone2;
  String contactPerson3;
  String phone3;
  String cnicExp;
  double lat;
  double long;
  int paymentTerm;
  String salemanName;
  double cr30Days;
  double cr90Days;
  double cr180Days;
  double ntn;
  double balance;
  UserData userData;
  double distances;

  CustomerModel(
      {this.id,
        this.custRegDate,
        this.custStatus,
        this.custEditable,
        this.custParentCheck,
        this.custCode,
        this.custName,
        this.custOldCode,
        this.custPrimNb,
        this.custPrimName,
        this.custPrimPass,
        this.custPrimApp,
        this.custAddress,
        this.cnic,
        this.countryId,
        this.provId,
        this.cityId,
        this.areaId,
        this.marketId,
        this.custcatId,
        this.custtypeId,
        this.custclassId,
         this.custMinCredit,
         this.custMaxCredit,
         this.custCreditCheck,
        this.parentId,
        this.warehouseCode,
        this.addedBy,
        this.contactPerson2,
        this.phone2,
        this.contactPerson3,
        this.phone3,
        this.cnicExp,
         this.lat,
         this.long,
        this.paymentTerm,
        this.salemanName,
        this.cr30Days,
        this.cr90Days,
        this.cr180Days,
        this.ntn,
         this.balance,
        this.userData,
       this.distances
      });

  CustomerModel.fromJson(Map<String, dynamic> json,double dist) {
    id = json['id'];
    custRegDate = json['cust_reg_date'];
    custStatus = json['cust_status'];
    custEditable = json['cust_editable'];
    custParentCheck = json['cust_parent_check'];
    custCode = json['cust_code'];
    custName = json['cust_name'];
    custOldCode = json['cust_old_code'];
    custPrimNb = json['cust_prim_nb'];
    custPrimName = json['cust_prim_name'];
    custPrimPass = json['cust_prim_pass'];
    custPrimApp = json['cust_prim_app'];
    custAddress = json['cust_address'];
    cnic = json['cnic'];
    countryId = json['country_id'];
    provId = json['prov_id'];
    cityId = json['city_id'];
    areaId = json['area_id'];
    marketId = json['market_id'];
    custcatId = json['custcat_id'];
    custtypeId = json['custtype_id'];
    custclassId = json['custclass_id'];
    custMinCredit = double.parse(json['cust_min_credit']==null?"0.0":json['cust_min_credit'].toString());
    custMaxCredit = double.parse(json['cust_max_credit']==null?"0.0":json['cust_max_credit'].toString());
    custCreditCheck = double.parse(json['cust_credit_check']==null?"0.0":json['cust_credit_check'].toString());
    parentId = json['parent_id'];
    warehouseCode = json['warehouse_code'];
    addedBy = json['added_by'];
    contactPerson2 = json['contact_person2'];
    phone2 = json['phone2'];
    contactPerson3 = json['contact_person3'];
    phone3 = json['phone3'];
    cnicExp = json['cnic_exp'];
    lat = json['lat']==null?double.parse("0.0"):double.parse(json['lat'].toString());
    long = json['long']==null?double.parse("0.0"):double.parse(json['long'].toString());
    paymentTerm = json['payment_term'];
    salemanName = json['saleman_name'];
    cr30Days = double.parse(json['cr_30_days']==null?"0.0":json['cr_30_days'].toString());
    cr90Days =double.parse( json['cr_90_days']==null?"0.0":json['cr_90_days'].toString());
    cr180Days = double.parse(json['cr_180_days']==null?"0.0":json['cr_180_days'].toString());
    ntn = double.parse(json['ntn'].toString()=="NULL"||json['ntn']==null?"0.0":json['ntn'].toString());
    balance = double.parse(json['balance']==null||json['balance'].toString()=="NULL"?"0":json['balance'].toString());
    distances=dist;
    userData = json['user_data'] != null
        ? new UserData.fromJson(json['user_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cust_reg_date'] = this.custRegDate;
    data['cust_status'] = this.custStatus;
    data['cust_editable'] = this.custEditable;
    data['cust_parent_check'] = this.custParentCheck;
    data['cust_code'] = this.custCode;
    data['cust_name'] = this.custName;
    data['cust_old_code'] = this.custOldCode;
    data['cust_prim_nb'] = this.custPrimNb;
    data['cust_prim_name'] = this.custPrimName;
    data['cust_prim_pass'] = this.custPrimPass;
    data['cust_prim_app'] = this.custPrimApp;
    data['cust_address'] = this.custAddress;
    data['cnic'] = this.cnic;
    data['country_id'] = this.countryId;
    data['prov_id'] = this.provId;
    data['city_id'] = this.cityId;
    data['area_id'] = this.areaId;
    data['market_id'] = this.marketId;
    data['custcat_id'] = this.custcatId;
    data['custtype_id'] = this.custtypeId;
    data['custclass_id'] = this.custclassId;
    data['cust_min_credit'] = this.custMinCredit;
    data['cust_max_credit'] = this.custMaxCredit;
    data['cust_credit_check'] = this.custCreditCheck;
    data['parent_id'] = this.parentId;
    data['warehouse_code'] = this.warehouseCode;
    data['added_by'] = this.addedBy;
    data['contact_person2'] = this.contactPerson2;
    data['phone2'] = this.phone2;
    data['contact_person3'] = this.contactPerson3;
    data['phone3'] = this.phone3;
    data['cnic_exp'] = this.cnicExp;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['payment_term'] = this.paymentTerm;
    data['saleman_name'] = this.salemanName;
    data['cr_30_days'] = this.cr30Days;
    data['cr_90_days'] = this.cr90Days;
    data['cr_180_days'] = this.cr180Days;
    data['ntn'] = this.ntn;
    data['balance'] = this.balance;
    if (this.userData != null) {
      data['user_data'] = this.userData.toJson();
    }
    return data;
  }
}

class UserData {
  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String image;
  int isActive;
  int appLogin;
  int webLogin;
  String createdAt;
  String updatedAt;

  UserData(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.image,
        this.isActive,
        this.appLogin,
        this.webLogin,
        this.createdAt,
        this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    isActive = json['is_active'];
    appLogin = json['app_login'];
    webLogin = json['web_login'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['app_login'] = this.appLogin;
    data['web_login'] = this.webLogin;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
