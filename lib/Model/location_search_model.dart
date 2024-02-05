class LocationsearchModel {
  bool? status;
  List<Data>? data;
  String? message;

  LocationsearchModel({this.status, this.data, this.message});

  LocationsearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? stateName;
  String? villageName;
  String? talukaName;

  Data({this.id, this.name, this.stateName, this.villageName, this.talukaName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateName = json['state_name'];
    villageName = json['village_name'];
    talukaName = json['taluka_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_name'] = this.stateName;
    data['village_name'] = this.villageName;
    data['taluka_name'] = this.talukaName;
    return data;
  }
}
