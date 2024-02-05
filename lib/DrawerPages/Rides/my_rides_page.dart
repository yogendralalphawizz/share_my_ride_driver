import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:smr_driver/DrawerPages/Rides/ride_info_page.dart';
import 'package:smr_driver/Locale/strings_enum.dart';
import 'package:smr_driver/Model/my_ride_model.dart';
import 'package:smr_driver/Model/rides_model.dart';
import 'package:smr_driver/Routes/page_routes.dart';
import 'package:smr_driver/Locale/locale.dart';
import 'package:smr_driver/Theme/style.dart';
import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/constant.dart';
import 'package:smr_driver/utils/widget.dart';
import 'package:sizer/sizer.dart';
import '../../Assets/assets.dart';

class MyRidesPage extends StatefulWidget {
  bool selected;

  MyRidesPage({this.selected = false});

  @override
  State<MyRidesPage> createState() => _MyRidesPageState();
}

class _MyRidesPageState extends State<MyRidesPage> {
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = true;
  List<MyRideModel> rideList = [];

  getRides(type) async {
    try {
      setState(() {
        loading = true;
      });
      Map params = {
        "driver_id": curUserId,
        "type": type,
      };
      print("GET ALL COMPLETE ========= $params");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Payment/get_all_complete"), params);
      setState(() {
        loading = false;
        rideList.clear();
      });
      if (response['status']) {
        print(response['data']);
        for (var v in response['data']) {
          setState(() {
            selectedFil = "All";
            rideList.add(MyRideModel.fromJson(v));
          });
        }
      } else {
        setState(() {
          selectedFil = "All";
        });
        // setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = widget.selected;
    if (widget.selected) {
      getRides("3");
    } else {
      getRides("1");
    }
  }

  Future<bool> onWill() {
    Navigator.pop(context, true);
    /* Navigator.popUntil(
      context,
      ModalRoute.withName('/'),
    );*/
    /*Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SearchLocationPage()),
        (route) => false);*/

    return Future.value();
  }

  bool selected = false;
  List<String> filter = ["All", "Today", "Weekly", "Monthly"];
  String selectedFil = "All";
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: onWill,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(
              getTranslated(context, "MY_RIDES")!,
              style: theme.textTheme.headline4,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                /*  Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  getTranslated(context,Strings.MY_RIDES)!,
                  style: theme.textTheme.headline4,
                ),
              ),*/
                /* Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  getTranslated(context,Strings.LIST_OF_RIDES_COMPLETED)!,
                  style:
                      theme.textTheme.bodyText2!.copyWith(color: theme.hintColor),
                ),
              ),*/
                boxHeight(context,10),
                Container(
                  width: getWidth(context,322.1),
                  decoration: boxDecoration(
                    bgColor: Colors.white,
                    radius: 10,
                    showShadow: true,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selected = false;
                          });
                          getRides("1");
                        },
                        child: Container(
                          height: getHeight(context,49),
                          width: getWidth(context,160),
                          decoration: !selected
                              ? BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(52, 61, 164, 139),
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 8.0,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor,
                                )
                              : BoxDecoration(),
                          child: Center(
                            child: text(
                              getTranslated(context, "upcoming")!,
                              fontFamily: fontSemibold,
                              fontSize: 11.sp,
                              textColor:
                                  !selected ? Colors.white : Color(0xff37778A),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selected = true;
                          });
                          getRides("3");
                        },
                        child: Container(
                          height: getHeight(context,49),
                          width: getWidth(context,160),
                          decoration: selected
                              ? BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(52, 61, 164, 139),
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 8.0,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor,
                                )
                              : BoxDecoration(),
                          child: Center(
                            child: text(
                              getTranslated(context, "Completed")!,
                              fontFamily: fontSemibold,
                              fontSize: 11.sp,
                              textColor:
                                  selected ? Colors.white : Color(0xff37778A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                boxHeight(context,19),
                Wrap(
                  spacing: 3.w,
                  children: filter.map((e) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedFil = e.toString();
                        });
                        var now = new DateTime.now();
                        var now_1w = now.subtract(Duration(days: 7));
                        var now_1m =
                            new DateTime(now.year, now.month - 1, now.day);
                        if (selectedFil == "Today") {
                          for (int i = 0; i < rideList.length; i++) {
                            DateTime date = DateTime.parse(
                                rideList[i].createdDate.toString());
                            if (now.day == date.day &&
                                now.month == date.month) {
                              setState(() {
                                rideList[i].show = true;
                              });
                            } else {
                              setState(() {
                                rideList[i].show = false;
                              });
                            }
                          }
                        }
                        if (selectedFil == "Weekly") {
                          for (int i = 0; i < rideList.length; i++) {
                            DateTime date = DateTime.parse(
                                rideList[i].createdDate.toString());
                            if (now_1w.isBefore(date)) {
                              setState(() {
                                rideList[i].show = true;
                              });
                            } else {
                              setState(() {
                                rideList[i].show = false;
                              });
                            }
                          }
                        }
                        if (selectedFil == "Monthly") {
                          for (int i = 0; i < rideList.length; i++) {
                            DateTime date = DateTime.parse(
                                rideList[i].createdDate.toString());
                            if (now_1m.isBefore(date)) {
                              setState(() {
                                rideList[i].show = true;
                              });
                            } else {
                              setState(() {
                                rideList[i].show = false;
                              });
                            }
                          }
                        }
                        if (selectedFil == "All") {
                          for (int i = 0; i < rideList.length; i++) {
                            setState(() {
                              rideList[i].show = true;
                            });
                          }
                        }
                      },
                      child: Chip(
                        side: BorderSide(color: MyColorName.primaryLite),
                        backgroundColor: selectedFil == e
                            ? MyColorName.primaryLite
                            : Colors.transparent,
                        shadowColor: Colors.transparent,
                        label: text(e,
                            fontFamily: fontMedium,
                            fontSize: 10.sp,
                            textColor:
                                selectedFil == e ? Colors.white : Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                boxHeight(context,19),
                !loading
                    ? rideList.length > 0
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rideList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => rideList[index]
                                    .show!
                                ? GestureDetector(
                                    onTap: () async {
                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RideInfoPage(
                                                    rideList[index],
                                                    check: rideList[index]
                                                                .acceptReject !=
                                                            "3"
                                                        ? null
                                                        : "yes",
                                                  )));
                                      if (result != null) {
                                        if (!selected) {
                                          getRides("1");
                                        } else {
                                          getRides("3");
                                        }
                                        //  getRides(type);
                                      }
                                      if (rideList[index].acceptReject !=
                                          "3") {}
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(getWidth(context,10)),
                                      decoration: boxDecoration(
                                          radius: 10,
                                          bgColor: Colors.white,
                                          showShadow: true),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 80,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                      height: getWidth(context,72),
                                                      width: getWidth(context,72),
                                                      decoration: boxDecoration(
                                                          radius: 10,
                                                          color: Colors.grey),
                                                      child: Image.network(
                                                        imagePath +
                                                            rideList[index]
                                                                .userImage
                                                                .toString(),
                                                        height: getWidth(context,72),
                                                        width: getWidth(context,72),
                                                      )),
                                                ),
                                                SizedBox(width: 16),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Trip ID-${getString1(rideList[index].uneaqueId.toString())}',
                                                      style: theme
                                                          .textTheme.bodyText1!
                                                          .copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      '${rideList[index].dateAdded}',
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      getString1(rideList[index]
                                                          .username
                                                          .toString()),
                                                      style: theme
                                                          .textTheme.caption!
                                                          .copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '\u{20B9} ${rideList[index].amount}',
                                                      style: theme
                                                          .textTheme.bodyText2!
                                                          .copyWith(
                                                              color: theme
                                                                  .hintColor),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      '${rideList[index].transaction}',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: theme
                                                          .textTheme.caption!
                                                          .copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.location_on,
                                              color: theme.primaryColor,
                                              size: 20,
                                            ),
                                            title: Text(
                                              getString1(rideList[index]
                                                  .pickupAddress
                                                  .toString()),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            dense: true,
                                            tileColor: theme.cardColor,
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.navigation,
                                              color: theme.primaryColor,
                                              size: 20,
                                            ),
                                            title: Text(getString1(
                                                rideList[index]
                                                    .dropAddress
                                                    .toString())),
                                            dense: true,
                                            tileColor: theme.cardColor,
                                          ),
                                          !rideList[index]
                                                  .bookingType!
                                                  .contains("Point")
                                              ? Row(
                                                  mainAxisAlignment: rideList[
                                                                      index]
                                                                  .sharing_type !=
                                                              null &&
                                                          rideList[index]
                                                                  .sharing_type !=
                                                              ""
                                                      ? MainAxisAlignment
                                                          .spaceBetween
                                                      : MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    AnimatedTextKit(
                                                      animatedTexts: [
                                                        ColorizeAnimatedText(
                                                          "Schedule - ${rideList[index].pickupDate} ${rideList[index].pickupTime}",
                                                          textStyle:
                                                              colorizeTextStyle,
                                                          colors:
                                                              colorizeColors,
                                                        ),
                                                      ],
                                                      pause: Duration(
                                                          milliseconds: 100),
                                                      isRepeatingAnimation:
                                                          true,
                                                      totalRepeatCount: 100,
                                                      onTap: () {
                                                        print("Tap Event");
                                                      },
                                                    ),
                                                    rideList[index].sharing_type !=
                                                                null &&
                                                            rideList[index]
                                                                    .sharing_type !=
                                                                ""
                                                        ? AnimatedTextKit(
                                                            animatedTexts: [
                                                              ColorizeAnimatedText(
                                                                "Ride Type - ${rideList[index].sharing_type}",
                                                                textStyle:
                                                                    colorizeTextStyle,
                                                                colors:
                                                                    colorizeColors,
                                                              ),
                                                            ],
                                                            pause: Duration(
                                                                milliseconds:
                                                                    100),
                                                            isRepeatingAnimation:
                                                                true,
                                                            totalRepeatCount:
                                                                100,
                                                            onTap: () {
                                                              print(
                                                                  "Tap Event");
                                                            },
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                )
                                              : SizedBox(),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          )
                        : Center(
                            child: text(getTranslated(context, "Norides")!,
                                fontFamily: fontMedium,
                                fontSize: 12.sp,
                                textColor: Colors.black),
                          )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          )),
    );
  }
}

final colorizeColors = [
  MyColorName.colorView,
  MyColorName.colorView,
];

final colorizeTextStyle = TextStyle(
  fontSize: 12.0,
  fontFamily: 'Horizon',
);
