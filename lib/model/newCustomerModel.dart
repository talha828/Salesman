class CustomerInfo {
  String cUSTCODE;
  String cUSTOMER;
  String cONTACTPERSON;
  String cONTACTPERSON2;
  String pHONE1;
  String pHONE2;
  String lONGITUDE;
  String lATITUDE;
  String cATCD;
  String pARTYCATEGORY;
  String aDDRESS;
  String eDITABLE;
  String aCTIVE;
  String sHOPASSIGNED;
  String bALANCE;
  String lASTDAYS;



  CustomerInfo(
      {this.cUSTCODE,
        this.cUSTOMER,
        this.cONTACTPERSON,
        this.cONTACTPERSON2,
        this.pHONE1,
        this.pHONE2,
        this.lONGITUDE,
        this.lATITUDE,
        this.cATCD,
        this.pARTYCATEGORY,
        this.aDDRESS,
        this.eDITABLE,
        this.aCTIVE,
        this.sHOPASSIGNED,
        this.bALANCE,
        this.lASTDAYS
      });

  CustomerInfo.fromJson(Map<String, dynamic> json ) {
    cUSTCODE = json['CUST_CODE'];
    cUSTOMER = json['CUSTOMER'];
    cONTACTPERSON = json['CONTACT_PERSON'];
    cONTACTPERSON2 = json['CONTACT_PERSON2'];
    pHONE1 = json['PHONE1'];
    pHONE2 = json['PHONE2'];
    lONGITUDE = json['LONGITUDE'];
    lATITUDE = json['LATITUDE'];
    cATCD = json['CAT_CD'];
    pARTYCATEGORY = json['PARTY_CATEGORY'];
    aDDRESS = json['ADDRESS'];
    eDITABLE = json['EDITABLE'];
    aCTIVE = json['ACTIVE'];
    sHOPASSIGNED = json['SHOPASSIGNED'];
    bALANCE = json['BALANCE'].toString();
    lASTDAYS= json['LAST_DAYS'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CUST_CODE'] = this.cUSTCODE;
    data['CUSTOMER'] = this.cUSTOMER;
    data['CONTACT_PERSON'] = this.cONTACTPERSON;
    data['CONTACT_PERSON2'] = this.cONTACTPERSON2;
    data['PHONE1'] = this.pHONE1;
    data['PHONE2'] = this.pHONE2;
    data['LONGITUDE'] = this.lONGITUDE;
    data['LATITUDE'] = this.lATITUDE;
    data['CAT_CD'] = this.cATCD;
    data['PARTY_CATEGORY'] = this.pARTYCATEGORY;
    data['ADDRESS'] = this.aDDRESS;
    data['EDITABLE'] = this.eDITABLE;
    data['ACTIVE'] = this.aCTIVE;
    data['SHOPASSIGNED'] = this.sHOPASSIGNED;
    data['BALANCE'] = this.bALANCE;
    return data;
  }
}
