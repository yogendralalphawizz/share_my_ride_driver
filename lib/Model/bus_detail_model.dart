import '../DrawerPages/address.dart';

class BusDetailModel {
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
  String? vehicleNo;
  String? jsonData;
  String? holiday;
  String? pickupaddress;
  String ?dropaddress;
  String? createdAt;
  String? driverId;
  List<SeatDesign>? seatDesign;
  List<List<SeatDesign>>? seatDesignList;
  String? availableSeats;

  BusDetailModel(
      {this.id,
        this.name,
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
        this.pickupaddress,
        this.dropaddress,
        this.holiday,
        this.createdAt,
        this.driverId,
        this.seatDesign,
        this.availableSeats});

  BusDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    createdAt = json['created_at'];
    driverId = json['driver_id'];
    pickupaddress=json['pickup_address'];
    dropaddress=json['drop_address'];
    if (json['seat_design'] != null) {

      seatDesignList = [];
      seatDesign = <SeatDesign>[];
      for(var v in json['seat_design']){
        if(v is List) {
         List<SeatDesign> seatDesign = <SeatDesign>[];
          v.forEach((p) {
            seatDesign!.add(new SeatDesign.fromJson(p));
          });
         seatDesignList!.add(seatDesign.toList());
        }else{
          seatDesign!.add(new SeatDesign.fromJson(v));
        }
      }

    }
    availableSeats = json['available_seats'];
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
    data['driver_id'] = this.driverId;
    data['pickup_address']=pickupaddress;
    data['drop_address']=dropaddress;
    if (this.seatDesign != null) {
      data['seat_design'] = this.seatDesign!.map((v) => v.toJson()).toList();
    }
    data['available_seats'] = this.availableSeats;
    return data;
  }
}
class SeatDesign {
  int? id;
  bool? isSelected;
  bool? isChecked;
  List<Passanger>? passanger;
  Address1? address;

  SeatDesign({this.id,this.isChecked, this.isSelected, this.passanger,this.address});

  SeatDesign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isChecked = false;
    isSelected = json['is_selected'];
    if (json['passanger'] != null) {
      passanger = <Passanger>[];
      json['passanger'].forEach((v) {
        passanger!.add(new Passanger.fromJson(v));
      });
    }
    address =
    json['address'] != null ? new Address1.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_selected'] = this.isSelected;
    if (this.passanger != null) {
      data['passanger'] = this.passanger!.map((v) => v.toJson()).toList();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}
class   Address1 {
  String? pickupAddress;
  String? dropAddress;

  Address1({this.pickupAddress, this.dropAddress});

  Address1.fromJson(Map<String, dynamic> json) {
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pickup_address'] = this.pickupAddress;
    data['drop_address'] = this.dropAddress;
    return data;
  }
}
class Passanger {
  String? id;
  String? bookingId;
  String? name;
  String? gender;
  String? age;
  String? seatNo;
  String? createdAt;
  String? updatedAt;
  String? otp;
  String? mobile;

  Passanger(
      {this.id,
        this.bookingId,
        this.mobile,
        this.name,
        this.gender,
        this.age,
        this.seatNo,
        this.createdAt,
        this.updatedAt,
        this.otp});

  Passanger.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    mobile = json['mobile'];
    name = json['name'];
    gender = json['gender'];
    age = json['age'];
    seatNo = json['seat_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['seat_no'] = this.seatNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['otp'] = this.otp;
    return data;
  }
}

class StationModel {
  String? title;
  String? time;

  StationModel({this.title, this.time});

  StationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['time'] = this.time;
    return data;
  }
}
