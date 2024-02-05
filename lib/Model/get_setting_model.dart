class GetSettingModel {
  String? responseCode;
  String? msg;
  List<Data>? data;

  GetSettingModel({this.responseCode, this.msg, this.data});

  GetSettingModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? nServerKey;
  String? sSecretKey;
  String? sPublicKey;
  String? rSecretKey;
  String? rPublicKey;
  String? twitterUrl;
  String? likendInUrl;
  String? instaramUrl;
  String? facebookUrl;
  String? address;
  String? email;
  String? contactNo;
  String? perKmCharge;
  String? gstCharge;
  String? rideGstCharge;
  String? parcelGstCharge;
  String? radius;
  String? advancedAmount;
  String? youtubeUrl;
  String? appStoreUrl;
  String? playStoreUrl;
  String? handyManStatus;
  String? eventStatus;
  String? event;
  String? handy;
  String? parcelDeliveryStatus;
  String? mehndiGstCharge;
  String? twoWheeler;
  String? threeWheeler;
  String? fourWheeler;
  String? foodDriverGst;
  Null? map;
  String? handyFixedAmount;
  String? footerData;
  String? mapKey;
  String? googleKey;

  Data(
      {this.id,
        this.nServerKey,
        this.sSecretKey,
        this.sPublicKey,
        this.rSecretKey,
        this.rPublicKey,
        this.twitterUrl,
        this.likendInUrl,
        this.instaramUrl,
        this.facebookUrl,
        this.address,
        this.email,
        this.contactNo,
        this.perKmCharge,
        this.gstCharge,
        this.rideGstCharge,
        this.parcelGstCharge,
        this.radius,
        this.advancedAmount,
        this.youtubeUrl,
        this.appStoreUrl,
        this.playStoreUrl,
        this.handyManStatus,
        this.eventStatus,
        this.event,
        this.handy,
        this.parcelDeliveryStatus,
        this.mehndiGstCharge,
        this.twoWheeler,
        this.threeWheeler,
        this.fourWheeler,
        this.foodDriverGst,
        this.map,
        this.handyFixedAmount,
        this.footerData,
        this.mapKey,
        this.googleKey});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nServerKey = json['n_server_key'];
    sSecretKey = json['s_secret_key'];
    sPublicKey = json['s_public_key'];
    rSecretKey = json['r_secret_key'];
    rPublicKey = json['r_public_key'];
    twitterUrl = json['twitter_url'];
    likendInUrl = json['likend_in_url'];
    instaramUrl = json['instaram_url'];
    facebookUrl = json['facebook_url'];
    address = json['address'];
    email = json['email'];
    contactNo = json['contact_no'];
    perKmCharge = json['per_km_charge'];
    gstCharge = json['gst_charge'];
    rideGstCharge = json['ride_gst_charge'];
    parcelGstCharge = json['parcel_gst_charge'];
    radius = json['radius'];
    advancedAmount = json['advanced_amount'];
    youtubeUrl = json['youtube_url'];
    appStoreUrl = json['app_store_url'];
    playStoreUrl = json['play_store_url'];
    handyManStatus = json['handy_man_status'];
    eventStatus = json['event_status'];
    event = json['event'];
    handy = json['handy'];
    parcelDeliveryStatus = json['parcel_delivery_status'];
    mehndiGstCharge = json['mehndi_gst_charge'];
    twoWheeler = json['two_wheeler'];
    threeWheeler = json['three_wheeler'];
    fourWheeler = json['four_wheeler'];
    foodDriverGst = json['food_driver_gst'];
    map = json['map'];
    handyFixedAmount = json['handy_fixed_amount'];
    footerData = json['footer_data'];
    mapKey = json['map_key'];
    googleKey = json['google_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['n_server_key'] = this.nServerKey;
    data['s_secret_key'] = this.sSecretKey;
    data['s_public_key'] = this.sPublicKey;
    data['r_secret_key'] = this.rSecretKey;
    data['r_public_key'] = this.rPublicKey;
    data['twitter_url'] = this.twitterUrl;
    data['likend_in_url'] = this.likendInUrl;
    data['instaram_url'] = this.instaramUrl;
    data['facebook_url'] = this.facebookUrl;
    data['address'] = this.address;
    data['email'] = this.email;
    data['contact_no'] = this.contactNo;
    data['per_km_charge'] = this.perKmCharge;
    data['gst_charge'] = this.gstCharge;
    data['ride_gst_charge'] = this.rideGstCharge;
    data['parcel_gst_charge'] = this.parcelGstCharge;
    data['radius'] = this.radius;
    data['advanced_amount'] = this.advancedAmount;
    data['youtube_url'] = this.youtubeUrl;
    data['app_store_url'] = this.appStoreUrl;
    data['play_store_url'] = this.playStoreUrl;
    data['handy_man_status'] = this.handyManStatus;
    data['event_status'] = this.eventStatus;
    data['event'] = this.event;
    data['handy'] = this.handy;
    data['parcel_delivery_status'] = this.parcelDeliveryStatus;
    data['mehndi_gst_charge'] = this.mehndiGstCharge;
    data['two_wheeler'] = this.twoWheeler;
    data['three_wheeler'] = this.threeWheeler;
    data['four_wheeler'] = this.fourWheeler;
    data['food_driver_gst'] = this.foodDriverGst;
    data['map'] = this.map;
    data['handy_fixed_amount'] = this.handyFixedAmount;
    data['footer_data'] = this.footerData;
    data['map_key'] = this.mapKey;
    data['google_key'] = this.googleKey;
    return data;
  }
}
