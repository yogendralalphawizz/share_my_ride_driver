import 'package:flutter/material.dart';
import 'package:smr_driver/Model/booking_model.dart';
import 'package:smr_driver/Model/bus_detail_model.dart';
import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';

class VehicleDetailScreen extends StatefulWidget {
  BookingModel model;
  String journeyDate;
  final String vehicleType;
  VehicleDetailScreen(
      {required this.model,
      required this.journeyDate,
      required this.vehicleType});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  BusDetailModel? model;
  StationModel? selectedPick;
  StationModel? selectedDrop;
  List<StationModel> pickList = [];
  List<StationModel> dropList = [];
  double totalAmount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVehicleDetail();
  }

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  Future<void> getVehicleDetail() async {
    setState(() {
      loading = true;
    });
    Map param = {'bus_id': widget.model.id, 'journey_date': widget.journeyDate};
    var response = await apiBaseHelper.postAPICall(
        Uri.parse("${baseUrl}bus_detailsss"), param);
    print('${param}_________${baseUrl}bus_details___');
    setState(() {
      loading = false;
    });
    if (response['status']) {
      model = BusDetailModel.fromJson(response['data']);
    } else {
      setSnackbar("Something went Wrong", context);
    }
    getStationDetail();
  }

  Future<void> getStationDetail() async {
    setState(() {
      loading = true;
    });
    Map param = {
      'bus_id': widget.model.id,
    };
    var response = await apiBaseHelper.postAPICall(
        Uri.parse(
            "https://developmentalphawizz.com/ShareMyRide/api/pickup_drop_points"),
        param);
    setState(() {
      loading = false;
    });
    if (response['status']) {
      for (var v in response['data']['pickup_points']) {
        pickList.add(StationModel.fromJson(v));
      }
      for (var v in response['data']['drop_points']) {
        dropList.add(StationModel.fromJson(v));
      }
      if (pickList.isNotEmpty) {
        selectedPick = pickList.first;
      }
      if (dropList.isNotEmpty) {
        selectedDrop = dropList.first;
      }
    } else {
      setSnackbar("Something went Wrong", context);
    }
  }

  List<String> selectedSeat = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: commonGradient(),
          ),
        ),
        title: Text(
          widget.model.name ?? "",
        ),
      ),
      body: !loading
          ? model != null
              ? Column(
                  children: [
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              model!.jsonData ?? "",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              "Start - ${model!.startTime}   ->   End - ${model!.endTime}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Journey Date - ${widget.journeyDate}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Card(
                    //   child: Container(
                    //     width: double.infinity,
                    //     height: 100,
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Pickup Point",
                    //           style: Theme.of(context).textTheme.bodyLarge,
                    //         ),
                    //         const SizedBox(
                    //           height: 8,
                    //         ),
                    //         Text(
                    //           "${model?.pickupaddress??""}",
                    //           style: Theme.of(context).textTheme.bodyLarge,
                    //         ),
                    //         // Expanded(
                    //         //   child: ListView.builder(
                    //         //       scrollDirection: Axis.horizontal,
                    //         //       shrinkWrap: true,
                    //         //       itemCount: pickList.length,
                    //         //       itemBuilder: (context, index) {
                    //         //         return InkWell(
                    //         //           onTap: () {
                    //         //             setState(() {
                    //         //               selectedPick = pickList[index];
                    //         //             });
                    //         //           },
                    //         //           child: Container(
                    //         //             decoration: BoxDecoration(
                    //         //                 color:
                    //         //                     selectedPick == pickList[index]
                    //         //                         ? null
                    //         //                         : Colors.white,
                    //         //                 gradient:
                    //         //                     selectedPick == pickList[index]
                    //         //                         ? commonGradient()
                    //         //                         : null,
                    //         //                 borderRadius:
                    //         //                     BorderRadius.circular(8.0),
                    //         //                 border: Border.all(
                    //         //                     color: Colors.grey
                    //         //                         .withOpacity(0.3))),
                    //         //             margin: const EdgeInsets.all(5.0),
                    //         //             padding: const EdgeInsets.all(10.0),
                    //         //             child: Center(
                    //         //               child: Text(
                    //         //                 "${pickList[index].title}(${pickList[index].time})",
                    //         //                 style: Theme.of(context)
                    //         //                     .textTheme
                    //         //                     .labelMedium!
                    //         //                     .copyWith(
                    //         //                       color: selectedPick ==
                    //         //                               pickList[index]
                    //         //                           ? Colors.white
                    //         //                           : Colors.black,
                    //         //                     ),
                    //         //               ),
                    //         //             ),
                    //         //           ),
                    //         //         );
                    //         //       }),
                    //         // ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Card(
                    //   child: Container(
                    //     width: double.infinity,
                    //     height: 100,
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Drop Point",
                    //           style: Theme.of(context).textTheme.bodyLarge,
                    //         ),
                    //         const SizedBox(
                    //           height: 8,
                    //         ),
                    //         // Expanded(
                    //         //   child: ListView.builder(
                    //         //       scrollDirection: Axis.horizontal,
                    //         //       shrinkWrap: true,
                    //         //       itemCount: dropList.length,
                    //         //       itemBuilder: (context, index) {
                    //         //         return InkWell(
                    //         //           onTap: () {
                    //         //             setState(() {
                    //         //               selectedDrop = dropList[index];
                    //         //             });
                    //         //           },
                    //         //           child: Container(
                    //         //             decoration: BoxDecoration(
                    //         //                 color:
                    //         //                     selectedDrop == dropList[index]
                    //         //                         ? null
                    //         //                         : Colors.white,
                    //         //                 gradient:
                    //         //                     selectedDrop == dropList[index]
                    //         //                         ? commonGradient()
                    //         //                         : null,
                    //         //                 borderRadius:
                    //         //                     BorderRadius.circular(8.0),
                    //         //                 border: Border.all(
                    //         //                     color: Colors.grey
                    //         //                         .withOpacity(0.3))),
                    //         //             margin: const EdgeInsets.all(5.0),
                    //         //             padding: const EdgeInsets.all(10.0),
                    //         //             child: Center(
                    //         //               child: Text(
                    //         //                 "${dropList[index].title}(${dropList[index].time})",
                    //         //                 style: Theme.of(context)
                    //         //                     .textTheme
                    //         //                     .labelMedium!
                    //         //                     .copyWith(
                    //         //                       color: selectedDrop ==
                    //         //                               dropList[index]
                    //         //                           ? Colors.white
                    //         //                           : Colors.black,
                    //         //                     ),
                    //         //               ),
                    //         //             ),
                    //         //           ),
                    //         //         );
                    //         //       }),
                    //         // ),
                    //         Text(
                    //           "${model?.dropaddress??""}",
                    //           style: Theme.of(context).textTheme.bodyLarge,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Card(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Seat(Tap on seat for passenger details)",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Expanded(
                                child: model!.seatDesignList!.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount:
                                            model!.seatDesignList!.length,
                                        itemBuilder: (context, index) {
                                          int seatRow = model!.seatDesignList!
                                              .reduce((curr, next) =>
                                                  curr.length > next.length
                                                      ? curr
                                                      : next)
                                              .length;
                                          print(seatRow);
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 10,
                                            ),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: List.generate(
                                                    model!
                                                        .seatDesignList![index]
                                                        .length, (k) {
                                                  print(
                                                      "seat${(seatRow / 2).round()}");
                                                  return Row(
                                                    children: [
                                                      Stack(
                                                        alignment: Alignment.topCenter,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              if(model!
                                                                  .seatDesignList![index][k].passanger!=null&&model!
                                                                  .seatDesignList![index][k].passanger!.isNotEmpty){
                                                                showDialog(context: context,
                                                                    builder: (ctx){
                                                                  return AlertDialog(
                                                                    insetPadding: EdgeInsets.symmetric(horizontal: 10),
                                                                    title: Text("${model!
                                                                        .seatDesignList![index][k].passanger!.first.name}"),
                                                                    content:  Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text("Seat No. - ${model!
                                                                                .seatDesignList![index][k].passanger!.first.seatNo}"),
                                                                            Text("OTP - ${model!
                                                                                .seatDesignList![index][k].passanger!.first.otp}"),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(height: 5,),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text("Gender - ${model!
                                                                                .seatDesignList![index][k].passanger!.first.gender}"),
                                                                            Text("Age - ${model!
                                                                                .seatDesignList![index][k].passanger!.first.age}"),
                                                                                 ],
                                                                        ),
                                                                        const SizedBox(height: 5,),
                                                                        Text("Pickup Address - ${model!
                                                                            .seatDesignList![index][k].address?.pickupAddress}")
                                                                   , const SizedBox(height: 5,),
                                                                       Text("Drop Address - ${model!
                                                                            .seatDesignList![index][k].address?.dropAddress}"),


                                                                      ],
                                                                    ),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                          onPressed: (){
                                                                            Navigator.pop(context);
                                                                          },
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors.green,
                                                                            shadowColor: Colors.green,
                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          ),
                                                                          child: Text(
                                                                            "DONE!!",
                                                                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white,fontSize: 14),
                                                                          )
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                              }else{
                                                                setSnackbar("Seat Not Booked", context);
                                                              }

                                                              /*if (model!
                                                                      .seatDesignList![
                                                                          index][k]
                                                                      .isSelected ??
                                                                  false) {
                                                              } else {
                                                                if (model!
                                                                    .seatDesignList![
                                                                        index][k]
                                                                    .isChecked!) {
                                                                  setState(() {
                                                                    totalAmount -=
                                                                        double.parse(
                                                                            model!
                                                                                .amount!);
                                                                    model!
                                                                        .seatDesignList![
                                                                            index]
                                                                            [k]
                                                                        .isChecked = false;
                                                                    selectedSeat.remove(model!
                                                                        .seatDesignList![
                                                                            index]
                                                                            [k]
                                                                        .id
                                                                        .toString());
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    totalAmount +=
                                                                        double.parse(
                                                                            model!
                                                                                .amount!);
                                                                    model!
                                                                        .seatDesignList![
                                                                            index]
                                                                            [k]
                                                                        .isChecked = true;
                                                                    selectedSeat.add(model!
                                                                        .seatDesignList![
                                                                            index]
                                                                            [k]
                                                                        .id
                                                                        .toString());
                                                                  });
                                                                }
                                                              }*/
                                                            },
                                                            child: model!
                                                                        .seatDesignList![
                                                                            index]
                                                                            [k]
                                                                        .isSelected ??
                                                                    false
                                                                ? Image.asset(
                                                                    'assets/chair3.png',
                                                                    height: 30,
                                                                    width: 30,
                                                                    scale: 5)
                                                                : model!
                                                                        .seatDesignList![
                                                                            index]
                                                                            [k]
                                                                        .isChecked!
                                                                    ? Image.asset(
                                                                        'assets/chair2.png',
                                                                        height: 30,
                                                                        width: 30,
                                                                        scale: 5)
                                                                    : Image.asset(
                                                                        'assets/chair1.png',
                                                                        height: 30,
                                                                        width: 30,
                                                                        scale: 5),
                                                          ),
                                                          Text(
                                                            model!.seatDesignList![index][k].id.toString(),
                                                            style: TextStyle(fontSize: 10.0),
                                                          ),
                                                        ],
                                                      ),
                                                      ((seatRow / 2).round() -
                                                                      2) ==
                                                                  k &&
                                                              model!
                                                                      .seatDesignList![
                                                                          index]
                                                                      .length !=
                                                                  seatRow
                                                          ? const SizedBox(
                                                              width: 40,
                                                            )
                                                          : SizedBox(
                                                              width: 5,
                                                            )
                                                    ],
                                                  );
                                                })),
                                          );
                                        })
                                    : model!.seatDesign!.isNotEmpty
                                        ? ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount:
                                                model!.seatDesign!.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 10,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Stack(
                                                      alignment: Alignment.topCenter,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if(model!
                                                                .seatDesign![
                                                            index].passanger!=null&&model!
                                                                .seatDesign![
                                                            index].passanger!.isNotEmpty){
                                                              showDialog(context: context,
                                                                  builder: (ctx){
                                                                    return AlertDialog(
                                                                      insetPadding: EdgeInsets.symmetric(horizontal: 10),
                                                                      title: Text("${model!
                                                                          .seatDesign![
                                                                      index].passanger!.first.name}"),
                                                                      content:  Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text("Seat No. - ${model!
                                                                                  .seatDesign![
                                                                              index].passanger!.first.seatNo}"),
                                                                              Text("OTP - ${model!
                                                                                  .seatDesign![
                                                                              index].passanger!.first.otp}"),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 5,),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text("Gender - ${model!
                                                                                  .seatDesign![
                                                                              index].passanger!.first.gender}"),
                                                                              Text("Age - ${model!
                                                                                  .seatDesign![
                                                                              index].passanger!.first.age}"),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 5,),
                                                                          Text("Pickup Address - ${model!
                                                                              .seatDesign![index].address?.pickupAddress}")
                                                                          , const SizedBox(height: 5,),
                                                                          Text("Drop Address - ${model!
                                                                              .seatDesign![index].address?.dropAddress}"),
                                                                        ],
                                                                      ),
                                                                      actions: [
                                                                        ElevatedButton(
                                                                            onPressed: (){
                                                                              Navigator.pop(context);
                                                                            },
                                                                            style: ElevatedButton.styleFrom(
                                                                              backgroundColor: Colors.green,
                                                                              shadowColor: Colors.green,
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                            ),
                                                                            child: Text(
                                                                              "DONE!!",
                                                                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white,fontSize: 14),
                                                                            )
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            }else{
                                                              setSnackbar("Seat Not Booked", context);
                                                            }

                                                          },
                                                          child: model!
                                                                      .seatDesign![
                                                                          index]
                                                                      .isSelected ??
                                                                  false
                                                              ? Image.asset(
                                                                  'assets/chair3.png',
                                                                  height: 30,
                                                                  width: 30,
                                                                  scale: 5)
                                                              : model!
                                                                      .seatDesign![
                                                                          index]
                                                                      .isChecked!
                                                                  ? Image.asset(
                                                                      'assets/chair2.png',
                                                                      height: 30,
                                                                      width: 30,
                                                                      scale: 5)
                                                                  : Image.asset(
                                                                      'assets/chair1.png',
                                                                      height: 30,
                                                                      width: 30,
                                                                      scale: 5),
                                                        ),
                                                        Text(
                                                            model!.seatDesign![index].id.toString(),
                                                          style: TextStyle(fontSize: 6.0),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    )
                                                  ],
                                                ),
                                              );
                                            })
                                        : const SizedBox(
                                            width: 30,
                                          ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text("No Detail Found"),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
