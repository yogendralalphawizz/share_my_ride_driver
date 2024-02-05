import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smr_driver/BookRide/complete_ride_dialog.dart';

import 'package:smr_driver/Components/background_image.dart';
import 'package:smr_driver/DrawerPages/Rides/intercity_rides.dart';
import 'package:smr_driver/DrawerPages/Rides/my_rides_page.dart';
import 'package:smr_driver/DrawerPages/Rides/rental_rides.dart';
import 'package:smr_driver/DrawerPages/Rides/ride_info_page.dart';
import 'package:smr_driver/DrawerPages/Wallet/wallet_page.dart';
import 'package:smr_driver/DrawerPages/notification_list.dart';
import 'package:smr_driver/Locale/strings_enum.dart';
import 'package:smr_driver/Model/my_ride_model.dart';
import 'package:smr_driver/Model/rides_model.dart';
import 'package:smr_driver/Routes/page_routes.dart';
import 'package:smr_driver/Theme/colors.dart';
import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/PushNotificationService.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';
import 'package:smr_driver/utils/location_details.dart';
import 'package:smr_driver/utils/map.dart';
import 'package:smr_driver/utils/widget.dart';
import 'package:sizer/sizer.dart';
import '../../Assets/assets.dart';
import '../../Locale/locale.dart';
import '../address.dart';
import '../app_drawer.dart';

class MenuTile {
  String title;
  String subtitle;
  IconData iconData;
  Function onTap;
  MenuTile(this.title, this.subtitle, this.iconData, this.onTap);
}

class OfflinePage extends StatefulWidget {
  String bookingId;
  OfflinePage(this.bookingId);

  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  bool isOnline = false;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool isAccountOpen = false;
  List<String> dataList = ["Online", "Offline"];
  int current = 1;
  var currentBookingStatus;
  bool condition = false;

  @override
  void initState() {
    /* Future.delayed(Duration(seconds: 5), () {
      Navigator.pushNamed(context, PageRoutes.rideBookedPage);
    });*/
    // TODO: implement initState
    super.initState();
    PushNotificationService notificationService = new PushNotificationService(
        context: context,
        onResult: (result) {
          print("boook" + result.toString());
          // getBookInfo();
          if (result != null) {
            if (result == "yes") {
              registerToken();
            } else {
              if (!result.toString().contains("null") &&
                  isNumeric(result.toString())) {
                getBookingInfo(result);
              } else {
                getBookInfo();
              }
            }
          } else {
            getBookInfo();
          }
        });
    notificationService.initialise();
    // getBookingInfo("182");
    getLocation();
    getProfile();
    getCurrentInfo();
    getBookInfo();
    if (widget.bookingId != "") {
      getBookingInfo(widget.bookingId);
    }
  }

