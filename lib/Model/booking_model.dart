class BookingModel {
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
  String? createdAt;
  String? driverId;
  String? bookingDate;
  String? availableSeats;

  BookingModel(
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
        this.holiday,
        this.createdAt,
        this.driverId,
        this.bookingDate,
        this.availableSeats});

  BookingModel.fromJson(Map<String, dynamic> json) {
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
    bookingDate = json['booking_date'];
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
    data['booking_date'] = this.bookingDate;
    data['available_seats'] = this.availableSeats;
    return data;
  }
}
