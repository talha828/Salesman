import 'package:flutter/material.dart';

class Product {
  List<Results> results;

  Product({this.results});

  Product.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String pRODCODE;
  String pRODUCT;
  String tYPEID;
  String iTEMTYPE;
  String mAINID;
  String mAINTYPE;
  String bRAND;
  String mODEL;
  String dESCRIPTION;
  String pROMOTIONAL;
  String iMAGEURL;
  String oUTOFSTOCK;
  String sHOWINAPP;
  String oFFERITEM;
  List<PRICE> pRICE;

  Results(
      {this.pRODCODE,
        this.pRODUCT,
        this.tYPEID,
        this.iTEMTYPE,
        this.mAINID,
        this.mAINTYPE,
        this.bRAND,
        this.mODEL,
        this.dESCRIPTION,
        this.pROMOTIONAL,
        this.iMAGEURL,
        this.oUTOFSTOCK,
        this.sHOWINAPP,
        this.oFFERITEM,
        this.pRICE});

  Results.fromJson(Map<String, dynamic> json) {
    pRODCODE = json['PROD_CODE'];
    pRODUCT = json['PRODUCT'];
    tYPEID = json['TYPE_ID'];
    iTEMTYPE = json['ITEMTYPE'];
    mAINID = json['MAIN_ID'];
    mAINTYPE = json['MAIN_TYPE'];
    bRAND = json['BRAND'];
    mODEL = json['MODEL'];
    dESCRIPTION = json['DESCRIPTION'];
    pROMOTIONAL = json['PROMOTIONAL'];
    iMAGEURL = json['IMAGE_URL'];
    oUTOFSTOCK = json['OUTOFSTOCK'];
    sHOWINAPP = json['SHOWINAPP'];
    oFFERITEM = json['OFFER_ITEM'];
    if (json['PRICE'] != null) {
      pRICE = new List<PRICE>();
      json['PRICE'].forEach((v) {
        pRICE.add(new PRICE.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PROD_CODE'] = this.pRODCODE;
    data['PRODUCT'] = this.pRODUCT;
    data['TYPE_ID'] = this.tYPEID;
    data['ITEMTYPE'] = this.iTEMTYPE;
    data['MAIN_ID'] = this.mAINID;
    data['MAIN_TYPE'] = this.mAINTYPE;
    data['BRAND'] = this.bRAND;
    data['MODEL'] = this.mODEL;
    data['DESCRIPTION'] = this.dESCRIPTION;
    data['PROMOTIONAL'] = this.pROMOTIONAL;
    data['IMAGE_URL'] = this.iMAGEURL;
    data['OUTOFSTOCK'] = this.oUTOFSTOCK;
    data['SHOWINAPP'] = this.sHOWINAPP;
    data['OFFER_ITEM'] = this.oFFERITEM;
    if (this.pRICE != null) {
      data['PRICE'] = this.pRICE.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PRICE {
  int tR;
  String eNTRYDATE;
  String sTATUS;
  String cUSTCODE;
  String cUSTOMER;
  double rATE;
  int qTY;
  int count;
  String mRP;
  String eXPIRE;
  double sELLINGPRICE;
  String eNTRYBY;
  int oRDERS;
  int bALANCE;
  TextEditingController text;
  int pURQTY;
  int pURBALANCE;

  PRICE(
      {this.tR,
        this.eNTRYDATE,
        this.sTATUS,
        this.cUSTCODE,
        this.cUSTOMER,
        this.rATE,
        this.qTY,
        this.mRP,
        this.eXPIRE,
        this.count,
        this.sELLINGPRICE,
        this.eNTRYBY,
        this.oRDERS,
        this.bALANCE,
        this.text,
        this.pURQTY,
        this.pURBALANCE});

  PRICE.fromJson(Map<String, dynamic> json) {
    tR = json['TR'];
    eNTRYDATE = json['ENTRY_DATE'];
    sTATUS = json['STATUS'];
    cUSTCODE = json['CUST_CODE'];
    cUSTOMER = json['CUSTOMER'];
    rATE = json['RATE'] == null ?0.00:double.parse(json['RATE'].toString());
    qTY = json['QTY'];
    mRP = json['MRP'].toString();
    sELLINGPRICE = json['SELLING_PRICE']==null?0.0:double.parse(json['SELLING_PRICE'].toString());
    eNTRYBY = json['ENTRY_BY'];
    oRDERS = json['ORDERS'];
    bALANCE = json['BALANCE'];
    eXPIRE = json['EXPIRY'];
    count = 0;
    text= TextEditingController(text: "0");
    pURQTY = json['PUR_QTY'];
    pURBALANCE = json['PUR_BALANCE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TR'] = this.tR;
    data['ENTRY_DATE'] = this.eNTRYDATE;
    data['STATUS'] = this.sTATUS;
    data['CUST_CODE'] = this.cUSTCODE;
    data['CUSTOMER'] = this.cUSTOMER;
    data['RATE'] = this.rATE;
    data['QTY'] = this.qTY;
    data['MRP'] = this.mRP;
    data['SELLING_PRICE'] = this.sELLINGPRICE;
    data['ENTRY_BY'] = this.eNTRYBY;
    data['ORDERS'] = this.oRDERS;
    data['BALANCE'] = this.bALANCE;
    data['PUR_QTY'] = this.pURQTY;
    data['PUR_BALANCE'] = this.pURBALANCE;
    return data;
  }
}