  double minimumBal = 0;
  getSetting() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "user_id": curUserId.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Authentication/minimum_balance"), params);
      setState(() {
        saveStatus = true;
      });
      if (response['status']) {
        var data = response["data"][0];
        print(data);
        minimumBal = double.parse(data['wallet_amount'].toString());
      } else {
        // setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  String count = "0";
  getCount() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "driver_id": curUserId.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "payment/count_noti_driver"), params);
      if (response['status']) {
        count = response["noti_count"].toString();
      } else {
        // setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  MyRideModel? model;
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  getBookingInfo(tempRefer) async {
    try {
      if (bookModel != null && getDifference()) {
        setSnackbar("you have a booking in an hour", context);
        return;
      }
      setState(() {
        saveStatus = false;
      });
      if (!isNumeric(tempRefer.toString())) {
        return;
      }
      Map params = {
        "booking_id": tempRefer.toString(),
      };

      print("GET BOOKING ====== $params");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "payment/get_booking_by_id"), params);
      setState(() {
        saveStatus = true;
        currentBookingStatus = response['status'];
      });
      print("BOOKING STATUS === $currentBookingStatus");
      if (response['status']) {
        var v = response["data"];
        if (mounted && bookModel == null)
          setState(() {
            model = MyRideModel.fromJson(v);
          });
        /* showConfirm(RidesModel(v['id'], v['user_id'], v['username'], v['uneaque_id'], v['purpose'], v['pickup_area'],
            v['pickup_date'], v['drop_area'], v['pickup_time'], v['area'], v['landmark'], v['pickup_address'], v['drop_address'],
            v['taxi_type'], v['departure_time'], v['departure_date'], v['return_date'], v['flight_number'], v['package'],
            v['promo_code'], v['distance'], v['amount'], v['paid_amount'], v['address'], v['transfer'], v['item_status'],
            v['transaction'], v['payment_media'], v['km'], v['timetype'], v['assigned_for'], v['is_paid_advance'], v['status'], v['latitude'], v['longitude'], v['date_added'],
            v['drop_latitude'], v['drop_longitude'], v['booking_type'], v['accept_reject'], v['created_date']));*/
        //print(data);
      } else {
        setState(() {
          condition = true;
        });
        setSnackbar("Ride Already Accepted", context);
        // getBookingInfo(widget.bookingId);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  getBookInfo() async {
    try {
      setState(() {
        saveStatus = false;
        bookModel = null;
      });
      Map params = {
        "user_id": curUserId,
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "payment/get_booking_details"), params);
      setState(() {
        saveStatus = true;
      });
      if (response['status'] && response["data"].length > 0) {
        var v = response["data"][0];
        setState(() {
          bookModel = MyRideModel.fromJson(v);
        });
        //print(data);
      } else {
        // setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  MyRideModel? bookModel;
  MyRideModel? model1;
  getCurrentInfo() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "driver_id": curUserId,
      };
      print("GET DRIVER BOOKING RIDE =======???? $params");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Payment/get_driver_booking_ride"), params);
      print(response);
      setState(() {
        saveStatus = true;
      });
      if (response['status']) {
        var v = response["data"][0];
        setState(() {
          model1 = MyRideModel.fromJson(v);
        });
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => RideInfoPage(model1!)));
        if (result != null) {
          getBookInfo();
        }
        /* showConfirm(RidesModel(v['id'], v['user_id'], v['username'], v['uneaque_id'], v['purpose'], v['pickup_area'],
            v['pickup_date'], v['drop_area'], v['pickup_time'], v['area'], v['landmark'], v['pickup_address'], v['drop_address'],
            v['taxi_type'], v['deparddddddture_time'], v['departure_date'], v['return_date'], v['flight_number'], v['package'],
            v['promo_code'], v['distance'], v['amount'], v['paid_amount'], v['address'], v['transfer'], v['item_status'],
            v['transaction'], v['payment_media'], v['km'], v['timetype'], v['assigned_for'], v['is_paid_advance'], v['status'], v['latitude'], v['longitude'], v['date_added'],
            v['drop_latitude'], v['drop_longitude'], v['booking_type'], v['accept_reject'], v['created_date']));*/
        //print(data);
      } else {
        getTodayInfo();
        getSetting();
        getCount();
        getStatus();
        // setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  String totalRide = "";
  String totalAmount = "";

  getTodayInfo() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "driver_id": curUserId,
        "type": "today",
      };
      print("TODAY RIDE PARAM ==== $params");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Payment/get_todayride"), params);

      setState(() {
        saveStatus = true;
      });
      if (response['status']) {
        var v = response["data"];
        setState(() {
          totalAmount = response["total_amount"];
          totalRide = response["total_ride"];
        });
        /* showConfirm(RidesModel(v['id'], v['user_id'], v['username'], v['uneaque_id'], v['purpose'], v['pickup_area'],
            v['pickup_date'], v['drop_area'], v['pickup_time'], v['area'], v['landmark'], v['pickup_address'], v['drop_address'],
            v['taxi_type'], v['departure_time'], v['departure_date'], v['return_date'], v['flight_number'], v['package'],
            v['promo_code'], v['distance'], v['amount'], v['paid_amount'], v['address'], v['transfer'], v['item_status'],
            v['transaction'], v['payment_media'], v['km'], v['timetype'], v['assigned_for'], v['is_paid_advance'], v['status'], v['latitude'], v['longitude'], v['date_added'],
            v['drop_latitude'], v['drop_longitude'], v['booking_type'], v['accept_reject'], v['created_date']));*/
        //print(data);
      } else {
        //  setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  showConfirm(MyRideModel model) {
    showDialog(
        context: context,
        builder: (BuildContext context1) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(getWidth(context,15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  text("Ride Info",
                      fontSize: 10.sp,
                      fontFamily: fontMedium,
                      textColor: Colors.black),
                  Divider(),
                  boxHeight(context,10),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration:
                            boxDecoration(radius: 100, bgColor: Colors.green),
                      ),
                      boxWidth(context,10),
                      Expanded(
                          child: text(model.pickupAddress!,
                              fontSize: 9.sp,
                              fontFamily: fontRegular,
                              textColor: Colors.black)),
                    ],
                  ),
                  boxHeight(context,10),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration:
                            boxDecoration(radius: 100, bgColor: Colors.red),
                      ),
                      boxWidth(context,10),
                      Expanded(
                          child: text(model.dropAddress!,
                              fontSize: 9.sp,
                              fontFamily: fontRegular,
                              textColor: Colors.black)),
                    ],
                  ),
                  boxHeight(context,10),
                  Divider(),
                  boxHeight(context,10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text("Payment Mode : ",
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                      text(model.transaction!,
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                    ],
                  ),
                  boxHeight(context,10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text("Ride Type : ",
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                      text(model.bookingType!,
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                    ],
                  ),
                  boxHeight(context,10),
                  model.sharing_type != null && model.sharing_type != ""
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text("Sharing Type : ",
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                            text(model.sharing_type!,
                                fontSize: 10.sp,
                                fontFamily: fontMedium,
                                textColor: Colors.black),
                          ],
                        )
                      : SizedBox(),
                  boxHeight(context,10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text("Booking On : ",
                          fontSize: 10.sp,
                          fontFamily: fontMedium,
                          textColor: Colors.black),
                      Expanded(
                          child: text(getDate(model.createdDate),
                              fontSize: 10.sp,
                              fontFamily: fontMedium,
                              textColor: Colors.black)),
                    ],
                  ),
                  boxHeight(context,10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context1);
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>FindingRidePage()));
                        },
                        child: Container(
                          width: 30.w,
                          height: 5.h,
                          decoration:
                              boxDecoration(radius: 5, bgColor: Colors.grey),
                          child: Center(
                              child: text("Cancel",
                                  fontFamily: fontMedium,
                                  fontSize: 10.sp,
                                  isCentered: true,
                                  textColor: Colors.white)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context1);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RideInfoPage(model)));
                        },
                        child: Container(
                          width: 30.w,
                          height: 5.h,
                          decoration: boxDecoration(
                              radius: 5,
                              bgColor: Theme.of(context).primaryColor),
                          child: Center(
                              child: text("View",
                                  fontFamily: fontMedium,
                                  fontSize: 10.sp,
                                  isCentered: true,
                                  textColor: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  // getLocation() {
  //   print("sfsfsfsf working her now");
  //   GetLocation location = new GetLocation((result) {
  //     print("sfsfsfsfsfsfsfsfsfs ");
  //     // if (mounted) {
  //       setState(() {
  //         address = result.first.addressLine;
  //         latitude = result.first.coordinates.latitude;
  //         longitude = result.first.coordinates.longitude;
  //       });
  //       print("checking lat and lomg ${latitude} and ${longitude}");
  //          updateLocation();
  //     // }
  //     if (latitude != result.first.coordinates.latitude) {}
  //   }, status: true);
  //   location.getLoc();
  // }

  Position? currentLocation;

  Future getLocation() async {
    var status = await Permission.location.request();
    if(status.isDenied) {
      Fluttertoast.showToast(msg: "Permision is requiresd");
    }else if(status.isGranted){
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position) {
        if (mounted)
          setState(() {
            currentLocation = position;
            latitude = currentLocation!.latitude!;
            longitude = currentLocation!.longitude!;
          });
      });
      print("LOCATION===" +currentLocation.toString());
    } else if(status.isPermanentlyDenied) {
      openAppSettings();
    }
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
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl + "update_lat_lang_driver"), data);
        print(response);
        print(response);
        bool status = true;
        String msg = response['message'];

        // setSnackbar(msg, context);
        if (response['status']) {
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  getStatus() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "user_id": curUserId,
        };
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl + "get_online_offline"), data);
        print(response);
        print(response);
        bool status = true;
        String msg = response['message'];

        // setSnackbar(msg, context);
        if (response['status']) {
          if (response['data'] == "1") {
            if (mounted)
              setState(() {
                current = 0;
              });
          } else if (response['data'] == "3") {
            if (mounted)
              setState(() {
                current = 2;
              });
          } else {
            if (mounted)
              setState(() {
                current = 1;
              });
          }
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  updateStatus(String status1) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "user_id": curUserId,
          "online_ofline": status1.toString(),
        };
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl + "update_driver_online"), data);
        print(response);
        print(response);
        bool status = true;
        String msg = response['message'];
        //  setSnackbar(msg, context);
        if (response['status']) {
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  bool acceptStatus = false;
  bookingStatus(String bookingId, status1) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "driver_id": curUserId,
          "accept_reject": status1.toString(),
          "booking_id": bookingId,
        };
        print("ACCEPT REJECT DRIVER ==== $data");
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Payment/accept_reject_driver"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
        setSnackbar(msg, context);
        if (response['status']) {
          setState(() {
            model = null;
          });
          if (status1 == "1") {
            getCurrentInfo();
            getBookInfo();
          }
        } else {
          setState(() {
            model = null;
          });
        }
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  bool loading = true;
  bool saveStatus = true;
  String walletAccount = "";
  getProfile() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "user_id": curUserId.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl + "get_profile_driver"), params);
      setState(() {
        saveStatus = true;
      });
      if (response['status']) {
        var data = response["data"];
        print(data);
        name = data['user_name'];
        mobile = data['phone'];
        email = data['email'];
        gender1 = data['gender'];
        homeAddress = data['home_address'];
        walletAccount = data['wallet_amount'];
        dob = data['dob'];
        if (response['rating'] != null) {
          rating =
              double.parse(response['rating'].toString()).toStringAsFixed(2);
        }
        image =
            response['image_path'].toString() + data['user_image'].toString();
        drivingImage = response['image_path'].toString() +
            data['driving_licence_photo'].toString();
        print(image);
        imagePath = response['image_path'].toString();
        panCard = imagePath + data['pan_card'].toString();
        adharCard = imagePath + data['aadhar_card'].toString();
        vehicle = imagePath + data['vehical_imege'].toString();
        insurance = imagePath + data['insurance'].toString();
        cheque = imagePath + data['bank_chaque'].toString();
        brand = data['car_type'];
        model2 = data['car_model'];
        number = data['car_no'];
        bankName = data['bank_name'];
        accountNumber = data['account_number'];
        code = data['ifsc_code'];
        profileStatus = data['profile_status'];
        isActive = data['is_active'];
        reject = data['reject'];
        print("dta" + data['profile_status']);
        refer = data['referral_code'];
      } else {
        setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  DateTime? currentBackPressTime;
  Future<bool> onWill() async {
    DateTime now = DateTime.now();
    print("okay");
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      print("no");
      Common().toast("Press back again to exit");
      return Future.value(false);
    }
    exit(1);
    return Future.value();
  }

  final colorizeColors = [
    MyColorName.colorView,
    MyColorName.colorView,
  ];

  final colorizeTextStyle = TextStyle(
    fontSize: 14.0,
    fontFamily: 'Horizon',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: MyColorName.primaryLite,
        title: Text(
          getTranslated(context, "TAKE_RIDE")!,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                getLocation();
                getProfile();
                getTodayInfo();
                getSetting();
                getCount();
                getBookInfo();
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              )),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                  onPressed: () async {
                    print("_____________________");
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
                    if (result != null) {
                      if (result == "yes") {
                        setState(() {
                          count = "0";
                        });
                        return;
                      }
                      getBookingInfo(result);
                    }
                  },
                  icon: Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                  )),
              count != "0"
                  ? Container(
                      width: getWidth(context,18),
                      height: getWidth(context,18),
                      margin: EdgeInsets.only(
                          right: getWidth(context,3), top: getHeight(context,3)),
                      decoration:
                          boxDecoration(radius: 100, bgColor: Colors.red),
                      child: Center(
                          child: text(count.toString(),
                              fontFamily: fontMedium,
                              fontSize: 6.sp,
                              textColor: Colors.white)),
                    )
                  : SizedBox(),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(
            100.w,
            getHeight(context,50),
          ),
          child: ListTile(
            onTap: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyRidesPage(
                          selected: true,
                        )),
              );
              if (result != null) {
                getBookInfo();
              }
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: image != ""
                    ? Image.network(
                  image,
                  width: getWidth(context,60),
                  height: getWidth(context,60),
                  fit: BoxFit.fill,
                  colorBlendMode: profileStatus == "0"
                      ? BlendMode.hardLight
                      : BlendMode.color,
                  color: profileStatus == "0"
                      ? Colors.white.withOpacity(0.4)
                      : Colors.transparent,
                )
                    : SizedBox()),
            /*Image.asset('assets/delivery_boy.png'),*/
            title: Text(
              '${totalRide} ' +
                  getTranslated(context, Strings.RIDES)!.toUpperCase() +
                  ' | \u{20B9}${totalAmount}',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(getTranslated(context, Strings.TODAY)!),
          ),
        ),
      ),
      drawer: AppDrawer(
        onResult: (result) {
          if (result != null) {
            setState(() {
              saveStatus = false;
            });
            getLocation();
            getProfile();
            getTodayInfo();
            getBookInfo();
          }
        },
      ),
      body: WillPopScope(
        onWillPop: onWill,
        child: SafeArea(
          child: latitude != 0
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children:
                  [
                    latitude == null || latitude == "" ? Center(child: CircularProgressIndicator(color: Colors.black,),):
                    MapPage(
                      false,
                      live: false,
                      SOURCE_LOCATION: LatLng(latitude!, longitude!),
                    ),
                    bookModel != null
                        ? Container(
                            margin: EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: boxDecoration(
                                showShadow: true, bgColor: Colors.white),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "You have an already ${bookModel!.bookingType!} ride",
                                  style: TextStyle(color: Colors.black),
                                )),
                                boxWidth(context,10),
                                InkWell(
                                  onTap: () async {
                                    if (bookModel!.bookingType!
                                        .toLowerCase()
                                        .contains("schedule")) {
                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyRidesPage(
                                                    selected: false,
                                                  )));
                                      if (result != null) {
                                        getBookInfo();
                                      }
                                    } else if (bookModel!.bookingType!
                                        .toLowerCase()
                                        .contains("intercity")) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IntercityRides(
                                                    selected: false,
                                                  )));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RentalRides(
                                                    selected: false,
                                                  )));
                                    }
                                  },
                                  child: Container(
                                    width: 30.w,
                                    height: 5.h,
                                    decoration: boxDecoration(
                                        radius: 5,
                                        bgColor:
                                            Theme.of(context).primaryColor),
                                    child: Center(
                                        child: text(
                                            getTranslated(context, "VIEW") !=
                                                    null
                                                ? getTranslated(
                                                    context, "VIEW")!
                                                : "View",
                                            fontFamily: fontMedium,
                                            fontSize: 10.sp,
                                            isCentered: true,
                                            textColor: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                        model != null
                        ? Card(
                            margin: EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.all(getWidth(context,15)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    text("Ride Info",
                                        fontSize: 10.sp,
                                        fontFamily: fontMedium,
                                        textColor: Colors.black),
                                    Divider(),
                                    boxHeight(context,5),
                                    Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: boxDecoration(
                                              radius: 100,
                                              bgColor: Colors.green),
                                        ),
                                        boxWidth(context,10),
                                        Expanded(
                                            child: text(
                                                model!.pickupAddress.toString(),
                                                fontSize: 9.sp,
                                                fontFamily: fontRegular,
                                                textColor: Colors.black)),
                                      ],
                                    ),
                                    boxHeight(context,5),
                                    model!.dropAddress != null
                                        ? Row(
                                            children: [
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: boxDecoration(
                                                    radius: 100,
                                                    bgColor: Colors.red),
                                              ),
                                              boxWidth(context,10),
                                              Expanded(
                                                  child: text(
                                                      model!.dropAddress
                                                          .toString(),
                                                      fontSize: 9.sp,
                                                      fontFamily: fontRegular,
                                                      textColor: Colors.black)),
                                            ],
                                          )
                                        : SizedBox(),
                                    boxHeight(context,5),
                                    Divider(),
                                    boxHeight(context,5),
                                    model!.bookingType
                                            .toString()
                                            .contains("Rental Booking")
                                        ? SizedBox.shrink()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              text("Payment Mode : ",
                                                  fontSize: 10.sp,
                                                  fontFamily: fontMedium,
                                                  textColor: Colors.black),
                                              text(
                                                  model!.transaction.toString(),
                                                  fontSize: 10.sp,
                                                  fontFamily: fontMedium,
                                                  textColor: Colors.black),
                                            ],
                                          ),
                                    boxHeight(context,5),
                                    !model!.bookingType
                                            .toString()
                                            .contains("Point")
                                        ? AnimatedTextKit(
                                            animatedTexts: [
                                              ColorizeAnimatedText(
                                                model!.bookingType
                                                        .toString()
                                                        .contains(
                                                            "Rental Booking")
                                                    ? "Rental Booking - ${model!.start_time} - ${model!.end_time}"
                                                    : "Schedule - ${model!.pickupDate} ${model!.pickupTime}",
                                                textStyle: colorizeTextStyle,
                                                colors: colorizeColors,
                                              ),
                                            ],
                                            pause: Duration(milliseconds: 100),
                                            isRepeatingAnimation: true,
                                            totalRepeatCount: 100,
                                            onTap: () {
                                              print("Tap Event");
                                            },
                                          )
                                        : SizedBox(),
                                    boxHeight(context,5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        text("Ride Type : ",
                                            fontSize: 10.sp,
                                            fontFamily: fontMedium,
                                            textColor: Colors.black),
                                        text(model!.bookingType.toString(),
                                            fontSize: 10.sp,
                                            fontFamily: fontMedium,
                                            textColor: Colors.black),
                                      ],
                                    ),
                                    boxHeight(context,5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        text(
                                            "${getTranslated(context, "Earningamount")!} : ",
                                            fontSize: 10.sp,
                                            fontFamily: fontMedium,
                                            textColor: Colors.black),
                                        text("₹" + model!.paidAmount.toString(),
                                            fontSize: 10.sp,
                                            fontFamily: fontMedium,
                                            textColor: Colors.black),
                                      ],
                                    ),
                                    boxHeight(context,5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        text(
                                            model!.bookingType
                                                    .toString()
                                                    .contains("Rental Booking")
                                                ? "Hours : "
                                                : "Distance : ",
                                            fontSize: 10.sp,
                                            fontFamily: fontMedium,
                                            textColor: Colors.black),
                                        text(
                                            model!.bookingType
                                                    .toString()
                                                    .contains("Rental Booking")
                                                ? model!.hours.toString() +
                                                    " mins"
                                                : model!.km.toString() + " km",
                                            fontSize: 10.sp,
                                            fontFamily: fontMedium,
                                            textColor: Colors.black),
                                      ],
                                    ),
                                    boxHeight(context,5),
                                    /*Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              text("Earning Amount ",
                                  fontSize: 10.sp,
                                  fontFamily: fontMedium,
                                  textColor: Colors.black),
                              text("₹" + model!.paidAmount.toString(),
                                  fontSize: 10.sp,
                                  fontFamily: fontMedium,
                                  textColor: Colors.black),
                              text("|",
                                  fontSize: 10.sp,
                                  fontFamily: fontMedium,
                                  textColor: Colors.black),
                              text("Distance ",
                                  fontSize: 10.sp,
                                  fontFamily: fontMedium,
                                  textColor: Colors.black),
                              text(model!.km.toString() + " km",
                                  fontSize: 10.sp,
                                  fontFamily: fontMedium,
                                  textColor: Colors.black),
                            ],
                          ),*/
                                    Container(
                                      child: Column(
                                        children: [
                                          double.parse(model!.gstAmount
                                                      .toString()) >
                                                  0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text("Sub Total : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            (double.parse(model!
                                                                        .amount
                                                                        .toString()) -
                                                                    double.parse(model!
                                                                        .gstAmount
                                                                        .toString()) -
                                                                    double.parse(model!
                                                                        .surgeAmount
                                                                        .toString()))
                                                                .toStringAsFixed(
                                                                    2),
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                              model!.baseFare != null &&
                                                  model!.baseFare! is double &&
                                                  double.parse(model!.baseFare
                                                          .toString()) >
                                                      0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text("Base fare : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            model!.baseFare
                                                                .toString(),
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                              model!.ratePerKm != null &&
                                                  model!.ratePerKm! is double &&
                                                  double.parse(model!.km
                                                          .toString()) >=
                                                      2 &&
                                                  double.parse(model!.ratePerKm
                                                          .toString()
                                                          .replaceAll(
                                                              ",", "")) >
                                                      0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text(
                                                        "${model!.km.toString()} Kilometers : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            model!.ratePerKm
                                                                .toString()
                                                                .replaceAll(
                                                                    ",", ""),
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                              model!.timeAmount != null &&
                                                  model!.timeAmount!
                                                      is double &&
                                                  double.parse(model!.timeAmount
                                                          .toString()) >
                                                      0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text(
                                                        "${model!.totalTime.toString()} Minutes : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            model!.timeAmount
                                                                .toString(),
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                          // double.parse(model!.gstAmount
                                          //             .toString()) >
                                          //         0
                                          //     ? Row(
                                          //         mainAxisAlignment:
                                          //             MainAxisAlignment
                                          //                 .spaceBetween,
                                          //         children: [
                                          //           text("Taxes : ",
                                          //               fontSize: 10.sp,
                                          //               fontFamily: fontMedium,
                                          //               textColor:
                                          //                   Colors.black),
                                          //           text(
                                          //               "₹" +
                                          //                   model!.gstAmount
                                          //                       .toString(),
                                          //               fontSize: 10.sp,
                                          //               fontFamily: fontMedium,
                                          //               textColor:
                                          //                   Colors.black),
                                          //         ],
                                          //       )
                                          //     : SizedBox(),
                                          double.parse(model!.surgeAmount
                                                      .toString()) >
                                                  0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text("Surge Amount : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            model!.surgeAmount
                                                                .toString(),
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              text("Total : ",
                                                  fontSize: 10.sp,
                                                  fontFamily: fontMedium,
                                                  textColor: Colors.black),
                                              text("₹" + "${model!.paidAmount}",
                                                  fontSize: 10.sp,
                                                  fontFamily: fontMedium,
                                                  textColor: Colors.black),
                                            ],
                                          ),
                                          boxHeight(context,5),
                                        ],
                                      ),
                                    ),
                                    boxHeight(context,5),
                                    !acceptStatus
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    acceptStatus = true;
                                                  });
                                                  bookingStatus(
                                                      model!.id.toString(),
                                                      "2");

                                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>FindingRidePage()));
                                                },
                                                child: Container(
                                                  width: 30.w,
                                                  height: 5.h,
                                                  decoration: boxDecoration(
                                                      radius: 5,
                                                      bgColor: Colors.grey),
                                                  child: Center(
                                                      child: text("Reject",
                                                          fontFamily:
                                                              fontMedium,
                                                          fontSize: 10.sp,
                                                          isCentered: true,
                                                          textColor:
                                                              Colors.white)),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  if (currentBookingStatus ==
                                                      true) {
                                                    setState(() {
                                                      acceptStatus = true;
                                                      condition = true;
                                                    });
                                                    bookingStatus(
                                                        model!.id.toString(),
                                                        "1");
                                                  } else {
                                                    setState(() {
                                                      condition = true;
                                                      model = null;
                                                    });
                                                    setSnackbar(
                                                        "Ride is Cancelled by User",
                                                        context);
                                                    print("CANCELLED");
                                                  }
                                                },
                                                child: Container(
                                                  width: 30.w,
                                                  height: 5.h,
                                                  decoration: boxDecoration(
                                                      radius: 5,
                                                      bgColor: Theme.of(context)
                                                          .primaryColor),
                                                  child: Center(
                                                      child: text("Accept",
                                                          fontFamily:
                                                              fontMedium,
                                                          fontSize: 10.sp,
                                                          isCentered: true,
                                                          textColor:
                                                              Colors.white)),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
      bottomNavigationBar: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            boxHeight(context,5),
            Card(
              elevation: 6,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: dataList.map((e) {
                    int i = dataList.indexWhere((element) => element == e);
                    return InkWell(
                      onTap: () {
                        if (i == 2 && homeAddress == "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddressScreen()),
                          );
                          setSnackbar("Please Add Address First", context);
                          return;
                        }
                        setState(() {
                          current = i;
                        });
                        if (current == 0) {
                          updateStatus("1");
                        } else if (current == 2) {
                          updateStatus("3");
                        } else {
                          updateStatus("2");
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            color: i == current
                                ? MyColorName.primaryLite
                                : Colors.white,
                            padding: EdgeInsets.all(getWidth(context,5)),
                            child: Text(e,
                                style: TextStyle(
                                  color: i != current
                                      ? MyColorName.primaryLite
                                      : Colors.white,
                                  fontSize: 16.0,
                                )),
                          ),
                          // e != "Home"
                          //     ? Container(height: 10, child: VerticalDivider())
                          //     : SizedBox(),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            boxHeight(context,5),
            Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                elevation: 5,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: 8, vertical: getHeight(context,10)),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: walletAccount != "" &&
                            double.parse(walletAccount) < minimumBal
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WalletPage()),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: getHeight(context,5), bottom: getHeight(context,10)),
                              width: getWidth(context,350),
                              child: text(
                                  "Note-You need to add minimum \u{20B9}${minimumBal} to get booking request.",
                                  fontSize: 10.sp,
                                  fontFamily: fontMedium,
                                  isCentered: true,
                                  textColor: Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              SizedBox(
                                width: 44,
                              ),
                              CircleAvatar(
                                radius: 5,
                                backgroundColor:
                                    current != 1 ? onlineColor : offlineColor,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    /*setState(() {
                                if (current == 0) {
                                  current = 1;
                                } else {
                                  current = 0;
                                }
                              });*/
                                  },
                                  child: Text(
                                      current != 1
                                          ? getTranslated(context,
                                                  Strings.YOU_RE_ONLINE)!
                                              .toUpperCase()
                                          : getTranslated(context,
                                                  Strings.YOU_RE_OFFLINE)!
                                              .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              letterSpacing: 0.5))),
                              SizedBox(
                                width: 45,
                              ),
                              Spacer(),
                            ],
                          ))),
            /* walletAccount!=""&&double.parse(walletAccount)<500?InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  WalletPage()),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: getHeight(context,5),bottom: getHeight(context,10)),
                width: getWidth(context,350),
                child: text("Note-You need to add minimum \u{20B9}${minimumBal} to get booking request.",
                    fontSize: 10.sp,
                    fontFamily: fontMedium,
                    isCentered: true,

                    textColor: Colors.red
                ),
              ),
            ):SizedBox(),*/
          ],
        ),
      ),
    );
  }

  getDifference() {
    String date = bookModel!.pickupDate.toString();
    DateTime temp = DateTime.parse(date);
    print(temp);
    print(date);
    if (temp.day == DateTime.now().day) {
      String time = bookModel!.pickupTime.toString().split(" ")[0];
      int i = 0;
      if (bookModel!.pickupTime.toString().split(" ").length > 1 &&
          bookModel!.pickupTime.toString().split(" ")[1].toLowerCase() ==
              "pm") {
        i = 12;
      }
      print(time);
      if (time != "") {
        DateTime temp = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            int.parse(time.split(":")[0]) + i,
            int.parse(time.split(":")[1]));
        print("check" + temp.difference(DateTime.now()).inHours.toString());
        print(temp);
        print(DateTime.now());
        print(temp.difference(DateTime.now()).inHours);
        print(1 > temp.difference(DateTime.now()).inHours);
        return 1 > temp.difference(DateTime.now()).inHours;
      } else {
        return true;
      }
    } else {
      print(false);
      return false;
    }
  }
}
