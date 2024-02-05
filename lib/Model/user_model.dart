class UserModel {
  String? id;
  String? name;
  String? email;
  String? mobile;
  String? type;
  String? city;
  String? state;
  String? password;
  String? isVerified;
  String? rcCard;
  String? licence;
  String? status;
  String? otp;
  String? fcmId;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  String? address;
  String? proPic;
  String? wallet;

  UserModel(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.type,
        this.city,
        this.state,
        this.password,
        this.isVerified,
        this.rcCard,
        this.licence,
        this.status,
        this.otp,
        this.fcmId,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.updatedAt,
        this.address,
        this.proPic,
        this.wallet
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    type = json['type'];
    city = json['city'];
    state = json['state'];
    password = json['password'];
    isVerified = json['is_verified'];
    rcCard = json['rc_card'];
    licence = json['licence'];
    status = json['status'];
    otp = json['otp'];
    fcmId = json['fcm_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    address = json['address'];
    proPic = json['pro_pic'];
    wallet=json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['type'] = this.type;
    data['city'] = this.city;
    data['state'] = this.state;
    data['password'] = this.password;
    data['is_verified'] = this.isVerified;
    data['rc_card'] = this.rcCard;
    data['licence'] = this.licence;
    data['status'] = this.status;
    data['otp'] = this.otp;
    data['fcm_id'] = this.fcmId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['address'] = this.address;
    data['pro_pic'] = this.proPic;
    data['wallet']=this.wallet;
    return data;
  }
}
