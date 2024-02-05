
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';
import 'package:geocode/geocode.dart';
class GetLocation {
  LocationData? _currentPosition;


  Location location1 = Location();
  String firstLocation = "", lat = "", lng = "";
  ValueChanged onResult;

  GetLocation(this.onResult);
  Future<void> getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location1.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location1.requestService();
      if (!_serviceEnabled) {
        print('ek');
        return;
      }
    }

    _permissionGranted = await location1.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location1.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('no');
        return;
      }
    }

    location1.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.latitude} : ${currentLocation.longitude}");
      _currentPosition = currentLocation;
      print(currentLocation.latitude);
      latitudeFirst = _currentPosition!.latitude!;
      longitudeFirst = _currentPosition!.longitude!;
      if (latitude == 0) {
        getAddress(_currentPosition!.latitude, _currentPosition!.longitude)
            .then((value) {
          firstLocation = value.first.city.toString();
          print(firstLocation);
          print(value.first.streetAddress.toString());
          print(value.first.city.toString());

          if (latitude == 0) {
            if (!value.first.streetAddress.toString().contains("pricing")) {
              onResult(value);
            }
          }
        });
      }
    });
  }


}

Future<List<Address>> getAddress(double? lat, double? lng) async {
  //final coordinates = new Coordinates(latitude: lat, longitude: lng);
  Address add =
      await GeoCode().reverseGeocoding(latitude: lat!, longitude: lng!);
  return [add];
}
ApiBaseHelper apiBase = new ApiBaseHelper();
bool isNetwork = false;
updateLocation() async {
  await App.init();
  isNetwork = await isNetworkAvailable();
  if (isNetwork) {
    try {
      Map data;
      data = {
        "user_id": curUserId,
        "lat": latitude.toString(),
        "lang": longitude.toString()
      };
      var response = await post(Uri.parse(baseUrl + "update_lat_lang_driver"),
          body: data);
      debugPrint(response.toString());
    } on TimeoutException catch (_) {}
  } else {}
}