class NotificationModel {
  bool? error;
  String? message;
  List<Data>? data;

  NotificationModel({this.error, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? notId;
  String? userId;
  dynamic? dataId;
  String? type;
  String? title;
  String? message;
  String? date;

  Data(
      {this.notId,
      this.userId,
      this.dataId,
      this.type,
      this.title,
      this.message,
      this.date});

  Data.fromJson(Map<String, dynamic> json) {
    notId = json['not_id'];
    userId = json['user_id'];
    dataId = json['data_id'];
    type = json['type'];
    title = json['title'];
    message = json['message'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['not_id'] = this.notId;
    data['user_id'] = this.userId;
    data['data_id'] = this.dataId;
    data['type'] = this.type;
    data['title'] = this.title;
    data['message'] = this.message;
    data['date'] = this.date;
    return data;
  }
}
