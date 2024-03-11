class VehicleListModel {
  bool? error;
  String? message;
  List<VehicleData>? data;

  VehicleListModel({this.error, this.message, this.data});

  VehicleListModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VehicleData>[];
      json['data'].forEach((v) {
        data!.add(new VehicleData.fromJson(v));
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

class VehicleData {
  String? id;
  String? name;
  String? busType;
  String? seatType;
  String? type;
  String? profileImage;
  String? noOfSeat;
  String? amount;
  String? status;
  String? address;
  String? toAddress;
  String? startTime;
  String? endTime;
  String? date;
  String? busDeck;
  String? totalSeatLower;
  String? totalSeatUpper;

  String? vehicleNo;
  dynamic? jsonData;
  dynamic? holiday;
  String? createdAt;
  dynamic? pickupPoints;
  dynamic? dropPoints;
  String? driverId;
  List<StopageData>? stopageData;

  VehicleData(
      {this.id,
        this.name,
        this.totalSeatLower,
        this.totalSeatUpper,
        this.busDeck,
        this.busType,
        this.seatType,
        this.type,
        this.profileImage,
        this.noOfSeat,
        this.amount,
        this.status,
        this.address,
        this.toAddress,
        this.startTime,
        this.endTime,
        this.vehicleNo,
        this.jsonData,
        this.holiday,
        this.createdAt,
        this.pickupPoints,
        this.dropPoints,
        this.driverId,
        this.date,
        this.stopageData});

  VehicleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalSeatLower = json['leftseat'];
    totalSeatUpper = json['uper_left'];
    busDeck = json['bus_deck'];
    name = json['name'];
    busType = json['bus_type'];
    seatType = json['seat_type'];
    type = json['type'];
    profileImage = json['profile_image'];
    noOfSeat = json['no_of_seat'];
    amount = json['amount'];
    status = json['status'];
    address = json['address'];
    toAddress = json['to_address'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    vehicleNo = json['vehicle_no'];
    jsonData = json['json_data'];
    holiday = json['holiday'];
    date = json['date'];
    createdAt = json['created_at'];
    pickupPoints = json['pickup_points'];
    dropPoints = json['drop_points'];
    driverId = json['driver_id'];
    if (json['stopage_data'] != null) {
      stopageData = <StopageData>[];
      json['stopage_data'].forEach((v) {
        stopageData!.add(new StopageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['bus_type'] = this.busType;
    data['seat_type'] = this.seatType;
    data['type'] = this.type;
    data['profile_image'] = this.profileImage;
    data['no_of_seat'] = this.noOfSeat;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['address'] = this.address;
    data['to_address'] = this.toAddress;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['vehicle_no'] = this.vehicleNo;
    data['json_data'] = this.jsonData;
    data['holiday'] = this.holiday;
    data['created_at'] = this.createdAt;
    data['pickup_points'] = this.pickupPoints;
    data['drop_points'] = this.dropPoints;
    data['date'] = this.date;
    data['driver_id'] = this.driverId;
    if (this.stopageData != null) {
      data['stopage_data'] = this.stopageData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StopageData {
  String? id;
  String? busId;
  String? charge;
  String? stop;
  String? stopFromtime;
  String? stopTotime;
  String? createdAt;
  String? updatedAt;

  StopageData(
      {this.id,
        this.busId,
        this.charge,
        this.stop,
        this.stopFromtime,
        this.stopTotime,
        this.createdAt,
        this.updatedAt});

  StopageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    busId = json['bus_id'];
    charge = json['charge'];
    stop = json['stop'];
    stopFromtime = json['stop_fromtime'];
    stopTotime = json['stop_totime'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bus_id'] = this.busId;
    data['charge'] = this.charge;
    data['stop'] = this.stop;
    data['stop_fromtime'] = this.stopFromtime;
    data['stop_totime'] = this.stopTotime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
