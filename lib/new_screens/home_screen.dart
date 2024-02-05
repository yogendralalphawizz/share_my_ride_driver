import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smr_driver/Model/booking_model.dart';
import 'package:smr_driver/Model/user_model.dart';
import 'package:smr_driver/new_screens/notifications_page.dart';
import 'package:smr_driver/new_screens/vehicle_detail_screen.dart';
import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentIndex = 0;
  TabController? tabController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  List<BookingModel> bookingList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getUserDetail();
    getBooking();
  }

  void getUserDetail() async {
    setState(() {
      loading = true;
    });
    Map param = {
      'driver_id': curUserId,
    };
    Map response = await apiBaseHelper.postAPICall(
        Uri.parse("${baseUrl}get_driver_detail"), param);
    setState(() {
      loading = false;
    });
    if (response['status']) {
      for (var v in response['data']) {
        userModel = UserModel.fromJson(v);
      }
    } else {
      setSnackbar("Something went wrong", context);
    }
  }

  void getBooking() async {
    setState(() {
      loading = true;
    });
    Map param = {
      'driver_id': curUserId,
      'type': (tabController!.index + 1).toString(),
    };
    Map response = await apiBaseHelper.postAPICall(
        Uri.parse("${baseUrl}bus_history_driver"), param);
    setState(() {
      loading = false;
      bookingList.clear();
    });
    if (response['status']) {
      for (var v in response['data']) {
        bookingList.add(BookingModel.fromJson(v));
      }
    } else {
      setSnackbar("Something went wrong", context);
    }
  }

  bool updateLoading = false;
  void updateBooking(busId, status, index) async {
    setState(() {
      updateLoading = true;
    });
    Map param = {
      'bus_id': busId,
      'status': status,
      'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
    };
    Map response = await apiBaseHelper.postAPICall(
        Uri.parse("${baseUrl}start_bus"), param);
    setState(() {
      updateLoading = false;
    });
    if (!response['error']) {
      setState(() {
        if (status == "0") {
          bookingList[index].status = "Started";
        } else if (status == "1") {
          bookingList[index].status = "Completed";
        } else {
          bookingList[index].status = "Cancelled";
        }
      });
    } else {
      setSnackbar("Something went wrong", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: userModel != null
                ? Image.network(
                    "${userModel!.proPic}",
                    fit: BoxFit.fill,
                  )
                : const SizedBox(),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: commonGradient(),
          ),
        ),
        title: Text(
          "Home",
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          onTap: (index) {
            getBooking();
          },
          indicatorWeight: 5,
          tabs: [
            Tab(
              text: "Today",
            ),
            Tab(
              text: "Upcoming",
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => NotificationsPage()));
              },
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              )),
        ],
      ),
      backgroundColor: MyColorName.scaffoldColor,
      body: !loading
          ? bookingList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: bookingList.length,
                  itemBuilder: (context, index) {
                    BookingModel model = bookingList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VehicleDetailScreen(
                                      model: model,
                                      journeyDate: model.bookingDate ?? '',
                                      vehicleType: model.type.toString(),
                                    )));
                      },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${model.jsonData}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    child: Text(
                                      "Status - ${model.status!}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${model.startTime}   ->  ${model.endTime}",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  model.busType.toString()=="null"?SizedBox.shrink():   commonButton(
                                    height: 4,
                                    fontSize: 10.0,
                                    onPressed: null,
                                    loading: false,
                                    title: "Type - ${model.busType}",
                                    context: context,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  commonButton(
                                    height: 4,
                                    fontSize: 10.0,
                                    onPressed: null,
                                    loading: false,
                                    title: "Seat Type - ${model.seatType}",
                                    context: context,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Journey Date - ${model.bookingDate}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Available Seats - ${model.availableSeats}",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    "Seats - ${model.noOfSeat}",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              commonButton(
                                height: 4,
                                fontSize: 10.0,
                                onPressed: null,
                                loading: false,
                                title:
                                    "Travel Name - ${model.name}(${model.vehicleNo})",
                                context: context,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              bookingList[index].status!="Cancelled" && bookingList[index].status!="Completed"?Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                title: Text("Cancel Booking"),
                                                content: Text(
                                                    "Do you want to proceed?"),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        shadowColor: Colors.red,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                      child: Text(
                                                        "No",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                      )),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        updateBooking(bookingList[index].id, "2", index);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        shadowColor:
                                                            Colors.green,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                      child: Text(
                                                        "Yes",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                      )),
                                                ],
                                              );
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shadowColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      child: !updateLoading
                                          ? Text(
                                              "Cancel",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                            )
                                          : CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  bookingList[index].bookingDate=="${DateFormat("yyyy-MM-dd").format(DateTime.now())}"?   Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                title: Text("${bookingList[index].status=="Started"?"Complete":"Start"} Booking"),
                                                content: Text(
                                                    "Do you want to proceed?"),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        shadowColor: Colors.red,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                      child: Text(
                                                        "No",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                      )),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        updateBooking(bookingList[index].id, bookingList[index].status=="Started"?"1":"0", index);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        shadowColor:
                                                            Colors.green,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                      child: Text(
                                                        "Yes",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                      )),
                                                ],
                                              );
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shadowColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      child: !updateLoading
                                          ? Text(
                                        bookingList[index].status=="Started"?"Complete":"Start",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                            )
                                          : CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                    ),
                                  ):SizedBox.shrink(),
                                ],
                              ):const SizedBox(),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : const Center(
                  child: Text("No Booking Available"),
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
