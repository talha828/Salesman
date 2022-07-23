class DeliveryDetails {
  String cUSTCODE;
  String cUSTOMER;
  String nICKNAME;
  String cONTMOBILE;
  String cONTACTPERSON;
  String lONGITUDE;
  String lATITUDE;
  double cREDITLIMIT;
  double oRDERNO;
  String oRDERDATE;
  String sALESMAN;
  double sUBTOTAL;

  DeliveryDetails(
      {this.cUSTCODE,
        this.cUSTOMER,
        this.nICKNAME,
        this.cONTMOBILE,
        this.cONTACTPERSON,
        this.lONGITUDE,
        this.lATITUDE,
        this.cREDITLIMIT,
        this.oRDERNO,
        this.oRDERDATE,
        this.sALESMAN,
        this.sUBTOTAL});

  DeliveryDetails.fromJson(Map<String, dynamic> json) {
    cUSTCODE = json['CUST_CODE'];
    cUSTOMER = json['CUSTOMER'];
    nICKNAME = json['NICK_NAME'];
    cONTMOBILE = json['CONT_MOBILE'];
    cONTACTPERSON = json['CONTACT_PERSON'];
    lONGITUDE = json['LONGITUDE'];
    lATITUDE = json['LATITUDE'];
    cREDITLIMIT =json['CREDIT_LIMIT']==null? 0.0:double.parse(json['CREDIT_LIMIT'].toString());
    oRDERNO = double.parse(json['ORDER_NO'].toString());
    oRDERDATE = json['ORDERDATE'];  
    sALESMAN = json['SALESMAN'];
    sUBTOTAL = double.parse(json['SUB_TOTAL'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CUST_CODE'] = this.cUSTCODE;
    data['CUSTOMER'] = this.cUSTOMER;
    data['NICK_NAME'] = this.nICKNAME;
    data['CONT_MOBILE'] = this.cONTMOBILE;
    data['CONTACT_PERSON'] = this.cONTACTPERSON;
    data['LONGITUDE'] = this.lONGITUDE;
    data['LATITUDE'] = this.lATITUDE;
    data['CREDIT_LIMIT'] = this.cREDITLIMIT;
    data['ORDER_NO'] = this.oRDERNO;
    data['ORDERDATE'] = this.oRDERDATE;
    data['SALESMAN'] = this.sALESMAN;
    data['SUB_TOTAL'] = this.sUBTOTAL;
    return data;
  }
}