class UserAllDataModel {
  List<Results> results;

  UserAllDataModel({this.results});

  UserAllDataModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
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
  String cATEGORY;
  String cUSTCODE;
  String cUSTOMER;
  String aDDRESS;
  String oWNER;
  double lATITUDE;
  double lONGITUDE;
  String lASTVISTDAYS;
  String lASTTRANSDAYS;
  String dUES;
  String oUTSTANDING;
  String  eMPNO;
  String sALESMAN;
  String aREACODE;
  String aREANAME;
  String sHOPASSIGNED;
  String aPPALLOWED;
  String tOTALDEBIT;
  String tOTALCREDIT;
  String cONTACT1;
  String cONTACT2;
  String pHONE1;
  String pHONE2;
  List<DATA> dATA;

  Results(
      {this.cATEGORY,
        this.cUSTCODE,
        this.cUSTOMER,
        this.aDDRESS,
        this.oWNER,
        this.lATITUDE,
        this.lONGITUDE,
        this.lASTVISTDAYS,
        this.lASTTRANSDAYS,
        this.dUES,
        this.oUTSTANDING,
        this.eMPNO,
        this.sALESMAN,
        this.aREACODE,
        this.aREANAME,
        this.sHOPASSIGNED,
        this.aPPALLOWED,
        this.tOTALDEBIT,
        this.tOTALCREDIT,
        this.cONTACT1,
        this.cONTACT2,
        this.pHONE1,
        this.pHONE2,
        this.dATA});

  Results.fromJson(Map<String, dynamic> json) {
    cATEGORY = json['CATEGORY'];
    cUSTCODE = json['CUST_CODE'];
    cUSTOMER = json['CUSTOMER'];
    aDDRESS = json['ADDRESS'];
    oWNER = json['OWNER'];
    lATITUDE = json['LATITUDE'];
    lONGITUDE = json['LONGITUDE'];
    lASTVISTDAYS = json['LAST_VIST_DAYS'].toString();
    lASTTRANSDAYS = json['LAST_TRANS_DAYS'].toString();
    dUES = json['DUES'].toString();
    oUTSTANDING = json['OUTSTANDING'].toString();
    eMPNO = json['EMPNO'];
    sALESMAN = json['SALESMAN'];
    aREACODE = json['AREA_CODE'];
    aREANAME = json['AREANAME'];
    sHOPASSIGNED = json['SHOPASSIGNED'];
    aPPALLOWED = json['APP_ALLOWED'];
    tOTALDEBIT = json['TOTAL_DEBIT'].toString();
    tOTALCREDIT = json['TOTAL_CREDIT'].toString();
    cONTACT1 = json['CONTACT1'];
    cONTACT2 = json['CONTACT2'];
    pHONE1 = json['PHONE1'];
    pHONE2 = json['PHONE2'];
    if (json['DATA'] != null) {
      dATA = <DATA>[];
      json['DATA'].forEach((v) {
        dATA.add(new DATA.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CATEGORY'] = this.cATEGORY;
    data['CUST_CODE'] = this.cUSTCODE;
    data['CUSTOMER'] = this.cUSTOMER;
    data['ADDRESS'] = this.aDDRESS;
    data['OWNER'] = this.oWNER;
    data['LATITUDE'] = this.lATITUDE;
    data['LONGITUDE'] = this.lONGITUDE;
    data['LAST_VIST_DAYS'] = this.lASTVISTDAYS;
    data['LAST_TRANS_DAYS'] = this.lASTTRANSDAYS;
    data['DUES'] = this.dUES;
    data['OUTSTANDING'] = this.oUTSTANDING;
    data['EMPNO'] = this.eMPNO;
    data['SALESMAN'] = this.sALESMAN;
    data['AREA_CODE'] = this.aREACODE;
    data['AREANAME'] = this.aREANAME;
    data['SHOPASSIGNED'] = this.sHOPASSIGNED;
    data['APP_ALLOWED'] = this.aPPALLOWED;
    data['TOTAL_DEBIT'] = this.tOTALDEBIT;
    data['TOTAL_CREDIT'] = this.tOTALCREDIT;
    data['CONTACT1'] = this.cONTACT1;
    data['CONTACT2'] = this.cONTACT2;
    data['PHONE1'] = this.pHONE1;
    data['PHONE2'] = this.pHONE2;
    if (this.dATA != null) {
      data['DATA'] = this.dATA.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DATA {
  String kEY;
  String vALUE;

  DATA({this.kEY, this.vALUE});

  DATA.fromJson(Map<String, dynamic> json) {
    kEY = json['KEY'];
    vALUE = json['VALUE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['KEY'] = this.kEY;
    data['VALUE'] = this.vALUE;
    return data;
  }
}
