class MechanicModel {
  int id;
  String name;
  String phone;
  String cnic;
  String picture;
  int customerId;
  int addedBy;
  double latitude;
  double longitude;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  MechanicModel(
      {this.id,
        this.name,
        this.phone,
        this.cnic,
        this.picture,
        this.customerId,
        this.addedBy,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  MechanicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    cnic = json['cnic'];
    picture = json['picture'];
    customerId = json['customer_id'];
    addedBy = json['added_by'];
    latitude = double.parse(json['latitude'].toString());
    longitude = double.parse(json['longitude'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['cnic'] = this.cnic;
    data['picture'] = this.picture;
    data['customer_id'] = this.customerId;
    data['added_by'] = this.addedBy;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
