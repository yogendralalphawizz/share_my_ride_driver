
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:smr_driver/Model/booking_model.dart';

import 'package:smr_driver/new_screens/notifications_page.dart';
import 'package:smr_driver/new_screens/vehicle_detail_screen.dart';
import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';


class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen();

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  int currentIndex = 0;

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  List<BookingModel> bookingList  =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    getBooking();
  }

  void getBooking()async{
    setState(() {
      loading = true;
    });
    Map param = {
      'driver_id': curUserId,
    };
    Map response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}bus_history_driver_all"), param);


    setState(() {
      loading = false;
      bookingList.clear();
    });
    log('${response}');
    if(response['status']){
      for(var v in response['data']){
        bookingList.add(BookingModel.fromJson(v));
      }
    }else{
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
            child:  userModel != null ?Image.network(
              "${userModel!.proPic}",fit: BoxFit.fill,):const SizedBox(),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: commonGradient(),
          ),
        ),
        title: Text(
          "Booking History",
        ),
        actions: [
          IconButton(
              onPressed: () {

                Navigator.push(context, MaterialPageRoute(builder: (c)=> NotificationsPage()));
              },
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              )),
        ],
      ),
      backgroundColor: MyColorName.scaffoldColor,
      body: !loading?bookingList.isNotEmpty?ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          itemCount: bookingList.length,
          itemBuilder: (context,index){
            BookingModel model = bookingList[index];
            return InkWell(
              onTap: (){
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
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            child: Text("Status - ${model.status!}",style: Theme.of(context).textTheme.labelMedium,),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonButton(
                            height: 4,
                            fontSize: 10.0,

                            loading: false,
                            title: model.busType == 'null' ? 'Type -'  : "Type - ${model.busType ?? ''}",
                            context: context,
                          ),
                          const SizedBox(width: 6,),
                          commonButton(
                            height: 4,
                            fontSize: 10.0,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Available Seats - ${model.availableSeats}",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            "Seats - ${model.noOfSeat}",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      commonButton(
                        height: 4,
                        fontSize: 10.0,
                        loading: false,
                        title: "Travel Name - ${model.name}(${model.vehicleNo})",
                        context: context,
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }):const Center(child: Text("No Booking Available"),):const Center(child: CircularProgressIndicator(),),
    );
  }
}
