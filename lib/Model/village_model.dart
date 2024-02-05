class VilliageModel {
  String? responseCode;
  String? msg;
  List<Data>? data;

  VilliageModel({this.responseCode, this.msg, this.data});

  VilliageModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? talukaId;
  String? cityId;
  String? stateId;

  Data({this.id, this.name, this.talukaId, this.cityId, this.stateId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    talukaId = json['taluka_id'];
    cityId = json['city_id'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['taluka_id'] = this.talukaId;
    data['city_id'] = this.cityId;
    data['state_id'] = this.stateId;
    return data;
  }
}
