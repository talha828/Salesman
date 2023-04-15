class ProductSearchModel {
  List<Results> results;

  ProductSearchModel({this.results});

  ProductSearchModel.fromJson(Map<String, dynamic> json) {
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

class Results{
  String productName;
  String productCode;
  String image;
  String offerItem;
  String description;
  Results({this.productCode,this.productName,this.image,this.offerItem});

  Results.fromJson(Map<String, dynamic> json) {
    productName =json['PRODUCT'];
    productCode =json['PROD_CODE'];
    image =json['IMAGE_URL'];
    offerItem =json['OFFER_ITEM'];
    description =json['DESCRIPTION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PROD_CODE'] = this.productCode;
    data['PRODUCT'] = this.productName;
    data['IMAGE_URL']=this.image;
    data['OFFER_ITEM']=this.offerItem;
    data['DESCRIPTION']=this.description;
  }
}


