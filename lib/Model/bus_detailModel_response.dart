// To parse this JSON data, do
//
//     final busDesignDataResponse = busDesignDataResponseFromJson(jsonString);

import 'dart:convert';

import 'bus_detail_model.dart';

BusDesignDataResponse busDesignDataResponseFromJson(String str) => BusDesignDataResponse.fromJson(json.decode(str));

String busDesignDataResponseToJson(BusDesignDataResponse data) => json.encode(data.toJson());

class BusDesignDataResponse {
  bool? status;
  BusDetailModel? data;
  List<List<BusDeck>>? upperDeck;
  List<List<BusDeck>>? lowerDeck;
  String? message;

  BusDesignDataResponse({
    this.status,
    this.data,
    this.upperDeck,
    this.lowerDeck,
    this.message,
  });

  factory BusDesignDataResponse.fromJson(Map<String, dynamic> json) => BusDesignDataResponse(
    status: json["status"],
    data: BusDetailModel.fromJson(json["data"]),
    upperDeck: json["upper_deck"] == null ? null : List<List<BusDeck>>.from(json["upper_deck"].map((x) => List<BusDeck>.from(x.map((x) => BusDeck.fromJson(x))))),
      lowerDeck: json["lower_deck"] == null ? null :List<List<BusDeck>>.from(json["lower_deck"].map((x) => List<BusDeck>.from(x.map((x) => BusDeck.fromJson(x))))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data!.toJson(),
    "upper_deck": List<dynamic>.from(upperDeck!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "lower_deck": List<dynamic>.from(lowerDeck!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "message": message,
  };
}



class BusDeck {
  int? id;
  bool? isSelected;
  bool? isChecked;
  List<Passanger>? passanger;
  Address1? address;

  BusDeck({
    this.id,
    this.isSelected,
    this.isChecked,
    this.passanger,
    this.address
  });

   BusDeck.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    isSelected= json["is_selected"];
      if (json['passanger'] != null) {
  passanger = <Passanger>[];
  json['passanger'].forEach((v) {
  passanger!.add(new Passanger.fromJson(v));
  });
}
address = json['address'] != null ? new Address1.fromJson(json['address']) : null;
    isChecked = false;
   }
  Map<String, dynamic> toJson() => {
    "id": id,
    "is_selected": isSelected,
  };
}
